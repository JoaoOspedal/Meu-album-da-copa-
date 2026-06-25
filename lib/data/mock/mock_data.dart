import 'package:flutter/material.dart';

import '../../models/country.dart';
import '../../models/player.dart';
import '../../models/player_position.dart';

/// Single source of truth for the mock catalog used by the frontend
/// prototype. A real implementation would replace this with calls to an
/// actual API, without changing anything in [CountryRepository] or
/// [PlayerRepository] consumers.
class MockData {
  MockData._();

  static const List<Country> countries = [
    Country(id: 'bra', name: 'Brasil', code: 'BRA', color: Color(0xFF2E7D32)),
    Country(
      id: 'arg',
      name: 'Argentina',
      code: 'ARG',
      color: Color(0xFF42A5F5),
    ),
    Country(id: 'fra', name: 'França', code: 'FRA', color: Color(0xFF1565C0)),
    Country(
      id: 'eng',
      name: 'Inglaterra',
      code: 'ENG',
      color: Color(0xFFC62828),
    ),
    Country(
      id: 'ger',
      name: 'Alemanha',
      code: 'GER',
      color: Color(0xFF424242),
    ),
    Country(id: 'esp', name: 'Espanha', code: 'ESP', color: Color(0xFFD32F2F)),
    Country(
      id: 'por',
      name: 'Portugal',
      code: 'POR',
      color: Color(0xFF2E7D32),
    ),
    Country(id: 'ita', name: 'Itália', code: 'ITA', color: Color(0xFF1976D2)),
    Country(
      id: 'ned',
      name: 'Holanda',
      code: 'NED',
      color: Color(0xFFEF6C00),
    ),
    Country(id: 'bel', name: 'Bélgica', code: 'BEL', color: Color(0xFFAD1457)),
    Country(
      id: 'cro',
      name: 'Croácia',
      code: 'CRO',
      color: Color(0xFF6D4C41),
    ),
    Country(id: 'uru', name: 'Uruguai', code: 'URU', color: Color(0xFF0288D1)),
    Country(id: 'mex', name: 'México', code: 'MEX', color: Color(0xFF388E3C)),
    Country(
      id: 'usa',
      name: 'Estados Unidos',
      code: 'USA',
      color: Color(0xFF283593),
    ),
    Country(id: 'can', name: 'Canadá', code: 'CAN', color: Color(0xFFB71C1C)),
    Country(id: 'jpn', name: 'Japão', code: 'JPN', color: Color(0xFF5C6BC0)),
  ];

  static final List<Player> players = [
    ..._team('bra', [
      ('Alisson', PlayerPosition.goalkeeper, 1),
      ('Marquinhos', PlayerPosition.defender, 4),
      ('Casemiro', PlayerPosition.midfielder, 5),
      ('Bruno Guimarães', PlayerPosition.midfielder, 8),
      ('Vinícius Júnior', PlayerPosition.forward, 7),
      ('Rodrygo', PlayerPosition.forward, 11),
    ]),
    ..._team('arg', [
      ('Emiliano Martínez', PlayerPosition.goalkeeper, 1),
      ('Cristian Romero', PlayerPosition.defender, 13),
      ('Rodrigo De Paul', PlayerPosition.midfielder, 7),
      ('Enzo Fernández', PlayerPosition.midfielder, 24),
      ('Lionel Messi', PlayerPosition.forward, 10),
      ('Julián Álvarez', PlayerPosition.forward, 9),
    ]),
    ..._team('fra', [
      ('Mike Maignan', PlayerPosition.goalkeeper, 1),
      ('William Saliba', PlayerPosition.defender, 17),
      ('Aurélien Tchouaméni', PlayerPosition.midfielder, 8),
      ('Antoine Griezmann', PlayerPosition.midfielder, 7),
      ('Kylian Mbappé', PlayerPosition.forward, 10),
      ('Ousmane Dembélé', PlayerPosition.forward, 11),
    ]),
    ..._team('eng', [
      ('Jordan Pickford', PlayerPosition.goalkeeper, 1),
      ('John Stones', PlayerPosition.defender, 5),
      ('Declan Rice', PlayerPosition.midfielder, 4),
      ('Jude Bellingham', PlayerPosition.midfielder, 10),
      ('Harry Kane', PlayerPosition.forward, 9),
      ('Bukayo Saka', PlayerPosition.forward, 17),
    ]),
    ..._team('ger', [
      ('Manuel Neuer', PlayerPosition.goalkeeper, 1),
      ('Antonio Rüdiger', PlayerPosition.defender, 2),
      ('Joshua Kimmich', PlayerPosition.midfielder, 6),
      ('Jamal Musiala', PlayerPosition.midfielder, 14),
      ('Kai Havertz', PlayerPosition.forward, 7),
      ('Florian Wirtz', PlayerPosition.forward, 17),
    ]),
    ..._team('esp', [
      ('Unai Simón', PlayerPosition.goalkeeper, 1),
      ('Aymeric Laporte', PlayerPosition.defender, 24),
      ('Rodri', PlayerPosition.midfielder, 16),
      ('Pedri', PlayerPosition.midfielder, 26),
      ('Álvaro Morata', PlayerPosition.forward, 7),
      ('Lamine Yamal', PlayerPosition.forward, 19),
    ]),
    ..._team('por', [
      ('Diogo Costa', PlayerPosition.goalkeeper, 1),
      ('Rúben Dias', PlayerPosition.defender, 3),
      ('Bruno Fernandes', PlayerPosition.midfielder, 8),
      ('Vitinha', PlayerPosition.midfielder, 17),
      ('Cristiano Ronaldo', PlayerPosition.forward, 7),
      ('Rafael Leão', PlayerPosition.forward, 11),
    ]),
    ..._team('ita', [
      ('Gianluigi Donnarumma', PlayerPosition.goalkeeper, 1),
      ('Alessandro Bastoni', PlayerPosition.defender, 23),
      ('Nicolò Barella', PlayerPosition.midfielder, 18),
      ('Federico Chiesa', PlayerPosition.midfielder, 14),
      ('Mateo Retegui', PlayerPosition.forward, 9),
      ('Moise Kean', PlayerPosition.forward, 20),
    ]),
    ..._team('ned', [
      ('Bart Verbruggen', PlayerPosition.goalkeeper, 1),
      ('Virgil van Dijk', PlayerPosition.defender, 4),
      ('Frenkie de Jong', PlayerPosition.midfielder, 21),
      ('Tijjani Reijnders', PlayerPosition.midfielder, 14),
      ('Memphis Depay', PlayerPosition.forward, 9),
      ('Cody Gakpo', PlayerPosition.forward, 11),
    ]),
    ..._team('bel', [
      ('Koen Casteels', PlayerPosition.goalkeeper, 1),
      ('Jan Vertonghen', PlayerPosition.defender, 5),
      ('Amadou Onana', PlayerPosition.midfielder, 6),
      ('Kevin De Bruyne', PlayerPosition.midfielder, 7),
      ('Romelu Lukaku', PlayerPosition.forward, 9),
      ('Jeremy Doku', PlayerPosition.forward, 11),
    ]),
    ..._team('cro', [
      ('Dominik Livaković', PlayerPosition.goalkeeper, 1),
      ('Joško Gvardiol', PlayerPosition.defender, 20),
      ('Marcelo Brozović', PlayerPosition.midfielder, 11),
      ('Luka Modrić', PlayerPosition.midfielder, 10),
      ('Andrej Kramarić', PlayerPosition.forward, 9),
      ('Ante Budimir', PlayerPosition.forward, 16),
    ]),
    ..._team('uru', [
      ('Sergio Rochet', PlayerPosition.goalkeeper, 1),
      ('Ronald Araújo', PlayerPosition.defender, 4),
      ('Federico Valverde', PlayerPosition.midfielder, 15),
      ('Manuel Ugarte', PlayerPosition.midfielder, 5),
      ('Darwin Núñez', PlayerPosition.forward, 19),
      ('Luis Suárez', PlayerPosition.forward, 9),
    ]),
    ..._team('mex', [
      ('Guillermo Ochoa', PlayerPosition.goalkeeper, 1),
      ('César Montes', PlayerPosition.defender, 3),
      ('Edson Álvarez', PlayerPosition.midfielder, 4),
      ('Luis Chávez', PlayerPosition.midfielder, 16),
      ('Hirving Lozano', PlayerPosition.forward, 22),
      ('Santiago Giménez', PlayerPosition.forward, 9),
    ]),
    ..._team('usa', [
      ('Matt Turner', PlayerPosition.goalkeeper, 1),
      ('Chris Richards', PlayerPosition.defender, 3),
      ('Tyler Adams', PlayerPosition.midfielder, 4),
      ('Weston McKennie', PlayerPosition.midfielder, 8),
      ('Christian Pulisic', PlayerPosition.forward, 10),
      ('Folarin Balogun', PlayerPosition.forward, 9),
    ]),
    ..._team('can', [
      ('Maxime Crépeau', PlayerPosition.goalkeeper, 1),
      ('Alistair Johnston', PlayerPosition.defender, 2),
      ('Stephen Eustáquio', PlayerPosition.midfielder, 19),
      ('Jonathan Osorio', PlayerPosition.midfielder, 21),
      ('Alphonso Davies', PlayerPosition.forward, 19),
      ('Jonathan David', PlayerPosition.forward, 11),
    ]),
    ..._team('jpn', [
      ('Zion Suzuki', PlayerPosition.goalkeeper, 12),
      ('Takehiro Tomiyasu', PlayerPosition.defender, 2),
      ('Wataru Endo', PlayerPosition.midfielder, 6),
      ('Hidemasa Morita', PlayerPosition.midfielder, 8),
      ('Takefusa Kubo', PlayerPosition.forward, 7),
      ('Kaoru Mitoma', PlayerPosition.forward, 11),
    ]),
  ];

  static List<Player> _team(
    String countryId,
    List<(String, PlayerPosition, int)> roster,
  ) {
    return [
      for (final entry in roster)
        Player(
          id: '${countryId}_${entry.$3}',
          name: entry.$1,
          countryId: countryId,
          position: entry.$2,
          stickerNumber: entry.$3,
        ),
    ];
  }

  /// A handful of stickers pre-marked as collected so the demo album
  /// doesn't start out completely empty.
  static Set<String> get initiallyOwnedStickerIds => {
    'bra_1',
    'bra_5',
    'bra_7',
    'arg_10',
    'arg_9',
    'fra_10',
    'esp_19',
    'por_7',
  };
}
