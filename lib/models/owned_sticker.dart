import 'package:flutter/foundation.dart';

/// User-specific state for a single sticker (maps to the backend
/// `user_stickers` row): how many copies, and whether it is a favorite or on
/// the wishlist.
@immutable
class OwnedSticker {
  final int stickerId;
  final int quantity;
  final bool favorite;
  final bool wanted;

  const OwnedSticker({
    required this.stickerId,
    required this.quantity,
    required this.favorite,
    required this.wanted,
  });

  bool get owned => quantity > 0;

  /// Excess copies available for trade.
  bool get isDuplicate => quantity > 1;

  /// Parses a `UserStickerOut` payload returned by the collection endpoints.
  factory OwnedSticker.fromJson(Map<String, dynamic> json) {
    final sticker = json['sticker'] as Map<String, dynamic>;
    return OwnedSticker(
      stickerId: sticker['id'] as int,
      quantity: json['quantity'] as int? ?? 0,
      favorite: json['is_favorite'] as bool? ?? false,
      wanted: json['is_wanted'] as bool? ?? false,
    );
  }

  OwnedSticker copyWith({int? quantity, bool? favorite, bool? wanted}) {
    return OwnedSticker(
      stickerId: stickerId,
      quantity: quantity ?? this.quantity,
      favorite: favorite ?? this.favorite,
      wanted: wanted ?? this.wanted,
    );
  }

  static const empty = OwnedSticker(
    stickerId: 0,
    quantity: 0,
    favorite: false,
    wanted: false,
  );
}
