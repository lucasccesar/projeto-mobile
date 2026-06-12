import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:projeto_mobile/config/token_config.dart';
import 'package:projeto_mobile/config/url_config.dart';

class UsuarioService {
  final url = ApiConfig.baseUrl;

  Future<String> fetchNome(String userId) async {
    final response = await http.get(
      Uri.parse('$url/api/users/$userId'),
      headers: {
        'Authorization': 'Bearer ${TokenConfig.token}',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return json['name'] ?? 'Usuário';
    } else {
      return 'Usuário';
    }
  }
}