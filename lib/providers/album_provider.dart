import 'package:flutter/foundation.dart';

import '../data/repositories/player_repository.dart';

/// Tracks which stickers the user has already collected.
///
/// This is the single source of truth for "colada"/"faltando" status across
/// the whole app (home grid, add-sticker screen, player detail screen).
class AlbumProvider extends ChangeNotifier {
  AlbumProvider({required Set<String> initiallyOwned})
    : _ownedStickerIds = {...initiallyOwned};

  final Set<String> _ownedStickerIds;

  bool isOwned(String playerId) => _ownedStickerIds.contains(playerId);

  void toggleOwned(String playerId) {
    if (!_ownedStickerIds.remove(playerId)) {
      _ownedStickerIds.add(playerId);
    }
    notifyListeners();
  }

  int ownedCount() => _ownedStickerIds.length;

  int ownedCountAmong(Iterable<String> playerIds) {
    return playerIds.where(_ownedStickerIds.contains).length;
  }

  int totalOwnedAcross(PlayerRepository playerRepository) {
    return ownedCountAmong(playerRepository.getAll().map((p) => p.id));
  }
}
