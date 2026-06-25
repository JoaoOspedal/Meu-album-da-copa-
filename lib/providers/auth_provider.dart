import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/api/api_client.dart';
import '../core/api/api_exception.dart';
import '../models/user_profile.dart';

enum AuthStatus { unknown, authenticated, unauthenticated }

/// Owns the authentication state: token, current [UserProfile] and the
/// login/register/logout flows. Persists the token with `shared_preferences`
/// so the session survives app restarts.
class AuthProvider extends ChangeNotifier {
  AuthProvider(this._api);

  final ApiClient _api;

  static const _tokenKey = 'auth_token';

  AuthStatus _status = AuthStatus.unknown;
  UserProfile? _profile;
  bool _busy = false;

  AuthStatus get status => _status;
  UserProfile? get profile => _profile;
  bool get isBusy => _busy;
  bool get isAuthenticated => _status == AuthStatus.authenticated;

  /// Tries to restore a previous session from the stored token.
  Future<void> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(_tokenKey);
    if (token == null) {
      _setStatus(AuthStatus.unauthenticated);
      return;
    }
    _api.setToken(token);
    try {
      final me = await _api.get('/auth/me') as Map<String, dynamic>;
      _profile = UserProfile.fromJson(me);
      _setStatus(AuthStatus.authenticated);
    } on ApiException {
      // Token inválido/expirado: limpa e exige novo login.
      await _clearToken();
      _setStatus(AuthStatus.unauthenticated);
    }
  }

  Future<void> login(String usernameOrEmail, String password) async {
    await _runAuth(() async {
      final data =
          await _api.postForm('/auth/login', {
                'username': usernameOrEmail,
                'password': password,
              })
              as Map<String, dynamic>;
      await _applyToken(data);
    });
  }

  Future<void> register(String username, String email, String password) async {
    await _runAuth(() async {
      final data =
          await _api.post(
                '/auth/register',
                body: {
                  'username': username,
                  'email': email,
                  'password': password,
                },
              )
              as Map<String, dynamic>;
      await _applyToken(data);
    });
  }

  Future<void> logout() async {
    await _clearToken();
    _profile = null;
    _setStatus(AuthStatus.unauthenticated);
  }

  Future<void> _applyToken(Map<String, dynamic> tokenResponse) async {
    final token = tokenResponse['access_token'] as String;
    _api.setToken(token);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
    _profile = UserProfile.fromJson(
      tokenResponse['user'] as Map<String, dynamic>,
    );
    _setStatus(AuthStatus.authenticated);
  }

  Future<void> _runAuth(Future<void> Function() action) async {
    _busy = true;
    notifyListeners();
    try {
      await action();
    } finally {
      _busy = false;
      notifyListeners();
    }
  }

  Future<void> _clearToken() async {
    _api.setToken(null);
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
  }

  void _setStatus(AuthStatus status) {
    _status = status;
    notifyListeners();
  }
}
