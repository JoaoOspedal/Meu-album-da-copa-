import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../l10n/app_localizations.dart';
import '../../providers/locale_provider.dart';
import '../../providers/theme_provider.dart';

/// Lets the user switch between light/dark theme and pick the app language.
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final themeProvider = context.watch<ThemeProvider>();
    final localeProvider = context.watch<LocaleProvider>();

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settingsTitle)),
      body: SafeArea(
        child: ListView(
          children: [
            _SectionHeader(title: l10n.settingsThemeSection),
            SwitchListTile(
              secondary: const Icon(Icons.dark_mode_outlined),
              title: Text(l10n.settingsDarkMode),
              value: themeProvider.isDarkMode,
              onChanged: themeProvider.setDarkMode,
            ),
            const Divider(),
            _SectionHeader(title: l10n.settingsLanguageSection),
            RadioGroup<Locale>(
              groupValue: localeProvider.locale,
              onChanged: (locale) {
                if (locale != null) localeProvider.setLocale(locale);
              },
              child: Column(
                children: [
                  RadioListTile<Locale>(
                    secondary: const Icon(Icons.language),
                    title: Text(l10n.languagePortuguese),
                    value: const Locale('pt'),
                  ),
                  RadioListTile<Locale>(
                    secondary: const Icon(Icons.language),
                    title: Text(l10n.languageEnglish),
                    value: const Locale('en'),
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

class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
          color: Theme.of(context).colorScheme.primary,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
