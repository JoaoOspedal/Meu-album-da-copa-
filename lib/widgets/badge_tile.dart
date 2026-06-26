import 'package:flutter/material.dart';

import '../l10n/app_strings.dart';
import '../models/album_badge.dart';

/// Grid tile for a national team's badge/emblem sticker. Visually distinct from
/// player tiles (shield icon + "Badge" label) so the two sticker types are
/// easy to tell apart.
class BadgeTile extends StatelessWidget {
  final AlbumBadge badge;
  final bool owned;
  final int quantity;
  final bool favorite;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  const BadgeTile({
    super.key,
    required this.badge,
    required this.owned,
    required this.onTap,
    required this.onLongPress,
    this.quantity = 0,
    this.favorite = false,
  });

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings.of(context);
    final scheme = Theme.of(context).colorScheme;

    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: owned ? 2 : 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: owned ? scheme.tertiary : scheme.outlineVariant,
          width: owned ? 1.5 : 1,
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
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: owned
                        ? scheme.tertiaryContainer
                        : scheme.surfaceContainerHighest,
                    foregroundImage: badge.imageUrl != null
                        ? NetworkImage(badge.imageUrl!)
                        : null,
                    child: Icon(
                      Icons.shield_outlined,
                      color: owned
                          ? scheme.onTertiaryContainer
                          : scheme.onSurfaceVariant,
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
                          color: scheme.tertiary,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          'x$quantity',
                          style: TextStyle(
                            color: scheme.onTertiary,
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
                strings.badgeSticker,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: owned ? null : scheme.onSurfaceVariant,
                ),
              ),
              Text(
                '#${badge.number}',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: scheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
