import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:projeto_mobile/config/token_config.dart';
import 'package:projeto_mobile/config/url_config.dart';
import 'package:projeto_mobile/models/rating.dart';

class RatingService {
  final String url = ApiConfig.baseUrl;

  Map<String, String> get _headers => {
        'Authorization': 'Bearer ${TokenConfig.token}',
        'Content-Type': 'application/json',
      };

  Future<List<Rating>> fetchRatingsByBook(String bookId) async {
    final response = await http.get(
      Uri.parse('$url/api/ratings/all/$bookId'),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      final List content = json['content'] ?? [];
      return content.map((e) => Rating.fromJson(e)).toList();
    }

    throw Exception(_mensagemErro(response));
  }

  Future<double> fetchAverageRating(String bookId) async {
    final response = await http.get(
      Uri.parse('$url/api/ratings/average/$bookId'),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      return double.tryParse(response.body) ?? 0.0;
    }

    throw Exception(_mensagemErro(response));
  }

  Future<double> fetchAverage(String bookId) async {
    return fetchAverageRating(bookId);
  }

  Future<int> fetchCount(String bookId) async {
    final response = await http.get(
      Uri.parse('$url/api/ratings/all/$bookId'),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return json['totalElements'] ?? 0;
    }

    throw Exception(_mensagemErro(response));
  }

  Future<Rating> submitRating({
    required String bookId,
    required String userId,
    required int nota,
    required String comentario,
  }) async {
    final now = DateTime.now();
    final ratingDate =
        '${now.year.toString().padLeft(4, '0')}-'
        '${now.month.toString().padLeft(2, '0')}-'
        '${now.day.toString().padLeft(2, '0')}';

    final response = await http.post(
      Uri.parse('$url/api/ratings'),
      headers: _headers,
      body: jsonEncode({
        'user': {'id': userId},
        'book': {'idBook': bookId},
        'comment': comentario.trim(),
        'ratingValue': nota,
        'ratingDate': ratingDate,
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return Rating.fromJson(jsonDecode(response.body));
    }

    throw Exception(_mensagemErro(response));
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