import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/repositories/country_repository.dart';
import '../../l10n/app_localizations.dart';
import '../../l10n/app_strings.dart';
import '../../models/player.dart';
import '../../models/player_position.dart';
import '../../providers/collection_provider.dart';
import '../../widgets/player_avatar.dart';

/// Shows the full info for a single player sticker, with actions to manage how
/// many copies the user owns and to favorite / wishlist it.
class PlayerDetailScreen extends StatelessWidget {
  final Player player;

  const PlayerDetailScreen({super.key, required this.player});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final strings = AppStrings.of(context);
    final country = context.read<CountryRepository>().getById(
      player.countryId,
    );
    final collection = context.watch<CollectionProvider>();
    final stickerId = player.stickerId;
    final owned = collection.isOwned(stickerId);
    final quantity = collection.quantity(stickerId);
    final favorite = collection.isFavorite(stickerId);
    final wanted = collection.isWanted(stickerId);
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.playerDetailTitle),
        actions: [
          IconButton(
            tooltip: strings.favorite,
            icon: Icon(
              favorite ? Icons.favorite : Icons.favorite_border,
              color: favorite ? Colors.red : null,
            ),
            onPressed: () => collection.toggleFavorite(stickerId),
          ),
          IconButton(
            tooltip: strings.wishlist,
            icon: Icon(wanted ? Icons.bookmark : Icons.bookmark_border),
            onPressed: () => collection.toggleWanted(stickerId),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Hero(
                tag: 'sticker_${player.id}',
                child: PlayerAvatar(
                  player: player,
                  radius: 64,
                  grayedOut: !owned,
                ),
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
                  color: scheme.onSurfaceVariant,
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
                        icon: Icons.style_outlined,
                        label: strings.labelType,
                        value: strings.typePlayer,
                      ),
                      const Divider(),
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
                      if (player.club != null) ...[
                        const Divider(),
                        _InfoRow(
                          icon: Icons.shield_moon_outlined,
                          label: strings.labelClub,
                          value: player.club!,
                        ),
                      ],
                      if (player.shirtNumber != null) ...[
                        const Divider(),
                        _InfoRow(
                          icon: Icons.checkroom_outlined,
                          label: strings.labelShirtNumber,
                          value: '${player.shirtNumber}',
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              _QuantityCard(
                quantity: quantity,
                onAdd: () => collection.addSticker(stickerId),
                onRemove: quantity > 0
                    ? () => collection.removeSticker(stickerId)
                    : null,
                strings: strings,
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: owned
                    ? OutlinedButton.icon(
                        onPressed: () => collection.setQuantity(stickerId, 0),
                        icon: const Icon(Icons.remove_circle_outline),
                        label: Text(l10n.removeFromAlbum),
                      )
                    : FilledButton.icon(
                        onPressed: () => collection.addSticker(stickerId),
                        icon: const Icon(Icons.add_circle_outline),
                        label: Text(l10n.markAsOwned),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _QuantityCard extends StatelessWidget {
  final int quantity;
  final VoidCallback onAdd;
  final VoidCallback? onRemove;
  final AppStrings strings;

  const _QuantityCard({
    required this.quantity,
    required this.onAdd,
    required this.onRemove,
    required this.strings,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    strings.labelQuantity,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  if (quantity > 1)
                    Text(
                      strings.copies(quantity),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: scheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                ],
              ),
            ),
            IconButton.outlined(
              onPressed: onRemove,
              icon: const Icon(Icons.remove),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                '$quantity',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            IconButton.filled(onPressed: onAdd, icon: const Icon(Icons.add)),
          ],
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
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}
