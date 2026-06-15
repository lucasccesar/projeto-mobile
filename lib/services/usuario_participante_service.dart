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

  Future<void> entrarNoClube({
    required String userId,
    required String clubId,
  }) async {
    final response = await http.post(
      Uri.parse('$url/api/participantuser'),
      headers: {
        'Authorization': 'Bearer ${TokenConfig.token}',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'user': {'id': userId},
        'club': {'idBookClub': clubId},
        'entryDate': '',
      }),
    );

    if (response.statusCode != 201) {
      throw Exception('Erro ao entrar no clube');
    }
  }

  Future<bool> usuarioEhParticipante({
    required String clubId,
    required String userId,
  }) async {
    final response = await http.get(
      Uri.parse('$url/api/participantuser/byclub/$clubId'),
      headers: {
        'Authorization': 'Bearer ${TokenConfig.token}',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      final List content = json['content'];
      return content.any((p) => p['userId'] == userId);
    }
    return false;
  }

  Future<List<Map<String, String>>> fetchParticipantes(String clubId) async {
    final response = await http.get(
      Uri.parse('$url/api/participantuser/byclub/$clubId'),
      headers: {
        'Authorization': 'Bearer ${TokenConfig.token}',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      final List content = json['content'];
      return content
          .map<Map<String, String>>(
            (p) => {
              'idParticipantUser': p['idParticipantUser'].toString(),
              'userId': p['userId'].toString(),
            },
          )
          .toList();
    }
    return [];
  }

  Future<void> removerParticipante(String idParticipantUser) async {
    final response = await http.delete(
      Uri.parse('$url/api/participantuser/$idParticipantUser'),
      headers: {
        'Authorization': 'Bearer ${TokenConfig.token}',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Erro ao remover participante');
    }
  }

  Future<int> fetchClubCountByUser(String userId) async {
    final response = await http.get(
      Uri.parse('$url/api/participantuser/byuser/$userId'),
      headers: {
        'Authorization': 'Bearer ${TokenConfig.token}',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return json['totalElements'] ?? 0;
    }
    return 0;
  }
}
