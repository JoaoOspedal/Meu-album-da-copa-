"""Popula o banco com nações, jogadores e gera as figurinhas do álbum.

Conjunto representativo da Copa do Mundo de 2026 (sediada por EUA, México e
Canadá). Inclui os três anfitriões e seleções tradicionais, com alguns craques
por seleção. Para cada nação é criada uma figurinha de BRASÃO e, para cada
jogador, uma figurinha de JOGADOR.

Execute diretamente:  python -m app.seed
"""
from __future__ import annotations

from sqlalchemy import select
from sqlalchemy.orm import Session

from .database import Base, SessionLocal, engine
from .models import Nation, Player, Sticker, StickerType, User
from .security import hash_password

# Usuário de teste/admin criado automaticamente ao popular o banco.
TEST_USER = {"username": "admin", "email": "admin@album.com", "password": "admin123"}

# (nome, código FIFA, confederação, grupo) + lista de jogadores
# jogador: (nome, posição, número, clube)
NATIONS: list[dict] = [
    {
        "name": "Brasil", "code": "BRA", "confederation": "CONMEBOL", "group": "A",
        "players": [
            ("Vini Jr.", "FW", 7, "Real Madrid"),
            ("Rodrygo", "FW", 10, "Real Madrid"),
            ("Alisson", "GK", 1, "Liverpool"),
            ("Marquinhos", "DF", 4, "PSG"),
            ("Bruno Guimarães", "MF", 8, "Newcastle"),
        ],
    },
    {
        "name": "Argentina", "code": "ARG", "confederation": "CONMEBOL", "group": "B",
        "players": [
            ("Lionel Messi", "FW", 10, "Inter Miami"),
            ("Julián Álvarez", "FW", 9, "Atlético Madrid"),
            ("Emiliano Martínez", "GK", 23, "Aston Villa"),
            ("Enzo Fernández", "MF", 24, "Chelsea"),
            ("Cristian Romero", "DF", 13, "Tottenham"),
        ],
    },
    {
        "name": "França", "code": "FRA", "confederation": "UEFA", "group": "C",
        "players": [
            ("Kylian Mbappé", "FW", 10, "Real Madrid"),
            ("Antoine Griezmann", "FW", 7, "Atlético Madrid"),
            ("Aurélien Tchouaméni", "MF", 8, "Real Madrid"),
            ("Mike Maignan", "GK", 16, "Milan"),
        ],
    },
    {
        "name": "Inglaterra", "code": "ENG", "confederation": "UEFA", "group": "D",
        "players": [
            ("Harry Kane", "FW", 9, "Bayern de Munique"),
            ("Jude Bellingham", "MF", 10, "Real Madrid"),
            ("Bukayo Saka", "FW", 7, "Arsenal"),
            ("Jordan Pickford", "GK", 1, "Everton"),
        ],
    },
    {
        "name": "Portugal", "code": "POR", "confederation": "UEFA", "group": "E",
        "players": [
            ("Cristiano Ronaldo", "FW", 7, "Al Nassr"),
            ("Bruno Fernandes", "MF", 8, "Manchester United"),
            ("Rafael Leão", "FW", 10, "Milan"),
            ("Diogo Costa", "GK", 22, "Porto"),
        ],
    },
    {
        "name": "Espanha", "code": "ESP", "confederation": "UEFA", "group": "F",
        "players": [
            ("Rodri", "MF", 16, "Manchester City"),
            ("Lamine Yamal", "FW", 19, "Barcelona"),
            ("Pedri", "MF", 8, "Barcelona"),
            ("Unai Simón", "GK", 23, "Athletic Bilbao"),
        ],
    },
    {
        "name": "Alemanha", "code": "GER", "confederation": "UEFA", "group": "G",
        "players": [
            ("Jamal Musiala", "MF", 10, "Bayern de Munique"),
            ("Florian Wirtz", "MF", 17, "Bayer Leverkusen"),
            ("Kai Havertz", "FW", 7, "Arsenal"),
            ("Manuel Neuer", "GK", 1, "Bayern de Munique"),
        ],
    },
    {
        "name": "Estados Unidos", "code": "USA", "confederation": "CONCACAF", "group": "H",
        "players": [
            ("Christian Pulisic", "FW", 10, "Milan"),
            ("Weston McKennie", "MF", 8, "Juventus"),
            ("Matt Turner", "GK", 1, "Crystal Palace"),
        ],
    },
    {
        "name": "México", "code": "MEX", "confederation": "CONCACAF", "group": "A",
        "players": [
            ("Santiago Giménez", "FW", 9, "Milan"),
            ("Edson Álvarez", "MF", 4, "West Ham"),
            ("Guillermo Ochoa", "GK", 13, "AVS"),
        ],
    },
    {
        "name": "Canadá", "code": "CAN", "confederation": "CONCACAF", "group": "B",
        "players": [
            ("Alphonso Davies", "DF", 19, "Bayern de Munique"),
            ("Jonathan David", "FW", 20, "Lille"),
        ],
    },
    {
        "name": "Países Baixos", "code": "NED", "confederation": "UEFA", "group": "C",
        "players": [
            ("Virgil van Dijk", "DF", 4, "Liverpool"),
            ("Cody Gakpo", "FW", 11, "Liverpool"),
            ("Frenkie de Jong", "MF", 21, "Barcelona"),
        ],
    },
    {
        "name": "Croácia", "code": "CRO", "confederation": "UEFA", "group": "D",
        "players": [
            ("Luka Modrić", "MF", 10, "Real Madrid"),
            ("Joško Gvardiol", "DF", 20, "Manchester City"),
        ],
    },
    {
        "name": "Uruguai", "code": "URU", "confederation": "CONMEBOL", "group": "E",
        "players": [
            ("Federico Valverde", "MF", 15, "Real Madrid"),
            ("Darwin Núñez", "FW", 9, "Liverpool"),
        ],
    },
    {
        "name": "Bélgica", "code": "BEL", "confederation": "UEFA", "group": "F",
        "players": [
            ("Kevin De Bruyne", "MF", 7, "Manchester City"),
            ("Romelu Lukaku", "FW", 9, "Napoli"),
        ],
    },
    {
        "name": "Marrocos", "code": "MAR", "confederation": "CAF", "group": "G",
        "players": [
            ("Achraf Hakimi", "DF", 2, "PSG"),
            ("Brahim Díaz", "MF", 7, "Real Madrid"),
        ],
    },
    {
        "name": "Japão", "code": "JPN", "confederation": "AFC", "group": "H",
        "players": [
            ("Takefusa Kubo", "FW", 11, "Real Sociedad"),
            ("Kaoru Mitoma", "FW", 14, "Brighton"),
        ],
    },
]


def ensure_test_user(db: Session) -> None:
    """Cria o usuário de teste/admin se ainda não existir (idempotente)."""
    exists = db.scalar(select(User).where(User.username == TEST_USER["username"]))
    if exists is not None:
        return
    db.add(
        User(
            username=TEST_USER["username"],
            email=TEST_USER["email"],
            hashed_password=hash_password(TEST_USER["password"]),
        )
    )
    db.commit()
    print(f"Usuário de teste criado: {TEST_USER['username']} / {TEST_USER['password']}")


def seed(db: Session) -> None:
    ensure_test_user(db)

    if db.scalar(select(Nation).limit(1)) is not None:
        print("Banco já populado; nada a fazer.")
        return

    sticker_number = 1
    for n in NATIONS:
        nation = Nation(
            name=n["name"],
            code=n["code"],
            confederation=n["confederation"],
            group_name=n["group"],
        )
        db.add(nation)
        db.flush()  # garante nation.id

        # Figurinha de brasão/símbolo da seleção
        db.add(
            Sticker(
                number=sticker_number,
                type=StickerType.BADGE,
                title=f"Brasão — {nation.name}",
                nation_id=nation.id,
            )
        )
        sticker_number += 1

        # Jogadores + figurinhas de jogador
        for name, position, number, club in n["players"]:
            player = Player(
                name=name,
                nation_id=nation.id,
                position=position,
                shirt_number=number,
                club=club,
            )
            db.add(player)
            db.flush()
            db.add(
                Sticker(
                    number=sticker_number,
                    type=StickerType.PLAYER,
                    title=name,
                    nation_id=nation.id,
                    player_id=player.id,
                )
            )
            sticker_number += 1

    db.commit()
    print(f"Populado: {len(NATIONS)} nações e {sticker_number - 1} figurinhas.")


def init_and_seed() -> None:
    Base.metadata.create_all(bind=engine)
    with SessionLocal() as db:
        seed(db)


if __name__ == "__main__":
    init_and_seed()
