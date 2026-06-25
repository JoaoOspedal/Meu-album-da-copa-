import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../l10n/app_localizations.dart';
import '../../l10n/app_strings.dart';
import '../../models/user_profile.dart';
import '../../providers/auth_provider.dart';
import '../../providers/collection_provider.dart';

/// Shows the signed-in user's photo, name, e-mail and the album progress
/// statistics coming from the backend.
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final strings = AppStrings.of(context);
    final user =
        context.watch<AuthProvider>().profile ??
        const UserProfile(name: '?');
    final stats = context.watch<CollectionProvider>().stats;
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.profileTitle)),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 56,
                    backgroundColor: scheme.primary,
                    foregroundImage: user.photoUrl != null
                        ? NetworkImage(user.photoUrl!)
                        : null,
                    child: Text(
                      user.initials,
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: scheme.onPrimary,
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
                  if (user.email != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        user.email!,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: scheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            _CompletionCard(
              percent: stats.completionPercent,
              owned: stats.ownedUnique,
              total: stats.totalStickers,
              strings: strings,
            ),
            const SizedBox(height: 16),
            Text(
              strings.statsTitle,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 2.4,
              children: [
                _StatTile(
                  icon: Icons.style_outlined,
                  label: strings.statsTotal,
                  value: '${stats.totalStickers}',
                ),
                _StatTile(
                  icon: Icons.check_circle_outline,
                  label: strings.statsOwned,
                  value: '${stats.ownedUnique}',
                ),
                _StatTile(
                  icon: Icons.help_outline,
                  label: strings.statsMissing,
                  value: '${stats.missing}',
                ),
                _StatTile(
                  icon: Icons.copy_all_outlined,
                  label: strings.statsDuplicates,
                  value: '${stats.duplicateUnits}',
                ),
                _StatTile(
                  icon: Icons.favorite_border,
                  label: strings.statsFavorites,
                  value: '${stats.favorites}',
                ),
                _StatTile(
                  icon: Icons.bookmark_border,
                  label: strings.statsWishlist,
                  value: '${stats.wishlist}',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _CompletionCard extends StatelessWidget {
  final double percent;
  final int owned;
  final int total;
  final AppStrings strings;

  const _CompletionCard({
    required this.percent,
    required this.owned,
    required this.total,
    required this.strings,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              strings.completionLabel(percent),
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: scheme.primary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '$owned / $total',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: scheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: (percent / 100).clamp(0.0, 1.0),
                minHeight: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _StatTile({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          children: [
            Icon(icon, color: scheme.primary),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    value,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    label,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: scheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
