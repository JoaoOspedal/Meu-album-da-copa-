import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../../data/catalog_store.dart';
import '../../../l10n/app_localizations.dart';
import '../../../l10n/app_strings.dart';
import '../../../models/album_badge.dart';
import '../../../models/country.dart';
import '../../../models/player.dart';
import '../../../providers/collection_provider.dart';
import '../../../widgets/badge_tile.dart';
import '../../../widgets/sticker_actions_sheet.dart';
import '../../../widgets/sticker_tile.dart';
import '../../add_sticker/add_sticker_screen.dart';
import '../../player_detail/player_detail_screen.dart';

/// Expanded panel shown under a [Country] row: the team's badge sticker plus
/// the full player album page (collected stickers highlighted, missing ones
/// grayed out) and the action to add more stickers.
class CountryStickersPanel extends StatelessWidget {
  final Country country;
  final List<Player> roster;

  const CountryStickersPanel({
    super.key,
    required this.country,
    required this.roster,
  });

  void _openPlayer(BuildContext context, Player player) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => PlayerDetailScreen(player: player)),
    );
  }

  void _toggleOwned(BuildContext context, int stickerId) {
    final l10n = AppLocalizations.of(context)!;
    final collection = context.read<CollectionProvider>();
    final willOwn = !collection.isOwned(stickerId);
    collection.toggleOwned(stickerId);
    HapticFeedback.lightImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          willOwn ? l10n.stickerMarkedOwned : l10n.stickerMarkedMissing,
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final collection = context.watch<CollectionProvider>();
    final badge = context.read<CatalogStore>().badgeForCountry(country.id);

    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 4, 12, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  l10n.myStickers,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) =>
                          AddStickerScreen(country: country, roster: roster),
                    ),
                  );
                },
                icon: const Icon(Icons.add_photo_alternate_outlined),
                label: Text(l10n.addSticker),
              ),
            ],
          ),
          const SizedBox(height: 12),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: roster.length + (badge != null ? 1 : 0),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio: 0.78,
            ),
            itemBuilder: (context, index) {
              if (badge != null && index == 0) {
                return _buildBadge(context, badge, collection);
              }
              final player = roster[index - (badge != null ? 1 : 0)];
              return StickerTile(
                player: player,
                owned: collection.isOwned(player.stickerId),
                quantity: collection.quantity(player.stickerId),
                favorite: collection.isFavorite(player.stickerId),
                wanted: collection.isWanted(player.stickerId),
                onTap: () => _openPlayer(context, player),
                onLongPress: () => _toggleOwned(context, player.stickerId),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildBadge(
    BuildContext context,
    AlbumBadge badge,
    CollectionProvider collection,
  ) {
    final strings = AppStrings.of(context);
    return BadgeTile(
      badge: badge,
      owned: collection.isOwned(badge.stickerId),
      quantity: collection.quantity(badge.stickerId),
      favorite: collection.isFavorite(badge.stickerId),
      onTap: () => showStickerActions(
        context,
        stickerId: badge.stickerId,
        title: badge.title,
        subtitle: '${strings.typeBadge} · ${country.name}',
        icon: Icons.shield_outlined,
      ),
      onLongPress: () => _toggleOwned(context, badge.stickerId),
    );
  }
}
