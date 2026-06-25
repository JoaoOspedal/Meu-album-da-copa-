import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app.dart';
import 'core/api/api_client.dart';
import 'data/catalog_store.dart';
import 'data/repositories/api_country_repository.dart';
import 'data/repositories/api_player_repository.dart';
import 'data/repositories/country_repository.dart';
import 'data/repositories/player_repository.dart';
import 'providers/auth_provider.dart';
import 'providers/collection_provider.dart';
import 'providers/locale_provider.dart';
import 'providers/theme_provider.dart';

void main() {
  runApp(const RootApp());
}

/// Wires the API client, catalog and app-wide state before handing off to
/// [AlbumApp]. The repositories are backed by the backend through
/// [CatalogStore]; swapping data sources only requires changing the providers
/// below.
class RootApp extends StatelessWidget {
  const RootApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<ApiClient>(
          create: (_) => ApiClient(),
          dispose: (_, client) => client.dispose(),
        ),
        Provider<CatalogStore>(
          create: (context) => CatalogStore(context.read<ApiClient>()),
        ),
        Provider<CountryRepository>(
          create: (context) =>
              ApiCountryRepository(context.read<CatalogStore>()),
        ),
        Provider<PlayerRepository>(
          create: (context) =>
              ApiPlayerRepository(context.read<CatalogStore>()),
        ),
        ChangeNotifierProvider(
          create: (context) => CollectionProvider(context.read<ApiClient>()),
        ),
        ChangeNotifierProvider(
          create: (context) =>
              AuthProvider(context.read<ApiClient>())..tryAutoLogin(),
        ),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => LocaleProvider()),
      ],
      child: const AlbumApp(),
    );
  }
}
