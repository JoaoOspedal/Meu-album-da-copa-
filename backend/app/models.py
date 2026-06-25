"""Modelos ORM (tabelas) do álbum da Copa do Mundo 2026.

Entidades:
  - User        -> login/usuário
  - Nation      -> seleção/nação
  - Player      -> jogador de uma seleção
  - Sticker     -> figurinha do álbum (JOGADOR ou BRASÃO/SÍMBOLO da seleção)
  - UserSticker -> relação do que o usuário possui (quantidade, favorito, desejo)
"""
from __future__ import annotations

import enum
from datetime import datetime, timezone

from sqlalchemy import (
    Boolean,
    DateTime,
    Enum,
    ForeignKey,
    Integer,
    String,
    UniqueConstraint,
)
from sqlalchemy.orm import Mapped, mapped_column, relationship

from .database import Base


def _utcnow() -> datetime:
    return datetime.now(timezone.utc)


class StickerType(str, enum.Enum):
    """Diferencia figurinha de jogador da de brasão/símbolo da seleção."""

    PLAYER = "player"   # figurinha de jogador
    BADGE = "badge"     # brasão / símbolo da seleção


class User(Base):
    __tablename__ = "users"

    id: Mapped[int] = mapped_column(primary_key=True)
    username: Mapped[str] = mapped_column(String(50), unique=True, index=True, nullable=False)
    email: Mapped[str] = mapped_column(String(255), unique=True, index=True, nullable=False)
    hashed_password: Mapped[str] = mapped_column(String(255), nullable=False)
    is_active: Mapped[bool] = mapped_column(Boolean, default=True, nullable=False)
    created_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), default=_utcnow, nullable=False)

    stickers: Mapped[list["UserSticker"]] = relationship(
        back_populates="user", cascade="all, delete-orphan"
    )


class Nation(Base):
    __tablename__ = "nations"

    id: Mapped[int] = mapped_column(primary_key=True)
    name: Mapped[str] = mapped_column(String(100), unique=True, index=True, nullable=False)
    code: Mapped[str] = mapped_column(String(3), unique=True, index=True, nullable=False)  # FIFA, ex.: BRA
    confederation: Mapped[str | None] = mapped_column(String(20), nullable=True)  # CONMEBOL, UEFA, etc.
    group_name: Mapped[str | None] = mapped_column(String(5), nullable=True)  # grupo no torneio
    flag_url: Mapped[str | None] = mapped_column(String(500), nullable=True)

    players: Mapped[list["Player"]] = relationship(
        back_populates="nation", cascade="all, delete-orphan"
    )
    stickers: Mapped[list["Sticker"]] = relationship(back_populates="nation")


class Player(Base):
    __tablename__ = "players"

    id: Mapped[int] = mapped_column(primary_key=True)
    name: Mapped[str] = mapped_column(String(120), index=True, nullable=False)
    nation_id: Mapped[int] = mapped_column(ForeignKey("nations.id"), nullable=False)
    position: Mapped[str | None] = mapped_column(String(30), nullable=True)  # GK, DF, MF, FW
    shirt_number: Mapped[int | None] = mapped_column(Integer, nullable=True)
    club: Mapped[str | None] = mapped_column(String(120), nullable=True)
    photo_url: Mapped[str | None] = mapped_column(String(500), nullable=True)

    nation: Mapped["Nation"] = relationship(back_populates="players")
    sticker: Mapped["Sticker"] = relationship(back_populates="player", uselist=False)


class Sticker(Base):
    """Figurinha do álbum. Pode ser de jogador ou de brasão da seleção."""

    __tablename__ = "stickers"

    id: Mapped[int] = mapped_column(primary_key=True)
    number: Mapped[int] = mapped_column(Integer, unique=True, index=True, nullable=False)  # número no álbum
    type: Mapped[StickerType] = mapped_column(Enum(StickerType), nullable=False)
    title: Mapped[str] = mapped_column(String(150), nullable=False)
    image_url: Mapped[str | None] = mapped_column(String(500), nullable=True)

    nation_id: Mapped[int | None] = mapped_column(ForeignKey("nations.id"), nullable=True)
    player_id: Mapped[int | None] = mapped_column(ForeignKey("players.id"), nullable=True)

    nation: Mapped["Nation | None"] = relationship(back_populates="stickers")
    player: Mapped["Player | None"] = relationship(back_populates="sticker")


class UserSticker(Base):
    """Relação do que o usuário possui de cada figurinha."""

    __tablename__ = "user_stickers"
    __table_args__ = (UniqueConstraint("user_id", "sticker_id", name="uq_user_sticker"),)

    id: Mapped[int] = mapped_column(primary_key=True)
    user_id: Mapped[int] = mapped_column(ForeignKey("users.id"), index=True, nullable=False)
    sticker_id: Mapped[int] = mapped_column(ForeignKey("stickers.id"), index=True, nullable=False)

    quantity: Mapped[int] = mapped_column(Integer, default=0, nullable=False)  # >1 => repetidas
    is_favorite: Mapped[bool] = mapped_column(Boolean, default=False, nullable=False)  # favoritar
    is_wanted: Mapped[bool] = mapped_column(Boolean, default=False, nullable=False)  # lista de desejos
    updated_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True), default=_utcnow, onupdate=_utcnow, nullable=False
    )

    user: Mapped["User"] = relationship(back_populates="stickers")
    sticker: Mapped["Sticker"] = relationship()
