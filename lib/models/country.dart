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

  const Country({
    required this.id,
    required this.name,
    required this.code,
    required this.color,
  });

  @override
  bool operator ==(Object other) => other is Country && other.id == id;

  @override
  int get hashCode => id.hashCode;
}
