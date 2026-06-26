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

# Código FIFA -> código ISO 3166-1 alpha-2 (usado pelo flagcdn.com para a imagem da bandeira)
FIFA_TO_ISO2 = {
    "BRA": "br",
    "ARG": "ar",
    "FRA": "fr",
    "ENG": "gb-eng",
    "POR": "pt",
    "ESP": "es",
    "GER": "de",
    "USA": "us",
    "MEX": "mx",
    "CAN": "ca",
    "NED": "nl",
    "CRO": "hr",
    "URU": "uy",
    "BEL": "be",
    "MAR": "ma",
    "JPN": "jp",
}


def flag_url_for(fifa_code: str) -> str | None:
    iso2 = FIFA_TO_ISO2.get(fifa_code)
    return f"https://flagcdn.com/w320/{iso2}.png" if iso2 else None


# Nome do jogador -> foto (thumbnail do Wikimedia Commons, licença livre/CC, hotlink-friendly)
PLAYER_PHOTOS: dict[str, str] = {
    "Vini Jr.": "https://commons.wikimedia.org/wiki/Special:FilePath/Vinicius_Jr_2021.jpg?width=400",
    "Rodrygo": "https://commons.wikimedia.org/wiki/Special:FilePath/Rodrygo_2020.png?width=400",
    "Alisson": "https://commons.wikimedia.org/wiki/Special:FilePath/Alisson_Becker_04012026_(1).jpg?width=400",
    "Marquinhos": "https://commons.wikimedia.org/wiki/Special:FilePath/Marquinhos_(Marcos_Ao%C3%A1s_Corr%C3%AAa),_PSG.JPG?width=400",
    "Bruno Guimarães": "https://commons.wikimedia.org/wiki/Special:FilePath/Bruno_Guimar%C3%A3es.png?width=400",
    "Lionel Messi": "https://commons.wikimedia.org/wiki/Special:FilePath/Lionel_Messi_NE_Revolution_Inter_Miami_7.9.25-055.jpg?width=400",
    "Julián Álvarez": "https://commons.wikimedia.org/wiki/Special:FilePath/Juli%C3%A1n_%C3%81lvarez_(footballer)_2023.jpg?width=400",
    "Emiliano Martínez": "https://commons.wikimedia.org/wiki/Special:FilePath/Emiliano_Martinez.jpg?width=400",
    "Enzo Fernández": "https://commons.wikimedia.org/wiki/Special:FilePath/Enzo_Fern%C3%A1ndez.jpg?width=400",
    "Cristian Romero": "https://commons.wikimedia.org/wiki/Special:FilePath/Cuti_Romero_Tottenham_2022.jpg?width=400",
    "Kylian Mbappé": "https://commons.wikimedia.org/wiki/Special:FilePath/Kylian_Mbappe_France_v_Senegal_16_June_2026-391_(cropped).jpg?width=400",
    "Antoine Griezmann": "https://commons.wikimedia.org/wiki/Special:FilePath/Antoine_Griezmann_(51100409504)_(cropped).jpg?width=400",
    "Aurélien Tchouaméni": "https://commons.wikimedia.org/wiki/Special:FilePath/Aurelien_Tchouameni_France_v_Senegal_16_June_2026-447_(cropped).jpg?width=400",
    "Mike Maignan": "https://commons.wikimedia.org/wiki/Special:FilePath/Maignan_1_Milan_2022.jpg?width=400",
    "Harry Kane": "https://commons.wikimedia.org/wiki/Special:FilePath/Harry_Kane_on_October_10%2C_2023.jpg?width=400",
    "Jude Bellingham": "https://commons.wikimedia.org/wiki/Special:FilePath/Jude_Bellingham_2020_(cropped2).jpg?width=400",
    "Bukayo Saka": "https://commons.wikimedia.org/wiki/Special:FilePath/1_bukayo_saka_arsenal_2025_(cropped).jpg?width=400",
    "Jordan Pickford": "https://commons.wikimedia.org/wiki/Special:FilePath/Jordan_Pickford_2022-07-16_1.jpg?width=400",
    "Cristiano Ronaldo": "https://commons.wikimedia.org/wiki/Special:FilePath/Cristiano_Ronaldo_in_2023.jpg?width=400",
    "Bruno Fernandes": "https://commons.wikimedia.org/wiki/Special:FilePath/Bruno_Fernandes_00-07-14.16.png?width=400",
    "Rafael Leão": "https://commons.wikimedia.org/wiki/Special:FilePath/Rafael_Le%C3%A3o_WC2022.jpg?width=400",
    "Diogo Costa": "https://commons.wikimedia.org/wiki/Special:FilePath/Diogo_Costa.jpg?width=400",
    "Rodri": "https://commons.wikimedia.org/wiki/Special:FilePath/Rodri2024.jpg?width=400",
    "Lamine Yamal": "https://commons.wikimedia.org/wiki/Special:FilePath/Lamine_Yamal_in_2025.jpg?width=400",
    "Pedri": "https://commons.wikimedia.org/wiki/Special:FilePath/Pedri.jpg?width=400",
    "Unai Simón": "https://commons.wikimedia.org/wiki/Special:FilePath/Unai_Sim%C3%B3n.jpg?width=400",
    "Jamal Musiala": "https://commons.wikimedia.org/wiki/Special:FilePath/Jamal_Musiala_2022_%28cropped%29.jpg?width=400",
    "Florian Wirtz": "https://commons.wikimedia.org/wiki/Special:FilePath/Florian_Wirtz_2024.jpg?width=400",
    "Kai Havertz": "https://commons.wikimedia.org/wiki/Special:FilePath/Kai_Havertz_2020.jpg?width=400",
    "Manuel Neuer": "https://commons.wikimedia.org/wiki/Special:FilePath/Manuel_Neuer_2020.jpg?width=400",
    "Christian Pulisic": "https://commons.wikimedia.org/wiki/Special:FilePath/Milan_Cagliari_2025_-_Pulisic.jpg?width=400",
    "Weston McKennie": "https://commons.wikimedia.org/wiki/Special:FilePath/USAvVEN_2019-06-09_-_Weston_McKennie_%2851170534993%29_%28close-up%29.jpg?width=400",
    "Matt Turner": "https://commons.wikimedia.org/wiki/Special:FilePath/Matt_Turner_WC2022_%28cropped%29.jpg?width=400",
    "Santiago Giménez": "https://commons.wikimedia.org/wiki/Special:FilePath/Santiago_Gim%C3%A9nez_-_2023.jpg?width=400",
    "Edson Álvarez": "https://commons.wikimedia.org/wiki/Special:FilePath/Edson_%C3%81lvarez.png?width=400",
    "Guillermo Ochoa": "https://commons.wikimedia.org/wiki/Special:FilePath/Francisco_Guillermo_Ochoa_2014.jpg?width=400",
    "Alphonso Davies": "https://commons.wikimedia.org/wiki/Special:FilePath/Alphonso_Davies_-_cropped.jpg?width=400",
    "Jonathan David": "https://commons.wikimedia.org/wiki/Special:FilePath/JonathanDavidFCSalzburg%28cropped%29.jpg?width=400",
    "Virgil van Dijk": "https://commons.wikimedia.org/wiki/Special:FilePath/Virgil_van_Dijk_2019.jpg?width=400",
    "Cody Gakpo": "https://commons.wikimedia.org/wiki/Special:FilePath/Cody_Gakpo_06042025_%281%29_%28cropped%29.jpg?width=400",
    "Frenkie de Jong": "https://commons.wikimedia.org/wiki/Special:FilePath/Frenkie_De_Jong_%282025%29_%28cropped%29.png?width=400",
    "Luka Modrić": "https://commons.wikimedia.org/wiki/Special:FilePath/Luka_Modric_2018.png?width=400",
    "Joško Gvardiol": "https://commons.wikimedia.org/wiki/Special:FilePath/2021_Jo%C5%A1ko_Gvardiol_%28cropped%29.jpg?width=400",
    "Federico Valverde": "https://commons.wikimedia.org/wiki/Special:FilePath/Federico_Valverde_2021_%28cropped%29.jpg?width=400",
    "Darwin Núñez": "https://commons.wikimedia.org/wiki/Special:FilePath/Darwin_N%C3%BA%C3%B1ez_%28cropped%29.jpg?width=400",
    "Kevin De Bruyne": "https://commons.wikimedia.org/wiki/Special:FilePath/Kevin_De_Bruyne.jpg?width=400",
    "Romelu Lukaku": "https://commons.wikimedia.org/wiki/Special:FilePath/Romelu_Lukaku_kick_off_Fulham_v_WBA_%28cropped%29.jpg?width=400",
    "Achraf Hakimi": "https://commons.wikimedia.org/wiki/Special:FilePath/Achraf_Hakimi_PSG.jpg?width=400",
    "Brahim Díaz": "https://commons.wikimedia.org/wiki/Special:FilePath/Brahim_Diaz_Morocco_v_Norway_7_June_2026-36_%28cropped%29.jpg?width=400",
    "Takefusa Kubo": "https://commons.wikimedia.org/wiki/Special:FilePath/Takefusa_Kubo_2019.png?width=400",
    "Kaoru Mitoma": "https://commons.wikimedia.org/wiki/Special:FilePath/Kaoru_Mitoma_%282022%29.jpg?width=400",
}


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
            flag_url=flag_url_for(n["code"]),
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
                image_url=nation.flag_url,
            )
        )
        sticker_number += 1

        # Jogadores + figurinhas de jogador
        for name, position, number, club in n["players"]:
            photo_url = PLAYER_PHOTOS.get(name)
            player = Player(
                name=name,
                nation_id=nation.id,
                position=position,
                shirt_number=number,
                club=club,
                photo_url=photo_url,
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
                    image_url=photo_url,
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
