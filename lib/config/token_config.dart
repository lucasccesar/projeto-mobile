import 'package:projeto_mobile/models/usuario.dart';

class TokenConfig {
  static String token = '';

  /// Usuário autenticado, carregado de `/api/users/me`.
  static Usuario? usuario;

  /// Role extraída do JWT no login (pode chegar antes de [usuario]).
  static String? userRole;

  static String? get userId => usuario?.id;
  static String? get userName => usuario?.nome;
  static String? get userEmail => usuario?.email;

  static bool get isAdmin {
    final role = userRole?.trim().toUpperCase();
    return role == 'ADMINISTRATOR' || role == 'ROLE_ADMINISTRATOR';
  }

  /// Limpa a sessão (logout).
  static void limpar() {
    token = '';
    usuario = null;
    userRole = null;
  }
}
