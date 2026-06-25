"""Aplicação FastAPI — Backend do Álbum da Copa do Mundo 2026.

Pensado para consumo por um app Flutter:
  - Autenticação via JWT (Bearer token).
  - Respostas JSON.
  - Documentação interativa em /docs.
"""
from __future__ import annotations

from contextlib import asynccontextmanager

from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

from .config import settings
from .database import Base, SessionLocal, engine
from .routers import auth, catalog, collection
from .seed import seed


@asynccontextmanager
async def lifespan(app: FastAPI):
    # Cria as tabelas e popula o catálogo na primeira execução.
    Base.metadata.create_all(bind=engine)
    with SessionLocal() as db:
        seed(db)
    yield


app = FastAPI(
    title="Álbum da Copa 2026 — API",
    description="Backend para o app de álbum de figurinhas da Copa do Mundo de 2026.",
    version="1.0.0",
    lifespan=lifespan,
)

app.add_middleware(
    CORSMiddleware,
    allow_origins=settings.cors_origins,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

app.include_router(auth.router)
app.include_router(catalog.router)
app.include_router(collection.router)


@app.get("/", tags=["status"])
def root() -> dict:
    return {"app": "Álbum da Copa 2026", "status": "ok", "docs": "/docs"}


@app.get("/health", tags=["status"])
def health() -> dict:
    return {"status": "healthy"}
