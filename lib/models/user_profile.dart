import 'package:flutter/foundation.dart';

/// The current (mock) app user.
@immutable
class UserProfile {
  final String name;
  final String? photoUrl;

  const UserProfile({required this.name, this.photoUrl});

  String get initials {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty) return '?';
    if (parts.length == 1) return parts.first.substring(0, 1).toUpperCase();
    return (parts.first.substring(0, 1) + parts.last.substring(0, 1))
        .toUpperCase();
  }
}
