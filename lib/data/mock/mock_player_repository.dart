import '../../models/player.dart';
import '../repositories/player_repository.dart';
import 'mock_data.dart';

class MockPlayerRepository implements PlayerRepository {
  @override
  List<Player> getAll() => MockData.players;

  @override
  List<Player> getByCountry(String countryId) {
    return MockData.players
        .where((player) => player.countryId == countryId)
        .toList(growable: false);
  }

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
  Player? getById(String id) {
    for (final player in MockData.players) {
      if (player.id == id) return player;
    }
    return null;
  }
}
