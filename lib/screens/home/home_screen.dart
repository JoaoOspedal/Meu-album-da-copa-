import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/repositories/country_repository.dart';
import '../../data/repositories/player_repository.dart';
import '../../l10n/app_localizations.dart';
import '../../models/country.dart';
import '../../providers/album_provider.dart';
import '../../widgets/app_drawer.dart';
import 'widgets/country_grid_card.dart';
import 'widgets/country_stickers_panel.dart';

/// Main screen: a 2-column grid of national teams. Tapping a team expands
/// its sticker album page inline, right below the tapped row.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? _expandedCountryId;

  void _toggleExpanded(String countryId) {
    setState(() {
      _expandedCountryId = _expandedCountryId == countryId ? null : countryId;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final countries = context.read<CountryRepository>().getAllCountries();
    final playerRepository = context.read<PlayerRepository>();
    final album = context.watch<AlbumProvider>();

    return Scaffold(
      appBar: AppBar(title: Text(l10n.appTitle)),
      drawer: const AppDrawer(),
      body: SafeArea(
        child: ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: (countries.length / 2).ceil(),
          itemBuilder: (context, rowIndex) {
            final firstIndex = rowIndex * 2;
            final secondIndex = firstIndex + 1;
            final first = countries[firstIndex];
            final second = secondIndex < countries.length
                ? countries[secondIndex]
                : null;

            Country? expandedInRow;
            if (first.id == _expandedCountryId) {
              expandedInRow = first;
            } else if (second != null && second.id == _expandedCountryId) {
              expandedInRow = second;
            }

            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: _buildCard(
                          context,
                          first,
                          playerRepository,
                          album,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: second != null
                            ? _buildCard(
                                context,
                                second,
                                playerRepository,
                                album,
                              )
                            : const SizedBox.shrink(),
                      ),
                    ],
                  ),
                  AnimatedSize(
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.easeInOut,
                    alignment: Alignment.topCenter,
                    child: expandedInRow != null
                        ? CountryStickersPanel(
                            key: ValueKey(expandedInRow.id),
                            country: expandedInRow,
                            roster: playerRepository.getByCountry(
                              expandedInRow.id,
                            ),
                          )
                        : const SizedBox(width: double.infinity),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildCard(
    BuildContext context,
    Country country,
    PlayerRepository playerRepository,
    AlbumProvider album,
  ) {
    final roster = playerRepository.getByCountry(country.id);
    final owned = album.ownedCountAmong(roster.map((p) => p.id));
    return CountryGridCard(
      country: country,
      ownedCount: owned,
      totalCount: roster.length,
      expanded: country.id == _expandedCountryId,
      onTap: () => _toggleExpanded(country.id),
    );
  }
}
