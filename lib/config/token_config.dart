class TokenConfig {
  // Token da sessão. Vazio até o login; populado por AuthService.login.
  static String token = '';

  // Dados do usuário logado (preenchidos via GET /api/users/me).
  static String? userId;
  static String? userName;
  static String? userEmail;
}
