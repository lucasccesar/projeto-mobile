import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:projeto_mobile/config/token_config.dart';
import 'package:projeto_mobile/config/url_config.dart';
import 'package:projeto_mobile/models/usuario.dart';

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
    TokenConfig.token = json['token']?.toString() ?? '';
    TokenConfig.userRole = _extrairRoleDoToken(TokenConfig.token);

    await _carregarUsuario();
  }

  Future<void> cadastrar({
    required String nome,
    required String email,
    required String senha,
    required DateTime nascimento,
    String? adminCode,
  }) async {
    final birthday =
        '${nascimento.year.toString().padLeft(4, '0')}-'
        '${nascimento.month.toString().padLeft(2, '0')}-'
        '${nascimento.day.toString().padLeft(2, '0')}';

    final response = await http.post(
      Uri.parse('$url/api/auth/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': nome,
        'email': email,
        'password': senha,
        'birthday': birthday,
        // O back decide o tipo: adminCode == "admin123" → ADMIN, senão CLIENT.
        if (adminCode != null && adminCode.isNotEmpty) 'adminCode': adminCode,
      }),
    );

    if (response.statusCode != 201) {
      throw Exception(_mensagemErro(response));
    }

    await login(email, senha);
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
      // Mantém o fallback de `authorities` (não coberto por Usuario.fromJson) e
      // a role do JWT caso o back não envie o tipo em /me.
      TokenConfig.userRole =
          TokenConfig.usuario?.tipo ??
          json['authorities']?.toString() ??
          TokenConfig.userRole;
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