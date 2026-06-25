import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../../l10n/app_localizations.dart';
import '../../../models/country.dart';
import '../../../models/player.dart';
import '../../../providers/album_provider.dart';
import '../../../widgets/sticker_tile.dart';
import '../../add_sticker/add_sticker_screen.dart';
import '../../player_detail/player_detail_screen.dart';

/// Expanded panel shown under a [Country] row: the team's full sticker
/// album page (collected stickers highlighted, missing ones grayed out)
/// plus the action to add more stickers.
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

  void _toggleOwned(BuildContext context, Player player) {
    final l10n = AppLocalizations.of(context)!;
    final album = context.read<AlbumProvider>();
    album.toggleOwned(player.id);
    HapticFeedback.lightImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          album.isOwned(player.id)
              ? l10n.stickerMarkedOwned
              : l10n.stickerMarkedMissing,
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final album = context.watch<AlbumProvider>();

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
            itemCount: roster.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio: 0.78,
            ),
            itemBuilder: (context, index) {
              final player = roster[index];
              return StickerTile(
                player: player,
                owned: album.isOwned(player.id),
                onTap: () => _openPlayer(context, player),
                onLongPress: () => _toggleOwned(context, player),
              );
            },
          ),
        ],
      ),
    );
  }
}
