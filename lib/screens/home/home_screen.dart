import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/repositories/country_repository.dart';
import '../../data/repositories/player_repository.dart';
import '../../l10n/app_localizations.dart';
import '../../l10n/app_strings.dart';
import '../../models/country.dart';
import '../../providers/collection_provider.dart';
import '../../widgets/app_drawer.dart';
import 'widgets/country_grid_card.dart';
import 'widgets/country_stickers_panel.dart';

/// Main screen: a 2-column grid of national teams, filterable by confederation.
/// Tapping a team expands its sticker album page inline, right below the
/// tapped row.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? _expandedCountryId;
  String? _confederation;

  void _toggleExpanded(String countryId) {
    setState(() {
      _expandedCountryId = _expandedCountryId == countryId ? null : countryId;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final strings = AppStrings.of(context);
    final allCountries = context.read<CountryRepository>().getAllCountries();
    final playerRepository = context.read<PlayerRepository>();
    final collection = context.watch<CollectionProvider>();

    final confederations = _confederationsOf(allCountries);
    final countries = _confederation == null
        ? allCountries
        : allCountries
              .where((c) => c.confederation == _confederation)
              .toList(growable: false);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.appTitle)),
      drawer: const AppDrawer(),
      body: SafeArea(
        child: Column(
          children: [
            if (confederations.isNotEmpty)
              _ConfederationFilter(
                confederations: confederations,
                selected: _confederation,
                allLabel: strings.allConfederations,
                onSelected: (value) => setState(() {
                  _confederation = value;
                  _expandedCountryId = null;
                }),
              ),
            Expanded(
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
                  } else if (second != null &&
                      second.id == _expandedCountryId) {
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
                                collection,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: second != null
                                  ? _buildCard(
                                      context,
                                      second,
                                      playerRepository,
                                      collection,
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
          ],
        ),
      ),
    );
  }

  List<String> _confederationsOf(List<Country> countries) {
    final set = <String>{};
    for (final c in countries) {
      if (c.confederation != null) set.add(c.confederation!);
    }
    final list = set.toList()..sort();
    return list;
  }

  Widget _buildCard(
    BuildContext context,
    Country country,
    PlayerRepository playerRepository,
    CollectionProvider collection,
  ) {
    final roster = playerRepository.getByCountry(country.id);
    final owned = collection.ownedCountAmong(roster.map((p) => p.stickerId));
    return CountryGridCard(
      country: country,
      ownedCount: owned,
      totalCount: roster.length,
      expanded: country.id == _expandedCountryId,
      onTap: () => _toggleExpanded(country.id),
    );
  }
}

class _ConfederationFilter extends StatelessWidget {
  final List<String> confederations;
  final String? selected;
  final String allLabel;
  final ValueChanged<String?> onSelected;

  const _ConfederationFilter({
    required this.confederations,
    required this.selected,
    required this.allLabel,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 52,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: Text(allLabel),
              selected: selected == null,
              onSelected: (_) => onSelected(null),
            ),
          ),
          for (final conf in confederations)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: ChoiceChip(
                label: Text(conf),
                selected: selected == conf,
                onSelected: (_) => onSelected(conf),
              ),
            ),
        ],
      ),
    );
  }
}
