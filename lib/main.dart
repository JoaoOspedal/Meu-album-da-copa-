import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app.dart';
import 'data/mock/mock_country_repository.dart';
import 'data/mock/mock_data.dart';
import 'data/mock/mock_player_repository.dart';
import 'data/repositories/country_repository.dart';
import 'data/repositories/player_repository.dart';
import 'models/user_profile.dart';
import 'providers/album_provider.dart';
import 'providers/locale_provider.dart';
import 'providers/theme_provider.dart';
import 'providers/user_provider.dart';

void main() {
  runApp(const RootApp());
}

/// Wires concrete data sources and app-wide state before handing off to
/// [AlbumApp]. Swapping the mock repositories for real ones only requires
/// changing the two `Provider<...>` lines below.
class RootApp extends StatelessWidget {
  const RootApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<CountryRepository>(create: (_) => MockCountryRepository()),
        Provider<PlayerRepository>(create: (_) => MockPlayerRepository()),
        ChangeNotifierProvider(
          create: (_) =>
              AlbumProvider(initiallyOwned: MockData.initiallyOwnedStickerIds),
        ),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => LocaleProvider()),
        ChangeNotifierProvider(
          create: (_) =>
              UserProvider(profile: const UserProfile(name: 'João Pedro')),
        ),
      ],
      child: const AlbumApp(),
    );
  }
}
