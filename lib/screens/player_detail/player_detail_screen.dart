import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/repositories/country_repository.dart';
import '../../l10n/app_localizations.dart';
import '../../models/player.dart';
import '../../models/player_position.dart';
import '../../providers/album_provider.dart';
import '../../widgets/player_avatar.dart';

/// Shows the full info for a single player/sticker, with the action to
/// mark it as collected or remove it from the collection.
class PlayerDetailScreen extends StatelessWidget {
  final Player player;

  const PlayerDetailScreen({super.key, required this.player});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final country = context.read<CountryRepository>().getById(
      player.countryId,
    );
    final album = context.watch<AlbumProvider>();
    final owned = album.isOwned(player.id);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.playerDetailTitle)),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Hero(
                tag: 'sticker_${player.id}',
                child: PlayerAvatar(player: player, radius: 64, grayedOut: !owned),
              ),
              const SizedBox(height: 16),
              Text(
                player.name,
                style: Theme.of(
                  context,
                ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                '#${player.stickerNumber}',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 24),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      _InfoRow(
                        icon: Icons.flag_outlined,
                        label: l10n.labelCountry,
                        value: country?.name ?? player.countryId,
                      ),
                      const Divider(),
                      _InfoRow(
                        icon: Icons.sports_soccer_outlined,
                        label: l10n.labelPosition,
                        value: player.position.label(context),
                      ),
                      const Divider(),
                      _InfoRow(
                        icon: Icons.tag,
                        label: l10n.labelStickerNumber,
                        value: '${player.stickerNumber}',
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => album.toggleOwned(player.id),
                  icon: Icon(owned ? Icons.remove_circle_outline : Icons.add_circle_outline),
                  label: Text(owned ? l10n.removeFromAlbum : l10n.markAsOwned),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, color: scheme.primary),
          const SizedBox(width: 12),
          Text(label, style: Theme.of(context).textTheme.bodyMedium),
          const Spacer(),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
