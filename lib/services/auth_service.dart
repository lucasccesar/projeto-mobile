import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:projeto_mobile/config/token_config.dart';
import 'package:projeto_mobile/config/url_config.dart';

class AuthService {
  final url = ApiConfig.baseUrl;

  /// Faz login no back (POST /api/auth/login), guarda o token da sessão
  /// e carrega os dados do usuário logado.
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

    TokenConfig.token = jsonDecode(response.body)['token'] as String;
    await _carregarUsuario();
  }

  /// Cria a conta (POST /api/auth/register) e já entra autenticado.
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

    // Cadastro OK: faz login para já entrar autenticado.
    await login(email, senha);
  }

  /// GET /api/users/me — preenche id/nome/email do usuário logado.
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
      TokenConfig.userId = json['id']?.toString();
      TokenConfig.userName = json['name'] as String?;
      TokenConfig.userEmail = json['email'] as String?;
    }
  }

  /// Extrai a mensagem do ExceptionResponseDTO ({message, statusCode, ...}).
  String _mensagemErro(http.Response response, {String? fallbackAuth}) {
    if (fallbackAuth != null &&
        (response.statusCode == 401 || response.statusCode == 403)) {
      return fallbackAuth;
    }
    try {
      final json = jsonDecode(response.body);
      final message = json['message'];
      if (message is String && message.isNotEmpty) return message;
    } catch (_) {
      // corpo não-JSON: cai no genérico
    }
    return 'Erro na requisição (${response.statusCode})';
  }
}
