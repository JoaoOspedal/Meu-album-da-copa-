import 'dart:convert';

import 'package:http/http.dart' as http;

import '../config/app_config.dart';
import 'api_exception.dart';

/// Cliente HTTP fino sobre `package:http`.
///
/// Centraliza a URL base, o token de autenticação (Bearer), a (de)serialização
/// JSON e a conversão de respostas de erro em [ApiException].
class ApiClient {
  ApiClient({http.Client? httpClient, String? baseUrl})
    : _http = httpClient ?? http.Client(),
      baseUrl = baseUrl ?? AppConfig.apiBaseUrl;

  final http.Client _http;
  final String baseUrl;

  String? _token;

  /// Define (ou limpa, com `null`) o token usado no header `Authorization`.
  void setToken(String? token) => _token = token;

  bool get hasToken => _token != null;

  Map<String, String> _headers({bool json = true}) => {
    if (json) 'Content-Type': 'application/json',
    'Accept': 'application/json',
    if (_token != null) 'Authorization': 'Bearer $_token',
  };

  Uri _uri(String path, [Map<String, dynamic>? query]) {
    final params = <String, String>{};
    query?.forEach((key, value) {
      if (value != null) params[key] = value.toString();
    });
    return Uri.parse(
      '$baseUrl$path',
    ).replace(queryParameters: params.isEmpty ? null : params);
  }

  Future<dynamic> get(String path, {Map<String, dynamic>? query}) =>
      _send(() => _http.get(_uri(path, query), headers: _headers(json: false)));

  Future<dynamic> post(String path, {Object? body}) => _send(
    () => _http.post(
      _uri(path),
      headers: _headers(),
      body: body == null ? null : jsonEncode(body),
    ),
  );

  Future<dynamic> put(String path, {Object? body}) => _send(
    () => _http.put(
      _uri(path),
      headers: _headers(),
      body: body == null ? null : jsonEncode(body),
    ),
  );

  Future<dynamic> patch(String path, {Object? body}) => _send(
    () => _http.patch(
      _uri(path),
      headers: _headers(),
      body: body == null ? null : jsonEncode(body),
    ),
  );

  /// POST com corpo `application/x-www-form-urlencoded` (usado no login OAuth2).
  Future<dynamic> postForm(String path, Map<String, String> fields) => _send(
    () => _http.post(
      _uri(path),
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
        'Accept': 'application/json',
        if (_token != null) 'Authorization': 'Bearer $_token',
      },
      body: fields,
    ),
  );

  Future<dynamic> _send(Future<http.Response> Function() request) async {
    final http.Response response;
    try {
      response = await request();
    } catch (_) {
      throw const ApiException(
        0,
        'Não foi possível conectar ao servidor. Verifique sua conexão e se o '
        'backend está rodando.',
      );
    }

    final body = response.body.isEmpty ? null : jsonDecode(response.body);
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return body;
    }
    throw ApiException(response.statusCode, _extractMessage(body, response));
  }

  String _extractMessage(dynamic body, http.Response response) {
    if (body is Map && body['detail'] != null) {
      final detail = body['detail'];
      if (detail is String) return detail;
      // Erros de validação do FastAPI vêm como lista de objetos.
      if (detail is List && detail.isNotEmpty) {
        final first = detail.first;
        if (first is Map && first['msg'] != null) return first['msg'].toString();
      }
    }
    return 'Erro inesperado (${response.statusCode}).';
  }

  void dispose() => _http.close();
}
