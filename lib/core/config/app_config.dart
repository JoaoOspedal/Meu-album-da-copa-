import 'package:flutter/foundation.dart';

/// Configuração de ambiente do app.
///
/// A URL base da API é escolhida automaticamente conforme a plataforma:
///  - Android (emulador): `10.0.2.2` aponta para o `localhost` da máquina host.
///  - Web/Desktop/iOS simulador: `127.0.0.1`.
///
/// Para apontar para um servidor real, defina `--dart-define=API_BASE_URL=...`
/// ao rodar/buildar o app.
class AppConfig {
  AppConfig._();

  static const String _envBaseUrl = String.fromEnvironment('API_BASE_URL');

  static String get apiBaseUrl {
    if (_envBaseUrl.isNotEmpty) return _envBaseUrl;
    if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
      return 'http://10.0.2.2:8000';
    }
    return 'http://127.0.0.1:8000';
  }
}
