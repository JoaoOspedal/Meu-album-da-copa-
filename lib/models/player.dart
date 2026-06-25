import 'package:flutter/foundation.dart';

import 'player_position.dart';

/// A single sticker/player belonging to a [Country]'s roster.
@immutable
class Player {
  final String id;
  final String name;
  final String countryId;
  final PlayerPosition position;
  final int stickerNumber;

  /// Optional URL for a real photo. Null falls back to an initials avatar.
  final String? photoUrl;

  const Player({
    required this.id,
    required this.name,
    required this.countryId,
    required this.position,
    required this.stickerNumber,
    this.photoUrl,
  });

  String get initials {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty) return '?';
    if (parts.length == 1) return parts.first.substring(0, 1).toUpperCase();
    return (parts.first.substring(0, 1) + parts.last.substring(0, 1))
        .toUpperCase();
  }

  @override
  bool operator ==(Object other) => other is Player && other.id == id;

  @override
  int get hashCode => id.hashCode;
}
