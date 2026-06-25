import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../l10n/app_localizations.dart';
import '../../models/country.dart';
import '../../models/player.dart';
import '../../providers/album_provider.dart';
import '../../widgets/search_field.dart';
import '../../widgets/sticker_tile.dart';
import '../player_detail/player_detail_screen.dart';

/// Lists every possible sticker for a team, searchable by player name.
/// Tapping a sticker opens its details; long-pressing toggles collected
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

  List<Player> get _filtered {
    final normalized = _query.trim().toLowerCase();
    if (normalized.isEmpty) return widget.roster;
    return widget.roster
        .where((p) => p.name.toLowerCase().contains(normalized))
        .toList(growable: false);
  }

  void _openPlayer(Player player) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => PlayerDetailScreen(player: player)),
    );
  }

  void _toggleOwned(Player player) {
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
    final players = _filtered;

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
              const SizedBox(height: 16),
              Expanded(
                child: players.isEmpty
                    ? Center(
                        child: Text(
                          l10n.noStickersFound,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      )
                    : GridView.builder(
                        itemCount: players.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              mainAxisSpacing: 10,
                              crossAxisSpacing: 10,
                              childAspectRatio: 0.78,
                            ),
                        itemBuilder: (context, index) {
                          final player = players[index];
                          return StickerTile(
                            player: player,
                            owned: album.isOwned(player.id),
                            onTap: () => _openPlayer(player),
                            onLongPress: () => _toggleOwned(player),
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
