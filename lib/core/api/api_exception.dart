/// Erro de comunicação com a API.
///
/// Carrega o [statusCode] HTTP (0 quando há falha de rede) e uma [message]
/// já pronta para exibir ao usuário.
class ApiException implements Exception {
  final int statusCode;
  final String message;

  const ApiException(this.statusCode, this.message);

  /// Indica credenciais inválidas / token expirado.
  bool get isUnauthorized => statusCode == 401;

  @override
  String toString() => 'ApiException($statusCode): $message';
}
