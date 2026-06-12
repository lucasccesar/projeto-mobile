import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:projeto_mobile/config/token_config.dart';
import 'package:projeto_mobile/config/url_config.dart';
import 'package:projeto_mobile/models/clube_do_livro.dart';
import 'package:projeto_mobile/services/clube_assignment.dart';
import 'package:projeto_mobile/services/usuario_participante_service.dart';

class ClubeDoLivroService {
  final url = ApiConfig.baseUrl;
  final participantUserService = ParticipantUserService();
  final bookClubAssignmentService = BookClubAssignmentService();

  Future<List<ClubeDoLivro>> fetchClubesDoLivro() async {
    final response = await http.get(
      Uri.parse('$url/api/bookclub'),
      headers: {
        'Authorization': 'Bearer ${TokenConfig.token}',
        'Content-Type': 'application/json',
      },
    );

    // print('STATUS: ${response.statusCode}');
    // print('BODY: ${response.body}');

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      final List content = jsonResponse['content'];

      final clubes = content
          .map((clubedolivro) => ClubeDoLivro.fromJson(clubedolivro))
          .toList();

      await Future.wait(
        clubes.map((clube) async {
          clube.participantes = await participantUserService
              .fetchParticipantCount(clube.id);
          clube.datas = await bookClubAssignmentService.fetchDateRange(
            clube.id,
          );
        }),
      );

      return clubes;
    } else {
      throw Exception(
        'Erro ao buscar clubes do livro',
      ); // + response.statusCode.toString());
    }
  }

  
  Future<ClubeDoLivro> criarClube({
  required String nome,
  required String tema,
  required String descricao,
  required String creatorId,
  required String frequency,
}) async {
  final response = await http.post(
    Uri.parse('$url/api/bookclub'),
    headers: {
      'Authorization': 'Bearer ${TokenConfig.token}',
      'Content-Type': 'application/json',
    },
    body: jsonEncode({
      'name': nome,
      'theme': tema,
      'description': descricao,
      'frequency': frequency,
      'creator': {'id': creatorId},
    }),
  );

  if (response.statusCode == 201) {
    final json = jsonDecode(response.body);
    //print('RETORNO CRIAR CLUBE: $json'); 
    return ClubeDoLivro.fromJson(json);  
  } else {
    throw Exception('Erro ao criar clube — status: ${response.statusCode}');
  }
}
}
