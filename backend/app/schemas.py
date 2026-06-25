"""Schemas Pydantic (entrada/saída da API)."""
from __future__ import annotations

from datetime import datetime

from pydantic import BaseModel, ConfigDict, EmailStr, Field

from .models import StickerType


# ---------- Auth / Usuário ----------
class UserCreate(BaseModel):
    username: str = Field(min_length=3, max_length=50)
    email: EmailStr
    password: str = Field(min_length=6, max_length=128)


class UserOut(BaseModel):
    model_config = ConfigDict(from_attributes=True)

    id: int
    username: str
    email: EmailStr
    is_active: bool
    created_at: datetime


class Token(BaseModel):
    access_token: str
    token_type: str = "bearer"
    user: UserOut


# ---------- Nação ----------
class NationOut(BaseModel):
    model_config = ConfigDict(from_attributes=True)

    id: int
    name: str
    code: str
    confederation: str | None = None
    group_name: str | None = None
    flag_url: str | None = None


# ---------- Jogador ----------
class PlayerOut(BaseModel):
    model_config = ConfigDict(from_attributes=True)

    id: int
    name: str
    nation_id: int
    position: str | None = None
    shirt_number: int | None = None
    club: str | None = None
    photo_url: str | None = None


# ---------- Figurinha ----------
class StickerOut(BaseModel):
    model_config = ConfigDict(from_attributes=True)

    id: int
    number: int
    type: StickerType
    title: str
    image_url: str | None = None
    nation: NationOut | None = None
    player: PlayerOut | None = None


# ---------- Relação usuário-figurinha ----------
class UserStickerOut(BaseModel):
    """Figurinha + estado do usuário (quantidade, favorito, desejo)."""

    model_config = ConfigDict(from_attributes=True)

    sticker: StickerOut
    quantity: int
    is_favorite: bool
    is_wanted: bool
    updated_at: datetime


class StickerQuantityUpdate(BaseModel):
    quantity: int = Field(ge=0, description="Quantidade absoluta a definir (>1 = repetidas).")


class StickerAmount(BaseModel):
    amount: int = Field(default=1, ge=1, description="Quantas unidades adicionar/remover.")


class FlagUpdate(BaseModel):
    is_favorite: bool | None = None
    is_wanted: bool | None = None


class CollectionStats(BaseModel):
    total_stickers: int
    owned_unique: int
    missing: int
    duplicates: int          # nº de figurinhas com quantidade > 1
    duplicate_units: int     # total de unidades excedentes (repetidas para troca)
    favorites: int
    wishlist: int
    completion_percent: float
