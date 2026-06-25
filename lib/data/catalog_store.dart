import 'package:flutter/material.dart';

import '../core/api/api_client.dart';
import '../models/album_badge.dart';
import '../models/country.dart';
import '../models/player.dart';
import '../models/player_position.dart';

/// In-memory catalog (countries, player stickers and team badges) loaded once
/// from the backend `/stickers` endpoint.
///
/// A single network call returns every sticker with its nation and (for player
/// stickers) player embedded, which is enough to build the whole catalog.
/// Screens read from this synchronously after [load] completes.
class CatalogStore {
  CatalogStore(this._api);

  final ApiClient _api;

  final List<Country> _countries = [];
  final Map<String, Country> _countryById = {};
  final List<Player> _players = [];
  final Map<String, Player> _playerById = {};
  final Map<String, List<Player>> _playersByCountry = {};
  final Map<String, AlbumBadge> _badgeByCountry = {};
  final Map<int, AlbumBadge> _badgeByStickerId = {};

  bool _loaded = false;
  bool get isLoaded => _loaded;

  List<Country> get countries => List.unmodifiable(_countries);
  List<Player> get allPlayers => List.unmodifiable(_players);

  Country? countryById(String id) => _countryById[id];
  Player? playerById(String id) => _playerById[id];
  List<Player> playersByCountry(String id) =>
      List.unmodifiable(_playersByCountry[id] ?? const []);
  AlbumBadge? badgeForCountry(String id) => _badgeByCountry[id];
  AlbumBadge? badgeByStickerId(int stickerId) => _badgeByStickerId[stickerId];
  Player? playerByStickerId(int stickerId) => _playerById[stickerId.toString()];

  /// Distinct confederations present in the catalog, sorted alphabetically.
  List<String> get confederations {
    final set = <String>{};
    for (final c in _countries) {
      if (c.confederation != null) set.add(c.confederation!);
    }
    final list = set.toList()..sort();
    return list;
  }

  Future<void> load({bool force = false}) async {
    if (_loaded && !force) return;
    final data = await _api.get('/stickers') as List<dynamic>;

    _clear();
    final nationsTmp = <String, _NationAcc>{};

    for (final raw in data) {
      final sticker = raw as Map<String, dynamic>;
      final nation = sticker['nation'] as Map<String, dynamic>?;
      if (nation == null) continue;
      final countryId = nation['id'].toString();

      final acc = nationsTmp.putIfAbsent(
        countryId,
        () => _NationAcc(
          id: countryId,
          name: nation['name'] as String,
          code: nation['code'] as String,
          confederation: nation['confederation'] as String?,
          group: nation['group_name'] as String?,
          flagUrl: nation['flag_url'] as String?,
        ),
      );

      final type = sticker['type'] as String;
      final number = sticker['number'] as int;
      final stickerId = sticker['id'] as int;

      if (type == 'badge') {
        acc.badge = AlbumBadge(
          stickerId: stickerId,
          number: number,
          title: sticker['title'] as String,
          countryId: countryId,
          imageUrl: sticker['image_url'] as String?,
        );
      } else {
        final player = sticker['player'] as Map<String, dynamic>?;
        acc.players.add(
          Player(
            id: stickerId.toString(),
            name: (player?['name'] as String?) ?? sticker['title'] as String,
            countryId: countryId,
            position: playerPositionFromCode(player?['position'] as String?),
            stickerNumber: number,
            photoUrl:
                (sticker['image_url'] as String?) ??
                (player?['photo_url'] as String?),
            club: player?['club'] as String?,
            shirtNumber: player?['shirt_number'] as int?,
          ),
        );
      }
    }

    final sortedNations = nationsTmp.values.toList()
      ..sort((a, b) => a.name.compareTo(b.name));
    for (final acc in sortedNations) {
      final country = Country(
        id: acc.id,
        name: acc.name,
        code: acc.code,
        color: _colorForCode(acc.code),
        confederation: acc.confederation,
        group: acc.group,
        flagUrl: acc.flagUrl,
        badgeStickerId: acc.badge?.stickerId,
      );
      _countries.add(country);
      _countryById[country.id] = country;

      acc.players.sort((a, b) => a.stickerNumber.compareTo(b.stickerNumber));
      _playersByCountry[country.id] = acc.players;
      for (final p in acc.players) {
        _players.add(p);
        _playerById[p.id] = p;
      }
      if (acc.badge != null) {
        _badgeByCountry[country.id] = acc.badge!;
        _badgeByStickerId[acc.badge!.stickerId] = acc.badge!;
      }
    }

    _loaded = true;
  }

  void _clear() {
    _countries.clear();
    _countryById.clear();
    _players.clear();
    _playerById.clear();
    _playersByCountry.clear();
    _badgeByCountry.clear();
    _badgeByStickerId.clear();
  }

  // Reuses the album's blue/green-leaning palette by FIFA code, falling back to
  // a deterministic color derived from the code.
  static const Map<String, Color> _palette = {
    'BRA': Color(0xFF2E7D32),
    'ARG': Color(0xFF42A5F5),
    'FRA': Color(0xFF1565C0),
    'ENG': Color(0xFFC62828),
    'GER': Color(0xFF424242),
    'ESP': Color(0xFFD32F2F),
    'POR': Color(0xFF2E7D32),
    'ITA': Color(0xFF1976D2),
    'NED': Color(0xFFEF6C00),
    'BEL': Color(0xFFAD1457),
    'CRO': Color(0xFF6D4C41),
    'URU': Color(0xFF0288D1),
    'MEX': Color(0xFF388E3C),
    'USA': Color(0xFF283593),
    'CAN': Color(0xFFB71C1C),
    'JPN': Color(0xFF5C6BC0),
    'MAR': Color(0xFFC62828),
  };

  static Color _colorForCode(String code) {
    final fixed = _palette[code.toUpperCase()];
    if (fixed != null) return fixed;
    final hash = code.codeUnits.fold<int>(0, (acc, c) => acc * 31 + c);
    return Color((0xFF000000 | (hash & 0x00FFFFFF)));
  }
}

class _NationAcc {
  _NationAcc({
    required this.id,
    required this.name,
    required this.code,
    this.confederation,
    this.group,
    this.flagUrl,
  });

  final String id;
  final String name;
  final String code;
  final String? confederation;
  final String? group;
  final String? flagUrl;
  final List<Player> players = [];
  AlbumBadge? badge;
}
