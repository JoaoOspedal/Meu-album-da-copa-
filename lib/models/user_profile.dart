import 'package:flutter/foundation.dart';

/// The current signed-in app user.
@immutable
class UserProfile {
  final int? id;
  final String name;
  final String? email;
  final String? photoUrl;

  const UserProfile({required this.name, this.id, this.email, this.photoUrl});

  /// Builds a profile from the backend `UserOut` payload.
  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'] as int?,
      name: json['username'] as String? ?? '',
      email: json['email'] as String?,
    );
  }

  String get initials {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty) return '?';
    if (parts.length == 1) return parts.first.substring(0, 1).toUpperCase();
    return (parts.first.substring(0, 1) + parts.last.substring(0, 1))
        .toUpperCase();
  }
}
