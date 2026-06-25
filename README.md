# Meu Álbum da Copa 2026

Aplicativo de álbum de figurinhas da Copa do Mundo de 2026, com:

- **Backend** em **FastAPI + SQLite** (pasta [`backend/`](backend/)) — autenticação por JWT,
  catálogo de seleções/jogadores e a coleção de figurinhas de cada usuário.
- **Frontend** em **Flutter** (pasta `lib/`) — login, álbum por seleção, filtros,
  figurinhas repetidas, favoritas e lista de desejos, integrado ao backend.

O app Flutter consome a API; portanto, **suba o backend primeiro** e depois rode o frontend.

---

## 1. Backend (FastAPI + SQLite)

### Pré-requisitos
- **Python 3.14+**
- **[uv](https://docs.astral.sh/uv/)** (gerenciador de dependências/venv).
  Instale com `curl -LsSf https://astral.sh/uv/install.sh | sh` (Linux/macOS) ou veja a doc para Windows.
  > Alternativamente dá para usar `pip` com o `backend/requirements.txt`.

### Instalar dependências e rodar
A partir da **raiz do repositório** (as dependências Python estão no `pyproject.toml` da raiz):

```bash
uv sync                                  # cria o .venv e instala as dependências

cd backend
uv run uvicorn app.main:app --reload --host 0.0.0.0 --port 8000
```

- `--host 0.0.0.0` deixa a API acessível pelo emulador/aparelho (não só por `localhost`).
- Na **primeira execução** o banco SQLite é criado e populado automaticamente
  (seleções, jogadores, figurinhas e um usuário de teste).
- API: <http://127.0.0.1:8000> · Documentação interativa (Swagger): <http://127.0.0.1:8000/docs>

Sem o `uv`, usando `pip`:
```bash
cd backend
python -m venv .venv && source .venv/bin/activate   # Windows: .venv\Scripts\activate
pip install -r requirements.txt
uvicorn app.main:app --reload --host 0.0.0.0 --port 8000
```

### Usuário de teste
Criado automaticamente ao popular o banco:

| usuário | senha      |
|---------|------------|
| `admin` | `admin123` |

(o login também aceita o e-mail `admin@album.com`). Detalhes da API em [`backend/README.md`](backend/README.md).

---

## 2. Frontend (Flutter)

### Pré-requisitos
- **[Flutter SDK](https://docs.flutter.dev/get-started/install)** instalado e configurado
  (`flutter doctor` sem erros para a plataforma escolhida).
- Um destino para executar: emulador/aparelho Android, simulador iOS, Chrome/Edge (web)
  ou desktop Windows/macOS/Linux (requer as ferramentas nativas de cada plataforma).

### Instalar dependências
A partir da **raiz do repositório**:
```bash
flutter pub get      # instala pacotes e gera os arquivos de localização a partir dos .arb
```

### Rodar
1. Veja os destinos disponíveis:
   ```bash
   flutter devices
   ```
2. Execute em um dos destinos, por exemplo:
   ```bash
   flutter run -d chrome      # navegador
   flutter run -d windows     # app desktop Windows
   flutter run                # deixa o Flutter escolher/perguntar o destino
   ```
3. Faça login com o usuário de teste (`admin` / `admin123`) ou crie uma conta na tela de cadastro.

### Endereço da API (importante)
O app escolhe a URL base automaticamente conforme a plataforma:

| Plataforma                         | URL usada por padrão     |
|------------------------------------|--------------------------|
| Emulador Android                   | `http://10.0.2.2:8000`   |
| Web / Desktop / simulador iOS      | `http://127.0.0.1:8000`  |

Para apontar para outro servidor (ex.: testar em um **aparelho físico** usando o IP da sua máquina na rede):
```bash
flutter run --dart-define=API_BASE_URL=http://192.168.0.10:8000
```

---

## Outros comandos úteis

- `flutter analyze` — checagem estática do frontend.
- `flutter test` — testes automatizados do frontend.
- `uv run python -m app.seed` (dentro de `backend/`) — popula/repõe os dados do banco manualmente.

## Observações

- Se o caminho do projeto tiver **acentos** (ex.: `Repositórios`), o `flutter build web` /
  `run -d chrome` pode falhar por um bug do compilador de shaders do Flutter no Windows.
  Nesse caso, mova/copie o projeto para um caminho sem acentos.
- O banco fica em `backend/album_copa_2026.db` (ignorado pelo Git). Apague o arquivo para
  recriar os dados do zero.
- Em produção, defina a variável de ambiente `SECRET_KEY` no backend e restrinja o CORS
  (veja `backend/.env.example`).
