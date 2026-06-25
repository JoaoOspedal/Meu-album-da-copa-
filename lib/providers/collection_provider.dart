import 'package:flutter/foundation.dart';

import '../core/api/api_client.dart';
import '../models/collection_stats.dart';
import '../models/owned_sticker.dart';

/// Source of truth for the user's collection (owned quantity, favorites and
/// wishlist), synchronized with the backend `/me/collection` endpoints.
///
/// Local state is updated optimistically from each endpoint's response so the
/// UI reacts immediately after every action.
class CollectionProvider extends ChangeNotifier {
  CollectionProvider(this._api);

  final ApiClient _api;

  final Map<int, OwnedSticker> _byId = {};
  CollectionStats _stats = CollectionStats.empty;
  bool _loaded = false;

  CollectionStats get stats => _stats;
  bool get isLoaded => _loaded;

  OwnedSticker _entry(int stickerId) =>
      _byId[stickerId] ??
      OwnedSticker(
        stickerId: stickerId,
        quantity: 0,
        favorite: false,
        wanted: false,
      );

  bool isOwned(int stickerId) => _entry(stickerId).owned;
  int quantity(int stickerId) => _entry(stickerId).quantity;
  bool isFavorite(int stickerId) => _entry(stickerId).favorite;
  bool isWanted(int stickerId) => _entry(stickerId).wanted;

  int ownedCountAmong(Iterable<int> stickerIds) =>
      stickerIds.where(isOwned).length;

  int get ownedCount => _byId.values.where((e) => e.owned).length;

  List<OwnedSticker> get duplicates =>
      _byId.values.where((e) => e.isDuplicate).toList();
  List<OwnedSticker> get favorites =>
      _byId.values.where((e) => e.favorite).toList();
  List<OwnedSticker> get wishlist =>
      _byId.values.where((e) => e.wanted).toList();

  /// Loads the full collection (every interacted sticker) plus the stats.
  Future<void> load({bool force = false}) async {
    if (_loaded && !force) return;
    final list =
        await _api.get('/me/collection', query: {'owned_only': false})
            as List<dynamic>;
    _byId
      ..clear()
      ..addEntries(
        list.map((raw) {
          final entry = OwnedSticker.fromJson(raw as Map<String, dynamic>);
          return MapEntry(entry.stickerId, entry);
        }),
      );
    await _refreshStats();
    _loaded = true;
    notifyListeners();
  }

  /// Clears local state (used on logout).
  void reset() {
    _byId.clear();
    _stats = CollectionStats.empty;
    _loaded = false;
    notifyListeners();
  }

  Future<void> addSticker(int stickerId, {int amount = 1}) =>
      _mutate(() => _api.post(
            '/me/collection/stickers/$stickerId/add',
            body: {'amount': amount},
          ));

  Future<void> removeSticker(int stickerId, {int amount = 1}) =>
      _mutate(() => _api.post(
            '/me/collection/stickers/$stickerId/remove',
            body: {'amount': amount},
          ));

  Future<void> setQuantity(int stickerId, int quantity) =>
      _mutate(() => _api.put(
            '/me/collection/stickers/$stickerId/quantity',
            body: {'quantity': quantity},
          ));

  /// Convenience toggle for the "I have this sticker" UX (0 <-> 1+).
  Future<void> toggleOwned(int stickerId) {
    return isOwned(stickerId)
        ? setQuantity(stickerId, 0)
        : addSticker(stickerId);
  }

  Future<void> setFavorite(int stickerId, bool value) =>
      _mutate(() => _api.patch(
            '/me/collection/stickers/$stickerId/flags',
            body: {'is_favorite': value},
          ));

  Future<void> setWanted(int stickerId, bool value) =>
      _mutate(() => _api.patch(
            '/me/collection/stickers/$stickerId/flags',
            body: {'is_wanted': value},
          ));

  Future<void> toggleFavorite(int stickerId) =>
      setFavorite(stickerId, !isFavorite(stickerId));
  Future<void> toggleWanted(int stickerId) =>
      setWanted(stickerId, !isWanted(stickerId));

  /// Runs an endpoint that returns a single `UserStickerOut`, updates the local
  /// entry from the response and refreshes the stats.
  Future<void> _mutate(Future<dynamic> Function() request) async {
    final data = await request() as Map<String, dynamic>;
    final entry = OwnedSticker.fromJson(data);
    _byId[entry.stickerId] = entry;
    notifyListeners();
    await _refreshStats();
    notifyListeners();
  }

  Future<void> _refreshStats() async {
    final data =
        await _api.get('/me/collection/stats') as Map<String, dynamic>;
    _stats = CollectionStats.fromJson(data);
  }
}
