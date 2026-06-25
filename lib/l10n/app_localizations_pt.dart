// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get appTitle => 'Álbum Copa 2026';

  @override
  String get menuProfile => 'Perfil';

  @override
  String get menuSettings => 'Configurações';

  @override
  String get myStickers => 'Minhas figurinhas';

  @override
  String get addSticker => 'Adicionar figurinha';

  @override
  String get searchPlayerHint => 'Buscar jogador...';

  @override
  String get noStickersFound => 'Nenhuma figurinha encontrada';

  @override
  String get markAsOwned => 'Marcar como colada';

  @override
  String get removeFromAlbum => 'Remover da coleção';

  @override
  String get stickerMarkedOwned => 'Figurinha marcada como colada';

  @override
  String get stickerMarkedMissing => 'Figurinha marcada como faltando';

  @override
  String get labelCountry => 'Seleção';

  @override
  String get labelPosition => 'Posição';

  @override
  String get labelStickerNumber => 'Número da figurinha';

  @override
  String get positionGoalkeeper => 'Goleiro';

  @override
  String get positionDefender => 'Defensor';

  @override
  String get positionMidfielder => 'Meio-campo';

  @override
  String get positionForward => 'Atacante';

  @override
  String get settingsTitle => 'Configurações';

  @override
  String get settingsThemeSection => 'Tema';

  @override
  String get settingsDarkMode => 'Tema escuro';

  @override
  String get settingsLanguageSection => 'Idioma';

  @override
  String get languagePortuguese => 'Português';

  @override
  String get languageEnglish => 'Inglês';

  @override
  String get profileTitle => 'Perfil';

  @override
  String profileStickersSummary(int owned, int total) {
    return '$owned de $total figurinhas coladas';
  }

  @override
  String get stickerStatusOwned => 'Colada';

  @override
  String get stickerStatusMissing => 'Faltando';

  @override
  String countryProgress(int owned, int total) {
    return '$owned/$total';
  }

  @override
  String get playerDetailTitle => 'Detalhes do jogador';
}
