import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:projeto_mobile/config/token_config.dart';
import 'package:projeto_mobile/config/url_config.dart';
import 'package:projeto_mobile/models/usuario.dart';

class UsuarioService {
  final url = ApiConfig.baseUrl;

  static final Map<String, String> _cache = {};

  Future<String> fetchNome(String userId) async {
    if (_cache.containsKey(userId)) return _cache[userId]!;

    final response = await http.get(
      Uri.parse('$url/api/users/$userId'),
      headers: {
        'Authorization': 'Bearer ${TokenConfig.token}',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      final nome = json['name']?.toString() ?? 'Usuário';
      _cache[userId] = nome;
      return nome;
    } else {
      return 'Usuário';
    }
  }

  Future<String> buscarPorId(String userId) => fetchNome(userId);

  Future<Usuario> atualizarUsuario({
    required String id,
    required String nome,
    required String email,
    required String currentPassword,
    String? newPassword,
  }) async {
    final response = await http.put(
      Uri.parse('$url/api/users/$id'),
      headers: {
        'Authorization': 'Bearer ${TokenConfig.token}',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'name': nome,
        'email': email,
        'currentPassword': currentPassword,
        'newPassword': newPassword ?? '',
      }),
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return Usuario.fromJson(json);
    } else {
      throw Exception(_mensagemErro(response));
    }
  }

  String _mensagemErro(http.Response response) {
    try {
      final json = jsonDecode(response.body);
      final message = json['message'];
      if (message is String && message.isNotEmpty) return message;
    } catch (_) {}
    return 'Erro na requisição (${response.statusCode})';
  }
}