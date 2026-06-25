import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../l10n/app_strings.dart';
import '../providers/collection_provider.dart';

/// Opens a bottom sheet with the quantity stepper plus favorite/wishlist
/// toggles for a single sticker. Works for both player and badge stickers.
Future<void> showStickerActions(
  BuildContext context, {
  required int stickerId,
  required String title,
  String? subtitle,
  IconData icon = Icons.style_outlined,
}) {
  return showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    builder: (_) => _StickerActions(
      stickerId: stickerId,
      title: title,
      subtitle: subtitle,
      icon: icon,
    ),
  );
}

class _StickerActions extends StatelessWidget {
  const _StickerActions({
    required this.stickerId,
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  final int stickerId;
  final String title;
  final String? subtitle;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings.of(context);
    final collection = context.watch<CollectionProvider>();
    final scheme = Theme.of(context).colorScheme;

    final quantity = collection.quantity(stickerId);
    final favorite = collection.isFavorite(stickerId);
    final wanted = collection.isWanted(stickerId);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: CircleAvatar(child: Icon(icon)),
              title: Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: subtitle != null ? Text(subtitle!) : null,
            ),
            const Divider(),
            Row(
              children: [
                Expanded(child: Text(strings.labelQuantity)),
                IconButton.outlined(
                  onPressed: quantity > 0
                      ? () => collection.removeSticker(stickerId)
                      : null,
                  icon: const Icon(Icons.remove),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    '$quantity',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                IconButton.filled(
                  onPressed: () => collection.addSticker(stickerId),
                  icon: const Icon(Icons.add),
                ),
              ],
            ),
            if (quantity > 1)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  strings.copies(quantity),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: scheme.primary,
                  ),
                ),
              ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => collection.toggleFavorite(stickerId),
                    icon: Icon(
                      favorite ? Icons.favorite : Icons.favorite_border,
                      color: favorite ? Colors.red : null,
                    ),
                    label: Text(strings.favorite),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => collection.toggleWanted(stickerId),
                    icon: Icon(
                      wanted ? Icons.bookmark : Icons.bookmark_border,
                      color: wanted ? scheme.primary : null,
                    ),
                    label: Text(strings.wishlist),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
