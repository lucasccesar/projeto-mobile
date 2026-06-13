// lib/services/book_club_assignment_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:projeto_mobile/config/url_config.dart';
import 'package:projeto_mobile/config/token_config.dart';

class BookClubAssignmentService {
  final url = ApiConfig.baseUrl;

  Future<String> fetchDateRange(String clubId) async {
    final response = await http.get(
      Uri.parse('$url/api/bookclubassignment/club/$clubId'),
      headers: {
        'Authorization': 'Bearer ${TokenConfig.token}',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      final content = json['content'] as List;

      if (content.isEmpty) return 'Sem data';

      // pega o primeiro assignment do clube
      final assignment = content.first;
      final start = assignment['startDate'];
      final finish = assignment['finishDate'];

      // formata para mes e dia
      return '${_formatDate(start)} - ${_formatDate(finish)}';
    } else {
      return 'Sem data';
    }
  }

  String _formatDate(String date) {
    final parts = date.split('-');
    return '${parts[2]}/${parts[1]}';
  }

  Future<Map<String, String>?> fetchAssignmentAtual(String clubId) async {
    final response = await http.get(
      Uri.parse('$url/api/bookclubassignment/club/$clubId'),
      headers: {
        'Authorization': 'Bearer ${TokenConfig.token}',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      final List content = json['content'];
      if (content.isEmpty) return null;

      // pega o assignment mais recente
      final assignment = content.first;
      return {
        'bookId': assignment['bookId'],
        'startDate': assignment['startDate'],
        'finishDate': assignment['finishDate'],
      };
    }
    return null;
  }

  Future<void> addBookToClub({
    required String clubId,
    required String bookId,
  }) async {
    final response = await http.post(
      Uri.parse('$url/api/bookclubassignment/club/$clubId/book/$bookId'),
      headers: {
        'Authorization': 'Bearer ${TokenConfig.token}',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode != 201) {
      throw Exception('Erro ao adicionar livro ao clube');
    }
  }

  Future<Set<String>> fetchBookIdsDoClube(String clubId) async {
    final response = await http.get(
      Uri.parse('$url/api/bookclubassignment/club/$clubId'),
      headers: {
        'Authorization': 'Bearer ${TokenConfig.token}',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      final List content = json['content'];
      return content.map<String>((a) => a['bookId'].toString()).toSet();
    }
    return {};
  }
}
