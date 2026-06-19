import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:projeto_mobile/config/token_config.dart';
import 'package:projeto_mobile/config/url_config.dart';
import 'package:projeto_mobile/models/usuario.dart';
import 'package:projeto_mobile/services/storage_service.dart';

class AuthService {
  final url = ApiConfig.baseUrl;

  Future<void> login(String email, String senha) async {
    final response = await http.post(
      Uri.parse('$url/api/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': senha}),
    );

    if (response.statusCode != 200) {
      throw Exception(
        _mensagemErro(response, fallbackAuth: 'Email ou senha inválidos'),
      );
    }

    final json = jsonDecode(response.body);
    final token = json['token']?.toString() ?? '';
    TokenConfig.token = token;
    TokenConfig.userRole = _extrairRoleDoToken(TokenConfig.token);

    await StorageService.salvarToken(token);
    await _carregarUsuario();
  }

  Future<bool> tentarReautenticar() async {
    final token = await StorageService.carregarToken();
    if (token == null || token.isEmpty) return false;

    TokenConfig.token = token;
    TokenConfig.userRole = _extrairRoleDoToken(token);

    try {
      await _carregarUsuario();
      return true;
    } catch (_) {
      await logout();
      return false;
    }
  }

  Future<void> logout() async {
    TokenConfig.limpar();
    await StorageService.limparToken();
  }

  Future<void> cadastrar({
    required String nome,
    required String email,
    required String senha,
    String? adminCode,
    int? avatarId,
  }) async {
    final response = await http.post(
      Uri.parse('$url/api/auth/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': nome,
        'email': email,
        'password': senha,
        if (adminCode != null && adminCode.isNotEmpty) 'adminCode': adminCode,
        if (avatarId != null) 'avatarId': avatarId,
      }),
    );

    if (response.statusCode != 201) {
      throw Exception(_mensagemErro(response));
    }

    await login(email, senha);
  }

  Future<void> esqueciSenha(String email) async {
    final response = await http.post(
      Uri.parse('$url/api/auth/forgot-password'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email}),
    );

    if (response.statusCode != 200) {
      throw Exception(_mensagemErro(response));
    }
  }

  Future<void> redefinirSenha({
    required String email,
    required String codigo,
    required String novaSenha,
  }) async {
    final response = await http.post(
      Uri.parse('$url/api/auth/reset-password'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'code': codigo,
        'newPassword': novaSenha,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception(
        _mensagemErro(response, fallbackAuth: 'Código inválido ou expirado'),
      );
    }
  }

  Future<void> _carregarUsuario() async {
    final response = await http.get(
      Uri.parse('$url/api/users/me'),
      headers: {
        'Authorization': 'Bearer ${TokenConfig.token}',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      TokenConfig.usuario = Usuario.fromJson(json);
      TokenConfig.userRole =
          TokenConfig.usuario?.tipo ??
          json['authorities']?.toString() ??
          TokenConfig.userRole;
    } else {
      throw Exception('Sessão inválida');
    }
  }

  Map<String, dynamic>? _decodeJwtPayload(String token) {
    try {
      final parts = token.split('.');
      if (parts.length < 2) return null;

      final normalized = base64Url.normalize(parts[1]);
      final decoded = utf8.decode(base64Url.decode(normalized));
      return jsonDecode(decoded) as Map<String, dynamic>;
    } catch (_) {
      return null;
    }
  }

  String? _extrairRoleDoToken(String token) {
    final payload = _decodeJwtPayload(token);
    if (payload == null) return null;

    final userType = payload['userType']?.toString();
    if (userType != null && userType.isNotEmpty) return userType;

    final type = payload['type']?.toString();
    if (type != null && type.isNotEmpty) return type;

    final role = payload['role']?.toString();
    if (role != null && role.isNotEmpty) return role;

    final roles = payload['roles'];
    if (roles is List && roles.isNotEmpty) {
      return roles.first.toString();
    }

    final authorities = payload['authorities'];
    if (authorities is List && authorities.isNotEmpty) {
      return authorities.first.toString();
    }

    return null;
  }

  String _mensagemErro(http.Response response, {String? fallbackAuth}) {
    if (fallbackAuth != null &&
        (response.statusCode == 401 || response.statusCode == 403)) {
      return fallbackAuth;
    }
    try {
      final json = jsonDecode(response.body);
      final message = json['message'];
      if (message is String && message.isNotEmpty) return message;
    } catch (_) {}
    return 'Erro na requisição (${response.statusCode})';
  }
}