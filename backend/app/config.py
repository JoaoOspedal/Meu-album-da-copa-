"""Configurações da aplicação.

Os valores podem ser sobrescritos por variáveis de ambiente ou por um arquivo
`.env` na raiz da pasta `backend`.
"""
from __future__ import annotations

from pydantic_settings import BaseSettings, SettingsConfigDict


class Settings(BaseSettings):
    model_config = SettingsConfigDict(env_file=".env", env_file_encoding="utf-8", extra="ignore")

    # Banco
    database_url: str = "sqlite:///./album_copa_2026.db"

    # Segurança / JWT
    # IMPORTANTE: troque esta chave em produção (ex.: variável de ambiente SECRET_KEY).
    secret_key: str = "troque-esta-chave-secreta-em-producao-2026"
    algorithm: str = "HS256"
    access_token_expire_minutes: int = 60 * 24 * 7  # 7 dias

    # CORS – em produção restrinja para o domínio do app.
    cors_origins: list[str] = ["*"]


settings = Settings()
