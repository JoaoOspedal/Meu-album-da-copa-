import 'package:flutter/material.dart';

import '../../../l10n/app_localizations.dart';
import '../../../models/country.dart';

/// Collapsed grid item for a national team: flag avatar, name, collection
/// progress and a chevron indicating the expand/collapse state.
class CountryGridCard extends StatelessWidget {
  final Country country;
  final int ownedCount;
  final int totalCount;
  final bool expanded;
  final VoidCallback onTap;

  const CountryGridCard({
    super.key,
    required this.country,
    required this.ownedCount,
    required this.totalCount,
    required this.expanded,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final scheme = Theme.of(context).colorScheme;

    return Semantics(
      button: true,
      label: country.name,
      child: Card(
        elevation: expanded ? 3 : 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: BorderSide(
            color: expanded ? scheme.primary : Colors.transparent,
            width: 2,
          ),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: country.color,
                  foregroundImage: country.flagUrl != null
                      ? NetworkImage(country.flagUrl!)
                      : null,
                  child: Text(
                    country.code,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        country.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.titleSmall
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        l10n.countryProgress(ownedCount, totalCount),
                        style: Theme.of(context).textTheme.bodySmall
                            ?.copyWith(color: scheme.onSurfaceVariant),
                      ),
                    ],
                  ),
                ),
                AnimatedRotation(
                  turns: expanded ? 0.5 : 0,
                  duration: const Duration(milliseconds: 200),
                  child: Icon(Icons.expand_more, color: scheme.primary),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
