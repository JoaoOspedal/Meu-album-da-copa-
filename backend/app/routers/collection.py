"""Coleção do usuário: buscar, adicionar, remover, repetidas, favoritos e desejos."""
from __future__ import annotations

from fastapi import APIRouter, Depends, HTTPException, Query, status
from sqlalchemy import func, select
from sqlalchemy.orm import Session

from ..database import get_db
from ..deps import get_current_user
from ..models import Sticker, User, UserSticker
from ..schemas import (
    CollectionStats,
    FlagUpdate,
    StickerAmount,
    StickerQuantityUpdate,
    UserStickerOut,
)

router = APIRouter(prefix="/me/collection", tags=["coleção"])


def _get_or_create_entry(db: Session, user: User, sticker_id: int) -> UserSticker:
    """Garante que a figurinha existe e retorna a relação usuário-figurinha."""
    if db.get(Sticker, sticker_id) is None:
        raise HTTPException(status.HTTP_404_NOT_FOUND, "Figurinha não encontrada")

    entry = db.scalar(
        select(UserSticker).where(
            UserSticker.user_id == user.id, UserSticker.sticker_id == sticker_id
        )
    )
    if entry is None:
        entry = UserSticker(user_id=user.id, sticker_id=sticker_id, quantity=0)
        db.add(entry)
    return entry


@router.get("", response_model=list[UserStickerOut])
def my_stickers(
    owned_only: bool = Query(default=True, description="Apenas figurinhas que o usuário possui"),
    db: Session = Depends(get_db),
    user: User = Depends(get_current_user),
) -> list[UserSticker]:
    """Busca as figurinhas do usuário."""
    stmt = select(UserSticker).where(UserSticker.user_id == user.id)
    if owned_only:
        stmt = stmt.where(UserSticker.quantity > 0)
    return list(db.scalars(stmt).all())


@router.get("/duplicates", response_model=list[UserStickerOut])
def my_duplicates(
    db: Session = Depends(get_db),
    user: User = Depends(get_current_user),
) -> list[UserSticker]:
    """Figurinhas repetidas (quantidade > 1) — úteis para troca."""
    stmt = select(UserSticker).where(
        UserSticker.user_id == user.id, UserSticker.quantity > 1
    )
    return list(db.scalars(stmt).all())


@router.get("/favorites", response_model=list[UserStickerOut])
def my_favorites(
    db: Session = Depends(get_db),
    user: User = Depends(get_current_user),
) -> list[UserSticker]:
    stmt = select(UserSticker).where(
        UserSticker.user_id == user.id, UserSticker.is_favorite.is_(True)
    )
    return list(db.scalars(stmt).all())


@router.get("/wishlist", response_model=list[UserStickerOut])
def my_wishlist(
    db: Session = Depends(get_db),
    user: User = Depends(get_current_user),
) -> list[UserSticker]:
    """Lista de desejos (figurinhas marcadas como desejadas)."""
    stmt = select(UserSticker).where(
        UserSticker.user_id == user.id, UserSticker.is_wanted.is_(True)
    )
    return list(db.scalars(stmt).all())


@router.post("/stickers/{sticker_id}/add", response_model=UserStickerOut)
def add_sticker(
    sticker_id: int,
    payload: StickerAmount | None = None,
    db: Session = Depends(get_db),
    user: User = Depends(get_current_user),
) -> UserSticker:
    """Adiciona figurinha(s). Repetir a chamada aumenta a quantidade (repetidas)."""
    amount = payload.amount if payload else 1
    entry = _get_or_create_entry(db, user, sticker_id)
    entry.quantity += amount
    # ao obter a figurinha, deixa de ser apenas um desejo
    entry.is_wanted = False
    db.commit()
    db.refresh(entry)
    return entry


@router.post("/stickers/{sticker_id}/remove", response_model=UserStickerOut)
def remove_sticker(
    sticker_id: int,
    payload: StickerAmount | None = None,
    db: Session = Depends(get_db),
    user: User = Depends(get_current_user),
) -> UserSticker:
    """Remove figurinha(s) (diminui a quantidade, sem ficar negativa)."""
    amount = payload.amount if payload else 1
    entry = _get_or_create_entry(db, user, sticker_id)
    entry.quantity = max(0, entry.quantity - amount)
    db.commit()
    db.refresh(entry)
    return entry


@router.put("/stickers/{sticker_id}/quantity", response_model=UserStickerOut)
def set_quantity(
    sticker_id: int,
    payload: StickerQuantityUpdate,
    db: Session = Depends(get_db),
    user: User = Depends(get_current_user),
) -> UserSticker:
    """Define a quantidade absoluta de uma figurinha."""
    entry = _get_or_create_entry(db, user, sticker_id)
    entry.quantity = payload.quantity
    if payload.quantity > 0:
        entry.is_wanted = False
    db.commit()
    db.refresh(entry)
    return entry


@router.patch("/stickers/{sticker_id}/flags", response_model=UserStickerOut)
def update_flags(
    sticker_id: int,
    payload: FlagUpdate,
    db: Session = Depends(get_db),
    user: User = Depends(get_current_user),
) -> UserSticker:
    """Favoritar e/ou marcar como desejada (lista de desejos)."""
    entry = _get_or_create_entry(db, user, sticker_id)
    if payload.is_favorite is not None:
        entry.is_favorite = payload.is_favorite
    if payload.is_wanted is not None:
        entry.is_wanted = payload.is_wanted
    db.commit()
    db.refresh(entry)
    return entry


@router.get("/stats", response_model=CollectionStats)
def collection_stats(
    db: Session = Depends(get_db),
    user: User = Depends(get_current_user),
) -> CollectionStats:
    """Resumo do progresso do álbum do usuário."""
    total = db.scalar(select(func.count(Sticker.id))) or 0

    owned_unique = db.scalar(
        select(func.count(UserSticker.id)).where(
            UserSticker.user_id == user.id, UserSticker.quantity > 0
        )
    ) or 0
    duplicates = db.scalar(
        select(func.count(UserSticker.id)).where(
            UserSticker.user_id == user.id, UserSticker.quantity > 1
        )
    ) or 0
    duplicate_units = db.scalar(
        select(func.coalesce(func.sum(UserSticker.quantity - 1), 0)).where(
            UserSticker.user_id == user.id, UserSticker.quantity > 1
        )
    ) or 0
    favorites = db.scalar(
        select(func.count(UserSticker.id)).where(
            UserSticker.user_id == user.id, UserSticker.is_favorite.is_(True)
        )
    ) or 0
    wishlist = db.scalar(
        select(func.count(UserSticker.id)).where(
            UserSticker.user_id == user.id, UserSticker.is_wanted.is_(True)
        )
    ) or 0

    return CollectionStats(
        total_stickers=total,
        owned_unique=owned_unique,
        missing=max(0, total - owned_unique),
        duplicates=duplicates,
        duplicate_units=int(duplicate_units),
        favorites=favorites,
        wishlist=wishlist,
        completion_percent=round(owned_unique / total * 100, 1) if total else 0.0,
    )
