import 'package:flutter/material.dart';

/// Represents a national team taking part in the album.
@immutable
class Country {
  final String id;
  final String name;

  /// Short code shown on the flag avatar (e.g. "BRA").
  final String code;

  /// Accent color used to render the flag avatar for this team.
  final Color color;

  /// Confederation (CONMEBOL, UEFA, ...) — used by the home filter. May be null.
  final String? confederation;

  /// Tournament group (A, B, ...). May be null.
  final String? group;

  /// Optional flag image URL coming from the backend.
  final String? flagUrl;

  /// Backend sticker id of this team's badge/emblem sticker, when it exists.
  final int? badgeStickerId;

  const Country({
    required this.id,
    required this.name,
    required this.code,
    required this.color,
    this.confederation,
    this.group,
    this.flagUrl,
    this.badgeStickerId,
  });

  @override
  bool operator ==(Object other) => other is Country && other.id == id;

  @override
  int get hashCode => id.hashCode;
}
