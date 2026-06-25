import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../models/player.dart';
import 'player_avatar.dart';

/// Grid tile for a single sticker, reused by the album panel, the
/// add-sticker screen and anywhere else a player needs to be shown as a
/// sticker. Tap opens details; long-press toggles collected/missing.
///
/// Surfaces collection state coming from the backend: a copies badge when
/// [quantity] > 1, plus favorite/wishlist indicators.
class StickerTile extends StatelessWidget {
  final Player player;
  final bool owned;

  /// Number of copies owned; values > 1 surface a "repeated" badge.
  final int quantity;
  final bool favorite;
  final bool wanted;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  const StickerTile({
    super.key,
    required this.player,
    required this.owned,
    required this.onTap,
    required this.onLongPress,
    this.quantity = 0,
    this.favorite = false,
    this.wanted = false,
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
                    if (quantity > 1)
                      Positioned(
                        left: -6,
                        top: -6,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: scheme.primary,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            'x$quantity',
                            style: TextStyle(
                              color: scheme.onPrimary,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    if (favorite)
                      const Positioned(
                        right: -4,
                        top: -4,
                        child: Icon(Icons.favorite, size: 14, color: Colors.red),
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '#${player.stickerNumber}',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: scheme.onSurfaceVariant,
                      ),
                    ),
                    if (wanted)
                      Padding(
                        padding: const EdgeInsets.only(left: 4),
                        child: Icon(
                          Icons.bookmark,
                          size: 12,
                          color: scheme.primary,
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
