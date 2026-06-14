import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:projeto_mobile/config/token_config.dart';
import 'package:projeto_mobile/config/url_config.dart';

class RatingService {
  final url = ApiConfig.baseUrl;

  Future<double> fetchAverage(String bookId) async {
    final response = await http.get(
      Uri.parse('$url/api/ratings/average/$bookId'),
      headers: {
        'Authorization': 'Bearer ${TokenConfig.token}',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return double.tryParse(response.body) ?? 0.0;
    }
    return 0.0;
  }

  Future<int> fetchCount(String bookId) async {
    final response = await http.get(
      Uri.parse('$url/api/ratings/all/$bookId'),
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