import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:projeto_mobile/config/token_config.dart';
import 'package:projeto_mobile/config/url_config.dart';
import 'package:projeto_mobile/models/book.dart';
import 'package:projeto_mobile/services/rating_service.dart';

class BookService {
  final _url = ApiConfig.baseUrl;
  final _ratingService = RatingService();

  Map<String, String> get _headers => {
        'Authorization': 'Bearer ${TokenConfig.token}',
        'Content-Type': 'application/json',
      };

  Future<List<Book>> fetchLivros() async {
    final response = await http.get(
      Uri.parse('$_url/api/books'),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      final List content = json is List ? json : (json['content'] ?? []);
      return content.map((e) => Book.fromJson(e)).toList();
    } else {
      throw Exception(_mensagemErro(response));
    }
  }

  Future<List<Book>> fetchLivrosComMedias() async {
    final livros = await fetchLivros();

    final medias = await Future.wait(
      livros.map((l) => _ratingService.fetchAverageRating(l.id).catchError((_) => 0.0)),
    );

    return List.generate(
      livros.length,
      (i) => livros[i].copyWith(rating: medias[i]),
    );
  }

  Future<Book> fetchLivroPorId(String id) async {
    final response = await http.get(
      Uri.parse('$_url/api/books/$id'),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      return Book.fromJson(jsonDecode(response.body));
    } else {
      throw Exception(_mensagemErro(response));
    }
  }

  Future<Book> criarLivro({
    required String titulo,
    required String autores,
    required String genero,
    required double preco,
    required String sinopse,
    required String isbn,
    required int paginas,
    required int ano,
  }) async {
    final response = await http.post(
      Uri.parse('$_url/api/books'),
      headers: _headers,
      body: jsonEncode({
        'title': titulo,
        'authors': [
          {'name': autores}
        ],
        'genre': genero,
        'price': preco,
        'synopsis': sinopse,
        'isbn': isbn,
        'pages': paginas,
        'year': ano,
      }),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      return Book.fromJson(jsonDecode(response.body));
    } else {
      throw Exception(_mensagemErro(response));
    }
  }

  Future<Book> editarLivro({
    required String id,
    required String titulo,
    required String autor,
    required String genero,
    required double preco,
    String? sinopse,
  }) async {
    final response = await http.put(
      Uri.parse('$_url/api/books/$id'),
      headers: _headers,
      body: jsonEncode({
        'title': titulo,
        'authors': [
          {'name': autor}
        ],
        'genre': genero,
        'price': preco,
        if (sinopse != null) 'synopsis': sinopse,
      }),
    );

    if (response.statusCode == 200) {
      return Book.fromJson(jsonDecode(response.body));
    } else {
      throw Exception(_mensagemErro(response));
    }
  }

  Future<void> excluirLivro(String id) async {
    final response = await http
        .delete(
          Uri.parse('$_url/api/books/$id'),
          headers: _headers,
        )
        .timeout(const Duration(seconds: 15));

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception(_mensagemErro(response));
    }
  }

  Future<List<Book>> fetchFavoritos() async {
    final response = await http.get(
      Uri.parse('$_url/api/books'),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      final List content = json is List ? json : (json['content'] ?? []);
      final livros = content.map((e) => Book.fromJson(e)).toList();
      return livros.where((l) => l.isFavorite).toList();
    } else {
      throw Exception(_mensagemErro(response));
    }
  }

  Future<List<Map<String, dynamic>>> fetchAutores() async {
    final response = await http.get(
      Uri.parse('$_url/api/author'),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      final List content = json is List ? json : (json['content'] ?? []);
      return content.cast<Map<String, dynamic>>();
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