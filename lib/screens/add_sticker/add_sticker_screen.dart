import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../data/catalog_store.dart';
import '../../l10n/app_localizations.dart';
import '../../l10n/app_strings.dart';
import '../../models/album_badge.dart';
import '../../models/country.dart';
import '../../models/player.dart';
import '../../providers/collection_provider.dart';
import '../../widgets/badge_tile.dart';
import '../../widgets/search_field.dart';
import '../../widgets/sticker_actions_sheet.dart';
import '../../widgets/sticker_tile.dart';
import '../player_detail/player_detail_screen.dart';

enum _TypeFilter { all, players, badges }

enum _StatusFilter { all, owned, missing }

/// Lists every sticker for a team — players and the team badge — with search
/// and filters by type (player/badge) and status (collected/missing).
/// Tapping a player sticker opens its details; long-pressing toggles collected
/// status right from the grid.
class AddStickerScreen extends StatefulWidget {
  final Country country;
  final List<Player> roster;

  const AddStickerScreen({
    super.key,
    required this.country,
    required this.roster,
  });

  @override
  State<AddStickerScreen> createState() => _AddStickerScreenState();
}

class _AddStickerScreenState extends State<AddStickerScreen> {
  String _query = '';
  _TypeFilter _type = _TypeFilter.all;
  _StatusFilter _status = _StatusFilter.all;

  bool _matchesStatus(CollectionProvider collection, int stickerId) {
    switch (_status) {
      case _StatusFilter.all:
        return true;
      case _StatusFilter.owned:
        return collection.isOwned(stickerId);
      case _StatusFilter.missing:
        return !collection.isOwned(stickerId);
    }
  }

  List<Player> _filteredPlayers(CollectionProvider collection) {
    final normalized = _query.trim().toLowerCase();
    return widget.roster.where((p) {
      if (normalized.isNotEmpty && !p.name.toLowerCase().contains(normalized)) {
        return false;
      }
      return _matchesStatus(collection, p.stickerId);
    }).toList(growable: false);
  }

  bool _showBadge(CollectionProvider collection, AlbumBadge? badge) {
    if (badge == null || _type == _TypeFilter.players) return false;
    final normalized = _query.trim().toLowerCase();
    if (normalized.isNotEmpty &&
        !'brasão badge ${widget.country.name}'.toLowerCase().contains(
          normalized,
        )) {
      return false;
    }
    return _matchesStatus(collection, badge.stickerId);
  }

  void _openPlayer(Player player) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => PlayerDetailScreen(player: player)),
    );
  }

  void _toggleOwned(int stickerId) {
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
    final strings = AppStrings.of(context);
    final collection = context.watch<CollectionProvider>();
    final badge = context.read<CatalogStore>().badgeForCountry(
      widget.country.id,
    );

    final players = _type == _TypeFilter.badges
        ? const <Player>[]
        : _filteredPlayers(collection);
    final showBadge = _showBadge(collection, badge);
    final itemCount = players.length + (showBadge ? 1 : 0);

    return Scaffold(
      appBar: AppBar(title: Text(widget.country.name)),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SearchField(
                hintText: l10n.searchPlayerHint,
                onChanged: (value) => setState(() => _query = value),
              ),
              const SizedBox(height: 12),
              _FilterChips(
                type: _type,
                status: _status,
                strings: strings,
                onType: (t) => setState(() => _type = t),
                onStatus: (s) => setState(() => _status = s),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: itemCount == 0
                    ? Center(
                        child: Text(
                          l10n.noStickersFound,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      )
                    : GridView.builder(
                        itemCount: itemCount,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              mainAxisSpacing: 10,
                              crossAxisSpacing: 10,
                              childAspectRatio: 0.78,
                            ),
                        itemBuilder: (context, index) {
                          if (showBadge && index == 0) {
                            return BadgeTile(
                              badge: badge!,
                              owned: collection.isOwned(badge.stickerId),
                              quantity: collection.quantity(badge.stickerId),
                              favorite: collection.isFavorite(badge.stickerId),
                              onTap: () => showStickerActions(
                                context,
                                stickerId: badge.stickerId,
                                title: badge.title,
                                subtitle:
                                    '${strings.typeBadge} · ${widget.country.name}',
                                icon: Icons.shield_outlined,
                              ),
                              onLongPress: () => _toggleOwned(badge.stickerId),
                            );
                          }
                          final player =
                              players[index - (showBadge ? 1 : 0)];
                          return StickerTile(
                            player: player,
                            owned: collection.isOwned(player.stickerId),
                            quantity: collection.quantity(player.stickerId),
                            favorite: collection.isFavorite(player.stickerId),
                            wanted: collection.isWanted(player.stickerId),
                            onTap: () => _openPlayer(player),
                            onLongPress: () => _toggleOwned(player.stickerId),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FilterChips extends StatelessWidget {
  final _TypeFilter type;
  final _StatusFilter status;
  final AppStrings strings;
  final ValueChanged<_TypeFilter> onType;
  final ValueChanged<_StatusFilter> onStatus;

  const _FilterChips({
    required this.type,
    required this.status,
    required this.strings,
    required this.onType,
    required this.onStatus,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 8,
          children: [
            ChoiceChip(
              label: Text(strings.filterAll),
              selected: type == _TypeFilter.all,
              onSelected: (_) => onType(_TypeFilter.all),
            ),
            ChoiceChip(
              label: Text(strings.filterPlayers),
              selected: type == _TypeFilter.players,
              onSelected: (_) => onType(_TypeFilter.players),
            ),
            ChoiceChip(
              label: Text(strings.filterBadges),
              selected: type == _TypeFilter.badges,
              onSelected: (_) => onType(_TypeFilter.badges),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: [
            ChoiceChip(
              label: Text(strings.filterAll),
              selected: status == _StatusFilter.all,
              onSelected: (_) => onStatus(_StatusFilter.all),
            ),
            ChoiceChip(
              label: Text(strings.filterOwned),
              selected: status == _StatusFilter.owned,
              onSelected: (_) => onStatus(_StatusFilter.owned),
            ),
            ChoiceChip(
              label: Text(strings.filterMissing),
              selected: status == _StatusFilter.missing,
              onSelected: (_) => onStatus(_StatusFilter.missing),
            ),
          ],
        ),
      ],
    );
  }
}
