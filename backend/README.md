# Álbum da Copa 2026 — Backend

API em **FastAPI + SQLite** para o app Flutter de álbum de figurinhas da Copa do
Mundo de 2026. Inclui autenticação por JWT, catálogo de nações/jogadores e a
coleção de figurinhas de cada usuário.

## Stack
- FastAPI + Uvicorn
- SQLAlchemy 2.0 (ORM) + SQLite
- JWT (PyJWT) para autenticação
- Senhas com PBKDF2-SHA256 (biblioteca padrão, sem dependências nativas)

## Estrutura
```
backend/
  app/
    main.py          # aplicação FastAPI (cria tabelas + popula no startup)
    config.py        # configurações (.env)
    database.py      # engine/sessão SQLite
    models.py        # tabelas: User, Nation, Player, Sticker, UserSticker
    schemas.py       # schemas Pydantic (entrada/saída)
    security.py      # hash de senha + tokens JWT
    deps.py          # dependência do usuário autenticado
    seed.py          # popula nações, jogadores e figurinhas
    routers/
      auth.py        # /auth (registro, login, me)
      catalog.py     # /nations, /players, /stickers (catálogo)
      collection.py  # /me/collection (coleção do usuário)
  requirements.txt
  .env.example
```

## Como rodar

O projeto usa **uv** (as dependências já estão no `pyproject.toml` da raiz):

```bash
# na raiz do repositório
uv sync

# subir a API (cria e popula o banco automaticamente no primeiro start)
cd backend
uv run uvicorn app.main:app --reload
```

Sem uv, com pip:
```bash
cd backend
python -m venv .venv && source .venv/bin/activate
pip install -r requirements.txt
uvicorn app.main:app --reload
```

- API: <http://127.0.0.1:8000>
- Documentação interativa (Swagger): <http://127.0.0.1:8000/docs>

Para popular o banco manualmente: `uv run python -m app.seed`.

## Modelo de dados

| Tabela          | Descrição |
|-----------------|-----------|
| `users`         | login do usuário (username, e-mail, senha com hash) |
| `nations`       | seleção/nação (nome, código FIFA, confederação, grupo) |
| `players`       | jogador vinculado a uma nação |
| `stickers`      | figurinha do álbum — `type = player` (jogador) ou `badge` (brasão/símbolo) |
| `user_stickers` | o que o usuário possui: `quantity`, `is_favorite`, `is_wanted` |

Figurinhas **repetidas** = `quantity > 1`. **Lista de desejos** = `is_wanted = true`.
**Favoritos** = `is_favorite = true`.

## Endpoints

### Autenticação — `/auth`
| Método | Rota | Descrição |
|--------|------|-----------|
| POST | `/auth/register` | cria usuário e retorna token |
| POST | `/auth/login` | login (form `username`+`password`; aceita e-mail no `username`) |
| GET  | `/auth/me` | dados do usuário autenticado |

Use o token no header: `Authorization: Bearer <access_token>`.

### Catálogo (público)
| Método | Rota | Descrição |
|--------|------|-----------|
| GET | `/nations` | lista nações (filtro opcional `?confederation=`) |
| GET | `/nations/{id}` | detalhe da nação |
| GET | `/nations/{id}/players` | jogadores da nação |
| GET | `/stickers` | catálogo de figurinhas (filtros `?type=player|badge`, `?nation_id=`) |
| GET | `/stickers/{id}` | detalhe da figurinha |

### Coleção do usuário — `/me/collection` (requer token)
| Método | Rota | Descrição |
|--------|------|-----------|
| GET   | `/me/collection` | minhas figurinhas (`?owned_only=true`) |
| GET   | `/me/collection/duplicates` | repetidas (quantidade > 1) |
| GET   | `/me/collection/favorites` | favoritas |
| GET   | `/me/collection/wishlist` | lista de desejos |
| GET   | `/me/collection/stats` | progresso do álbum |
| POST  | `/me/collection/stickers/{id}/add` | adicionar (body opcional `{"amount":N}`) |
| POST  | `/me/collection/stickers/{id}/remove` | remover (body opcional `{"amount":N}`) |
| PUT   | `/me/collection/stickers/{id}/quantity` | definir quantidade absoluta |
| PATCH | `/me/collection/stickers/{id}/flags` | favoritar/desejar (`{"is_favorite":true,"is_wanted":false}`) |

## Exemplo (curl)
```bash
# registro
curl -X POST http://127.0.0.1:8000/auth/register \
  -H 'Content-Type: application/json' \
  -d '{"username":"vini","email":"vini@test.com","password":"senha123"}'

# login -> pega o access_token
TOKEN=$(curl -s -X POST http://127.0.0.1:8000/auth/login \
  -d 'username=vini&password=senha123' | python -c 'import sys,json;print(json.load(sys.stdin)["access_token"])')

# adicionar a figurinha 1
curl -X POST http://127.0.0.1:8000/me/collection/stickers/1/add \
  -H "Authorization: Bearer $TOKEN"
```

## Notas para o app Flutter
- Após o login, guarde o `access_token` (ex.: `flutter_secure_storage`) e envie-o
  no header `Authorization: Bearer ...` em todas as chamadas protegidas.
- Em produção, defina `SECRET_KEY` via variável de ambiente e restrinja `CORS_ORIGINS`.
- Para rodar no emulador Android, a máquina host é acessível em `http://10.0.2.2:8000`.
