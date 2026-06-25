import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_pt.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('pt'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'World Cup 2026 Album'**
  String get appTitle;

  /// No description provided for @menuProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get menuProfile;

  /// No description provided for @menuSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get menuSettings;

  /// No description provided for @myStickers.
  ///
  /// In en, this message translates to:
  /// **'My stickers'**
  String get myStickers;

  /// No description provided for @addSticker.
  ///
  /// In en, this message translates to:
  /// **'Add sticker'**
  String get addSticker;

  /// No description provided for @searchPlayerHint.
  ///
  /// In en, this message translates to:
  /// **'Search player...'**
  String get searchPlayerHint;

  /// No description provided for @noStickersFound.
  ///
  /// In en, this message translates to:
  /// **'No stickers found'**
  String get noStickersFound;

  /// No description provided for @markAsOwned.
  ///
  /// In en, this message translates to:
  /// **'Mark as collected'**
  String get markAsOwned;

  /// No description provided for @removeFromAlbum.
  ///
  /// In en, this message translates to:
  /// **'Remove from collection'**
  String get removeFromAlbum;

  /// No description provided for @stickerMarkedOwned.
  ///
  /// In en, this message translates to:
  /// **'Sticker marked as collected'**
  String get stickerMarkedOwned;

  /// No description provided for @stickerMarkedMissing.
  ///
  /// In en, this message translates to:
  /// **'Sticker marked as missing'**
  String get stickerMarkedMissing;

  /// No description provided for @labelCountry.
  ///
  /// In en, this message translates to:
  /// **'Country'**
  String get labelCountry;

  /// No description provided for @labelPosition.
  ///
  /// In en, this message translates to:
  /// **'Position'**
  String get labelPosition;

  /// No description provided for @labelStickerNumber.
  ///
  /// In en, this message translates to:
  /// **'Sticker number'**
  String get labelStickerNumber;

  /// No description provided for @positionGoalkeeper.
  ///
  /// In en, this message translates to:
  /// **'Goalkeeper'**
  String get positionGoalkeeper;

  /// No description provided for @positionDefender.
  ///
  /// In en, this message translates to:
  /// **'Defender'**
  String get positionDefender;

  /// No description provided for @positionMidfielder.
  ///
  /// In en, this message translates to:
  /// **'Midfielder'**
  String get positionMidfielder;

  /// No description provided for @positionForward.
  ///
  /// In en, this message translates to:
  /// **'Forward'**
  String get positionForward;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @settingsThemeSection.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get settingsThemeSection;

  /// No description provided for @settingsDarkMode.
  ///
  /// In en, this message translates to:
  /// **'Dark theme'**
  String get settingsDarkMode;

  /// No description provided for @settingsLanguageSection.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get settingsLanguageSection;

  /// No description provided for @languagePortuguese.
  ///
  /// In en, this message translates to:
  /// **'Portuguese'**
  String get languagePortuguese;

  /// No description provided for @languageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// No description provided for @profileTitle.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profileTitle;

  /// No description provided for @profileStickersSummary.
  ///
  /// In en, this message translates to:
  /// **'{owned} of {total} stickers collected'**
  String profileStickersSummary(int owned, int total);

  /// No description provided for @stickerStatusOwned.
  ///
  /// In en, this message translates to:
  /// **'Collected'**
  String get stickerStatusOwned;

  /// No description provided for @stickerStatusMissing.
  ///
  /// In en, this message translates to:
  /// **'Missing'**
  String get stickerStatusMissing;

  /// No description provided for @countryProgress.
  ///
  /// In en, this message translates to:
  /// **'{owned}/{total}'**
  String countryProgress(int owned, int total);

  /// No description provided for @playerDetailTitle.
  ///
  /// In en, this message translates to:
  /// **'Player details'**
  String get playerDetailTitle;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'pt'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'pt':
      return AppLocalizationsPt();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
