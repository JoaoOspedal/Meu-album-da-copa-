import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/repositories/player_repository.dart';
import '../../l10n/app_localizations.dart';
import '../../providers/album_provider.dart';
import '../../providers/user_provider.dart';

/// Shows the current (mock) user's photo, name and collection summary.
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final user = context.watch<UserProvider>().profile;
    final album = context.watch<AlbumProvider>();
    final playerRepository = context.read<PlayerRepository>();
    final totalPlayers = playerRepository.getAll().length;
    final ownedTotal = album.totalOwnedAcross(playerRepository);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.profileTitle)),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(
                  radius: 56,
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundImage: user.photoUrl != null
                      ? NetworkImage(user.photoUrl!)
                      : null,
                  child: Text(
                    user.initials,
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  user.name,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  l10n.profileStickersSummary(ownedTotal, totalPlayers),
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
