import '../../models/player.dart';

/// Source of players/stickers for each national team.
abstract class PlayerRepository {
  List<Player> getByCountry(String countryId);

  List<Player> search(String countryId, String query);

  Player? getById(String id);

  /// All players across every country, used for profile-level statistics.
  List<Player> getAll();
}
