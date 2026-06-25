import 'package:flutter/widgets.dart';

/// Strings das telas adicionadas na integração com o backend (login, coleção,
/// filtros, estatísticas).
///
/// As telas originais usam `AppLocalizations` (geradas a partir dos `.arb`).
/// Como estas strings novas são muitas e o app suporta apenas PT/EN, elas ficam
/// centralizadas aqui para facilitar a manutenção sem depender da geração de
/// código de l10n.
class AppStrings {
  AppStrings(this.locale);

  final Locale locale;

  static AppStrings of(BuildContext context) =>
      AppStrings(Localizations.localeOf(context));

  bool get _pt => locale.languageCode == 'pt';

  String _t(String pt, String en) => _pt ? pt : en;

  // ---- Autenticação ----
  String get loginTitle => _t('Entrar', 'Sign in');
  String get loginSubtitle =>
      _t('Álbum da Copa do Mundo 2026', 'World Cup 2026 Album');
  String get usernameOrEmail => _t('Usuário ou e-mail', 'Username or email');
  String get username => _t('Usuário', 'Username');
  String get email => _t('E-mail', 'Email');
  String get password => _t('Senha', 'Password');
  String get confirmPassword => _t('Confirmar senha', 'Confirm password');
  String get loginButton => _t('Entrar', 'Sign in');
  String get registerButton => _t('Criar conta', 'Create account');
  String get noAccountYet =>
      _t('Não tem conta? Cadastre-se', "Don't have an account? Sign up");
  String get alreadyHaveAccount =>
      _t('Já tenho conta', 'I already have an account');
  String get registerTitle => _t('Criar conta', 'Create account');
  String get logout => _t('Sair', 'Log out');
  String get fieldRequired => _t('Campo obrigatório', 'Required field');
  String get passwordsDoNotMatch =>
      _t('As senhas não coincidem', 'Passwords do not match');
  String get passwordTooShort =>
      _t('Mínimo de 6 caracteres', 'At least 6 characters');
  String get usernameTooShort =>
      _t('Mínimo de 3 caracteres', 'At least 3 characters');

  // ---- Coleção / menu ----
  String get collectionSection => _t('Minha coleção', 'My collection');
  String get menuDuplicates => _t('Repetidas', 'Duplicates');
  String get menuFavorites => _t('Favoritas', 'Favorites');
  String get menuWishlist => _t('Lista de desejos', 'Wishlist');
  String get duplicatesTitle => _t('Figurinhas repetidas', 'Duplicate stickers');
  String get favoritesTitle => _t('Favoritas', 'Favorites');
  String get wishlistTitle => _t('Lista de desejos', 'Wishlist');
  String get emptyDuplicates =>
      _t('Você ainda não tem figurinhas repetidas.',
          "You don't have any duplicates yet.");
  String get emptyFavorites =>
      _t('Você ainda não favoritou nenhuma figurinha.',
          "You haven't favorited any sticker yet.");
  String get emptyWishlist =>
      _t('Sua lista de desejos está vazia.', 'Your wishlist is empty.');

  // ---- Ações na figurinha ----
  String copies(int n) => _t('$n cópias', '$n copies');
  String get inCollection => _t('Na coleção', 'In collection');
  String get addToCollection => _t('Adicionar à coleção', 'Add to collection');
  String get favorite => _t('Favoritar', 'Favorite');
  String get wishlist => _t('Desejar', 'Wishlist');
  String get markedFavorite =>
      _t('Adicionada aos favoritos', 'Added to favorites');
  String get unmarkedFavorite =>
      _t('Removida dos favoritos', 'Removed from favorites');
  String get markedWishlist =>
      _t('Adicionada à lista de desejos', 'Added to wishlist');
  String get unmarkedWishlist =>
      _t('Removida da lista de desejos', 'Removed from wishlist');
  String get labelClub => _t('Clube', 'Club');
  String get labelShirtNumber => _t('Número da camisa', 'Shirt number');
  String get labelType => _t('Tipo', 'Type');
  String get labelQuantity => _t('Quantidade', 'Quantity');
  String get typePlayer => _t('Jogador', 'Player');
  String get typeBadge => _t('Brasão da seleção', 'Team badge');
  String get badgeSticker => _t('Brasão', 'Badge');

  // ---- Filtros ----
  String get filters => _t('Filtros', 'Filters');
  String get filterAll => _t('Todas', 'All');
  String get filterPlayers => _t('Jogadores', 'Players');
  String get filterBadges => _t('Brasões', 'Badges');
  String get filterOwned => _t('Coladas', 'Collected');
  String get filterMissing => _t('Faltando', 'Missing');
  String get allConfederations =>
      _t('Todas as confederações', 'All confederations');

  // ---- Estatísticas ----
  String get statsTitle => _t('Progresso do álbum', 'Album progress');
  String get statsTotal => _t('Total de figurinhas', 'Total stickers');
  String get statsOwned => _t('Coladas (únicas)', 'Collected (unique)');
  String get statsMissing => _t('Faltando', 'Missing');
  String get statsDuplicates => _t('Repetidas', 'Duplicates');
  String get statsFavorites => _t('Favoritas', 'Favorites');
  String get statsWishlist => _t('Lista de desejos', 'Wishlist');
  String completionLabel(double percent) =>
      _t('${percent.toStringAsFixed(1)}% completo',
          '${percent.toStringAsFixed(1)}% complete');

  // ---- Genéricos ----
  String get loadingCatalog => _t('Carregando álbum...', 'Loading album...');
  String get retry => _t('Tentar novamente', 'Try again');
  String get genericError =>
      _t('Algo deu errado. Tente novamente.', 'Something went wrong. Try again.');
}
