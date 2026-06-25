import 'package:flutter/foundation.dart';

/// Summary of the user's album progress (maps to `/me/collection/stats`).
@immutable
class CollectionStats {
  final int totalStickers;
  final int ownedUnique;
  final int missing;
  final int duplicates;
  final int duplicateUnits;
  final int favorites;
  final int wishlist;
  final double completionPercent;

  const CollectionStats({
    required this.totalStickers,
    required this.ownedUnique,
    required this.missing,
    required this.duplicates,
    required this.duplicateUnits,
    required this.favorites,
    required this.wishlist,
    required this.completionPercent,
  });

  factory CollectionStats.fromJson(Map<String, dynamic> json) {
    return CollectionStats(
      totalStickers: json['total_stickers'] as int? ?? 0,
      ownedUnique: json['owned_unique'] as int? ?? 0,
      missing: json['missing'] as int? ?? 0,
      duplicates: json['duplicates'] as int? ?? 0,
      duplicateUnits: json['duplicate_units'] as int? ?? 0,
      favorites: json['favorites'] as int? ?? 0,
      wishlist: json['wishlist'] as int? ?? 0,
      completionPercent: (json['completion_percent'] as num? ?? 0).toDouble(),
    );
  }

  static const empty = CollectionStats(
    totalStickers: 0,
    ownedUnique: 0,
    missing: 0,
    duplicates: 0,
    duplicateUnits: 0,
    favorites: 0,
    wishlist: 0,
    completionPercent: 0,
  );
}
