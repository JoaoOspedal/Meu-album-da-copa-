import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/catalog_store.dart';
import '../../l10n/app_strings.dart';
import '../../models/owned_sticker.dart';
import '../../providers/collection_provider.dart';
import '../../widgets/sticker_actions_sheet.dart';

/// Generic list of stickers from the user's collection, shared by the
/// duplicates, favorites and wishlist screens. [selector] picks which entries
/// to show from the [CollectionProvider].
class CollectionListScreen extends StatelessWidget {
  final String title;
  final String emptyMessage;
  final List<OwnedSticker> Function(CollectionProvider) selector;
  final IconData emptyIcon;

  const CollectionListScreen({
    super.key,
    required this.title,
    required this.emptyMessage,
    required this.selector,
    this.emptyIcon = Icons.inbox_outlined,
  });

  @override
  Widget build(BuildContext context) {
    final collection = context.watch<CollectionProvider>();
    final catalog = context.read<CatalogStore>();
    final entries = selector(collection)
      ..sort((a, b) => a.stickerId.compareTo(b.stickerId));

    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: SafeArea(
        child: entries.isEmpty
            ? _Empty(message: emptyMessage, icon: emptyIcon)
            : ListView.separated(
                padding: const EdgeInsets.all(12),
                itemCount: entries.length,
                separatorBuilder: (_, _) => const SizedBox(height: 8),
                itemBuilder: (context, index) =>
                    _StickerRow(entry: entries[index], catalog: catalog),
              ),
      ),
    );
  }
}

class _StickerRow extends StatelessWidget {
  final OwnedSticker entry;
  final CatalogStore catalog;

  const _StickerRow({required this.entry, required this.catalog});

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings.of(context);
    final scheme = Theme.of(context).colorScheme;

    final player = catalog.playerByStickerId(entry.stickerId);
    final badge = player == null
        ? catalog.badgeByStickerId(entry.stickerId)
        : null;

    final isBadge = badge != null;
    final countryId = player?.countryId ?? badge?.countryId;
    final country = countryId != null ? catalog.countryById(countryId) : null;

    final title = player?.name ?? badge?.title ?? '#${entry.stickerId}';
    final number = player?.stickerNumber ?? badge?.number;
    final typeLabel = isBadge ? strings.typeBadge : strings.typePlayer;
    final subtitle = [
      if (country != null) country.name,
      typeLabel,
      if (number != null) '#$number',
    ].join(' · ');

    return Card(
      clipBehavior: Clip.antiAlias,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: isBadge
              ? scheme.tertiaryContainer
              : scheme.primaryContainer,
          foregroundImage: (player?.photoUrl != null)
              ? NetworkImage(player!.photoUrl!)
              : null,
          child: Icon(
            isBadge ? Icons.shield_outlined : Icons.person,
            color: isBadge
                ? scheme.onTertiaryContainer
                : scheme.onPrimaryContainer,
          ),
        ),
        title: Text(
          title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(subtitle),
        trailing: Wrap(
          spacing: 4,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            if (entry.quantity > 1)
              Chip(
                label: Text('x${entry.quantity}'),
                visualDensity: VisualDensity.compact,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            if (entry.favorite)
              const Icon(Icons.favorite, size: 18, color: Colors.red),
            if (entry.wanted)
              Icon(Icons.bookmark, size: 18, color: scheme.primary),
          ],
        ),
        onTap: () => showStickerActions(
          context,
          stickerId: entry.stickerId,
          title: title,
          subtitle: subtitle,
          icon: isBadge ? Icons.shield_outlined : Icons.person,
        ),
      ),
    );
  }
}

class _Empty extends StatelessWidget {
  final String message;
  final IconData icon;

  const _Empty({required this.message, required this.icon});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 56, color: scheme.onSurfaceVariant),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: scheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
