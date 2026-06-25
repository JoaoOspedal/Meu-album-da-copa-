import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../models/player.dart';
import 'player_avatar.dart';

/// Grid tile for a single sticker, reused by the album panel, the
/// add-sticker screen and anywhere else a player needs to be shown as a
/// sticker. Tap opens details; long-press toggles collected/missing.
class StickerTile extends StatelessWidget {
  final Player player;
  final bool owned;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  const StickerTile({
    super.key,
    required this.player,
    required this.owned,
    required this.onTap,
    required this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final scheme = Theme.of(context).colorScheme;
    final statusLabel = owned
        ? l10n.stickerStatusOwned
        : l10n.stickerStatusMissing;

    return Semantics(
      button: true,
      label: '${player.name}, $statusLabel',
      child: Card(
        clipBehavior: Clip.antiAlias,
        elevation: owned ? 2 : 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: owned ? scheme.primary : scheme.outlineVariant,
          ),
        ),
        child: InkWell(
          onTap: onTap,
          onLongPress: onLongPress,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    PlayerAvatar(player: player, grayedOut: !owned),
                    if (owned)
                      Positioned(
                        right: -2,
                        bottom: -2,
                        child: CircleAvatar(
                          radius: 9,
                          backgroundColor: scheme.secondary,
                          child: Icon(
                            Icons.check,
                            size: 12,
                            color: scheme.onSecondary,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  player.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: owned ? null : scheme.onSurfaceVariant,
                  ),
                ),
                Text(
                  '#${player.stickerNumber}',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: scheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
