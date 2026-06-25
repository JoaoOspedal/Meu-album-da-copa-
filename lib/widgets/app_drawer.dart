import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../l10n/app_localizations.dart';
import '../l10n/app_strings.dart';
import '../models/user_profile.dart';
import '../providers/auth_provider.dart';
import '../providers/collection_provider.dart';
import '../screens/collection/collection_list_screen.dart';
import '../screens/profile/profile_screen.dart';
import '../screens/settings/settings_screen.dart';

/// Side menu opened from the top-left button: profile, the user's collection
/// shortcuts (duplicates / favorites / wishlist), settings and logout.
class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final strings = AppStrings.of(context);
    final user =
        context.watch<AuthProvider>().profile ??
        const UserProfile(name: '?');

    void push(Widget screen) {
      Navigator.of(context).pop();
      Navigator.of(
        context,
      ).push(MaterialPageRoute(builder: (_) => screen));
    }

    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: Theme.of(context).colorScheme.onPrimary,
                    foregroundImage: user.photoUrl != null
                        ? NetworkImage(user.photoUrl!)
                        : null,
                    child: Text(
                      user.initials,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          user.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onPrimary,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        if (user.email != null)
                          Text(
                            user.email!,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Theme.of(
                                context,
                              ).colorScheme.onPrimary.withValues(alpha: 0.8),
                              fontSize: 13,
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.person_outline),
              title: Text(l10n.menuProfile),
              onTap: () => push(const ProfileScreen()),
            ),
            const Divider(),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  strings.collectionSection,
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.copy_all_outlined),
              title: Text(strings.menuDuplicates),
              onTap: () => push(
                CollectionListScreen(
                  title: strings.duplicatesTitle,
                  emptyMessage: strings.emptyDuplicates,
                  emptyIcon: Icons.copy_all_outlined,
                  selector: (c) => c.duplicates,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.favorite_border),
              title: Text(strings.menuFavorites),
              onTap: () => push(
                CollectionListScreen(
                  title: strings.favoritesTitle,
                  emptyMessage: strings.emptyFavorites,
                  emptyIcon: Icons.favorite_border,
                  selector: (c) => c.favorites,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.bookmark_border),
              title: Text(strings.menuWishlist),
              onTap: () => push(
                CollectionListScreen(
                  title: strings.wishlistTitle,
                  emptyMessage: strings.emptyWishlist,
                  emptyIcon: Icons.bookmark_border,
                  selector: (c) => c.wishlist,
                ),
              ),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.settings_outlined),
              title: Text(l10n.menuSettings),
              onTap: () => push(const SettingsScreen()),
            ),
            const Spacer(),
            ListTile(
              leading: const Icon(Icons.logout),
              title: Text(strings.logout),
              onTap: () {
                Navigator.of(context).pop();
                context.read<CollectionProvider>().reset();
                context.read<AuthProvider>().logout();
              },
            ),
          ],
        ),
      ),
    );
  }
}
