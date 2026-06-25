// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'World Cup 2026 Album';

  @override
  String get menuProfile => 'Profile';

  @override
  String get menuSettings => 'Settings';

  @override
  String get myStickers => 'My stickers';

  @override
  String get addSticker => 'Add sticker';

  @override
  String get searchPlayerHint => 'Search player...';

  @override
  String get noStickersFound => 'No stickers found';

  @override
  String get markAsOwned => 'Mark as collected';

  @override
  String get removeFromAlbum => 'Remove from collection';

  @override
  String get stickerMarkedOwned => 'Sticker marked as collected';

  @override
  String get stickerMarkedMissing => 'Sticker marked as missing';

  @override
  String get labelCountry => 'Country';

  @override
  String get labelPosition => 'Position';

  @override
  String get labelStickerNumber => 'Sticker number';

  @override
  String get positionGoalkeeper => 'Goalkeeper';

  @override
  String get positionDefender => 'Defender';

  @override
  String get positionMidfielder => 'Midfielder';

  @override
  String get positionForward => 'Forward';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsThemeSection => 'Theme';

  @override
  String get settingsDarkMode => 'Dark theme';

  @override
  String get settingsLanguageSection => 'Language';

  @override
  String get languagePortuguese => 'Portuguese';

  @override
  String get languageEnglish => 'English';

  @override
  String get profileTitle => 'Profile';

  @override
  String profileStickersSummary(int owned, int total) {
    return '$owned of $total stickers collected';
  }

  @override
  String get stickerStatusOwned => 'Collected';

  @override
  String get stickerStatusMissing => 'Missing';

  @override
  String countryProgress(int owned, int total) {
    return '$owned/$total';
  }

  @override
  String get playerDetailTitle => 'Player details';
}
