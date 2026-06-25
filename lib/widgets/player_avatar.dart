import 'package:flutter/material.dart';

import '../models/player.dart';

/// Avatar for a player: shows [Player.photoUrl] when available, otherwise
/// falls back to a colored circle with the player's initials.
class PlayerAvatar extends StatelessWidget {
  final Player player;
  final double radius;
  final bool grayedOut;

  const PlayerAvatar({
    super.key,
    required this.player,
    this.radius = 28,
    this.grayedOut = false,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final avatar = CircleAvatar(
      radius: radius,
      backgroundColor: grayedOut
          ? scheme.surfaceContainerHighest
          : scheme.primary,
      foregroundImage: player.photoUrl != null
          ? NetworkImage(player.photoUrl!)
          : null,
      child: Text(
        player.initials,
        style: TextStyle(
          color: grayedOut ? scheme.onSurfaceVariant : scheme.onPrimary,
          fontWeight: FontWeight.bold,
          fontSize: radius * 0.6,
        ),
      ),
    );
    if (!grayedOut) return avatar;
    return ColorFiltered(
      colorFilter: const ColorFilter.matrix(<double>[
        0.2126, 0.7152, 0.0722, 0, 0,
        0.2126, 0.7152, 0.0722, 0, 0,
        0.2126, 0.7152, 0.0722, 0, 0,
        0, 0, 0, 1, 0,
      ]),
      child: avatar,
    );
  }
}
