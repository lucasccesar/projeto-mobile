import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:projeto_mobile/config/token_config.dart';
import 'package:projeto_mobile/config/url_config.dart';
import 'package:projeto_mobile/models/clube_mensagem.dart';

class ClubeMensagemService {
  final url = ApiConfig.baseUrl;

  Future<List<ClubeMensagemModel>> fetchMensagens(String clubId) async {
    final response = await http.get(
      Uri.parse('$url/api/clubmessage/club/$clubId'),
      headers: {
        'Authorization': 'Bearer ${TokenConfig.token}',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      final List content = json['content'];
      return content.map((m) => ClubeMensagemModel.fromJson(m)).toList();
    } else {
      throw Exception('Erro ao buscar mensagens');
    }
  }

  Future<ClubeMensagemModel> enviarMensagem({
    required String clubId,
    required String userId,
    required String message,
  }) async {
    final response = await http.post(
      Uri.parse('$url/api/clubmessage'),
      headers: {
        'Authorization': 'Bearer ${TokenConfig.token}',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'message': message,
        'user': {'id': userId},
        'club': {'idBookClub': clubId},
      }),
    );

    if (response.statusCode == 201) {
      final json = jsonDecode(response.body);
      return ClubeMensagemModel.fromJson(json);
    } else {
      print('STATUS ENVIO: ${response.statusCode}');
      print('BODY ENVIO: ${response.body}');
      throw Exception('Erro ao enviar mensagem');
    }
  }
}
