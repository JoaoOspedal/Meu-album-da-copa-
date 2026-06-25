"""Ponto de entrada para rodar a API.

Use este arquivo para iniciar o servidor (inclusive pelo botão ▶ Run da IDE).
Não execute `app/main.py` diretamente: ele usa imports relativos do pacote
`app` e precisa ser carregado como módulo (o que este launcher faz).
"""
from __future__ import annotations

import os
import sys

import uvicorn

# Garante que a pasta `backend` esteja no sys.path, independente de onde a IDE
# inicie o processo, para que o pacote `app` seja encontrado.
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))


if __name__ == "__main__":
    uvicorn.run(
        "app.main:app",
        host="127.0.0.1",
        port=8000,
        reload=True,
    )
