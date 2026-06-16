import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:projeto_mobile/config/token_config.dart';
import 'package:projeto_mobile/config/url_config.dart';
import 'package:projeto_mobile/models/reading_status.dart';

class ReadingStatusService {
  final _url = ApiConfig.baseUrl;

  Map<String, String> get _headers => {
    'Authorization': 'Bearer ${TokenConfig.token}',
    'Content-Type': 'application/json',
  };

  Future<List<ReadingStatus>> fetchStatusesByUser(String userId) async {
    final response = await http.get(
      Uri.parse('$_url/api/readingstatus/idUser/$userId'),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      final List content = json['content'] ?? [];
      return content.map((e) => ReadingStatus.fromJson(e)).toList();
    } else {
      throw Exception(_mensagemErro(response));
    }
  }

  Future<ReadingStatus?> fetchStatusByBookAndUser(
    String bookId,
    String userId,
  ) async {
    final response = await http.get(
      Uri.parse(
        '$_url/api/readingstatus/byBookAndUser?bookId=$bookId&userId=$userId',
      ),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      if (response.body.trim().isEmpty || response.body.trim() == 'null') {
        return null;
      }

      final json = jsonDecode(response.body);
      if (json == null) return null;

      return ReadingStatus.fromJson(json);
    } else {
      throw Exception(_mensagemErro(response));
    }
  }

  Future<ReadingStatus> createStatus({
    required String bookId,
    required String userId,
    required String status,
  }) async {
    final response = await http.post(
      Uri.parse('$_url/api/readingstatus'),
      headers: _headers,
      body: jsonEncode({
        'users': {'id': userId},
        'book': {'idBook': bookId},
        'status': status,
      }),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      return ReadingStatus.fromJson(jsonDecode(response.body));
    } else {
      throw Exception(_mensagemErro(response));
    }
  }

  Future<ReadingStatus> updateStatus({
    required String statusId,
    required String bookId,
    required String userId,
    required String status,
  }) async {
    final response = await http.put(
      Uri.parse('$_url/api/readingstatus/$statusId'),
      headers: _headers,
      body: jsonEncode({
        'users': {'id': userId},
        'book': {'idBook': bookId},
        'status': status,
      }),
    );

    if (response.statusCode == 200) {
      return ReadingStatus.fromJson(jsonDecode(response.body));
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

  Future<void> deleteStatus(String statusId) async {
    final response = await http.delete(
      Uri.parse('$_url/api/readingstatus/$statusId'),
      headers: _headers,
    );

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception(_mensagemErro(response));
    }
  }
}
