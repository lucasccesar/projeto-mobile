import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:projeto_mobile/config/url_config.dart';
import 'package:projeto_mobile/config/token_config.dart';

class ParticipantUserService {
  final url = ApiConfig.baseUrl;

  Future<int> fetchParticipantCount(String clubId) async {
    final response = await http.get(
      Uri.parse('$url/api/participantuser/byclub/$clubId'),
      headers: {
        'Authorization': 'Bearer ${TokenConfig.token}',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return json['totalElements'] as int;
    } else {
      throw Exception('Erro ao buscar usuários participantes');
    }
  }
}