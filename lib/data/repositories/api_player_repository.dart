import '../../models/player.dart';
import '../catalog_store.dart';
import 'player_repository.dart';

/// [PlayerRepository] backed by the catalog loaded from the backend.
class ApiPlayerRepository implements PlayerRepository {
  ApiPlayerRepository(this._store);

  final CatalogStore _store;

  @override
  List<Player> getAll() => _store.allPlayers;

  @override
  List<Player> getByCountry(String countryId) =>
      _store.playersByCountry(countryId);

  @override
  List<Player> search(String countryId, String query) {
    final normalized = query.trim().toLowerCase();
    final roster = getByCountry(countryId);
    if (normalized.isEmpty) return roster;
    return roster
        .where((player) => player.name.toLowerCase().contains(normalized))
        .toList(growable: false);
  }

  @override
  Player? getById(String id) => _store.playerById(id);
}
