"""Catálogo público: nações, jogadores e figurinhas do álbum."""
from __future__ import annotations

from fastapi import APIRouter, Depends, HTTPException, Query, status
from sqlalchemy import select
from sqlalchemy.orm import Session

from ..database import get_db
from ..models import Nation, Player, Sticker, StickerType
from ..schemas import NationOut, PlayerOut, StickerOut

router = APIRouter(tags=["catálogo"])


@router.get("/nations", response_model=list[NationOut])
def list_nations(
    confederation: str | None = Query(default=None),
    db: Session = Depends(get_db),
) -> list[Nation]:
    stmt = select(Nation).order_by(Nation.name)
    if confederation:
        stmt = stmt.where(Nation.confederation == confederation)
    return list(db.scalars(stmt).all())


@router.get("/nations/{nation_id}", response_model=NationOut)
def get_nation(nation_id: int, db: Session = Depends(get_db)) -> Nation:
    nation = db.get(Nation, nation_id)
    if nation is None:
        raise HTTPException(status.HTTP_404_NOT_FOUND, "Nação não encontrada")
    return nation


@router.get("/nations/{nation_id}/players", response_model=list[PlayerOut])
def list_nation_players(nation_id: int, db: Session = Depends(get_db)) -> list[Player]:
    if db.get(Nation, nation_id) is None:
        raise HTTPException(status.HTTP_404_NOT_FOUND, "Nação não encontrada")
    stmt = select(Player).where(Player.nation_id == nation_id).order_by(Player.shirt_number)
    return list(db.scalars(stmt).all())


@router.get("/stickers", response_model=list[StickerOut])
def list_stickers(
    type: StickerType | None = Query(default=None, description="Filtra por jogador ou brasão"),
    nation_id: int | None = Query(default=None),
    db: Session = Depends(get_db),
) -> list[Sticker]:
    """Lista todas as figurinhas do álbum (catálogo completo)."""
    stmt = select(Sticker).order_by(Sticker.number)
    if type is not None:
        stmt = stmt.where(Sticker.type == type)
    if nation_id is not None:
        stmt = stmt.where(Sticker.nation_id == nation_id)
    return list(db.scalars(stmt).all())


@router.get("/stickers/{sticker_id}", response_model=StickerOut)
def get_sticker(sticker_id: int, db: Session = Depends(get_db)) -> Sticker:
    sticker = db.get(Sticker, sticker_id)
    if sticker is None:
        raise HTTPException(status.HTTP_404_NOT_FOUND, "Figurinha não encontrada")
    return sticker
