import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:projeto_mobile/config/token_config.dart';
import 'package:projeto_mobile/config/url_config.dart';
import 'package:projeto_mobile/models/book.dart';
import 'package:projeto_mobile/models/colecao.dart';

class ColecaoService {
  final _url = ApiConfig.baseUrl;

  Map<String, String> get _headers => {
    'Authorization': 'Bearer ${TokenConfig.token}',
    'Content-Type': 'application/json',
  };

  Future<List<Colecao>> buscarPorUsuario() async {
    final userId = TokenConfig.userId;
    final response = await http.get(
      Uri.parse('$_url/api/colection/user/$userId'),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      final List content = json['content'] ?? [];
      return content
          .map((e) => Colecao.fromJson(e as Map<String, dynamic>))
          .toList();
    }

    if (response.statusCode == 404) return [];
    throw Exception(_mensagemErro(response));
  }

  Future<Colecao> buscarPorId(String id) async {
    final response = await http.get(
      Uri.parse('$_url/api/colection/$id'),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      return Colecao.fromJson(
        jsonDecode(response.body) as Map<String, dynamic>,
      );
    }

    throw Exception(_mensagemErro(response));
  }

  Future<Colecao> criar({
    required String nome,
    required String descricao,
  }) async {
    final response = await http.post(
      Uri.parse('$_url/api/colection'),
      headers: _headers,
      body: jsonEncode({
        'name': nome,
        'description': descricao,
        'userId': TokenConfig.userId,
      }),
    );

    if (response.statusCode == 201) {
      return Colecao.fromJson(
        jsonDecode(response.body) as Map<String, dynamic>,
      );
    }

    throw Exception(_mensagemErro(response));
  }

  Future<Colecao> atualizar({
    required String id,
    required String nome,
    required String descricao,
    List<Book> books = const [],
  }) async {
    final response = await http.put(
      Uri.parse('$_url/api/colection/$id'),
      headers: _headers,
      body: jsonEncode({
        'name': nome,
        'description': descricao,
        'books': books.map((book) => {'idBook': book.id}).toList(),
      }),
    );

    if (response.statusCode == 200) {
      return Colecao.fromJson(
        jsonDecode(response.body) as Map<String, dynamic>,
      );
    }

    throw Exception(_mensagemErro(response));
  }

  Future<Colecao> adicionarLivros({
    required Colecao colecao,
    required List<Book> livrosParaAdicionar,
  }) async {
    final existentes = colecao.books;
    final mapa = <String, Book>{
      for (final livro in existentes) livro.id: livro,
    };

    for (final livro in livrosParaAdicionar) {
      mapa[livro.id] = livro;
    }

    return atualizar(
      id: colecao.id,
      nome: colecao.name,
      descricao: colecao.description,
      books: mapa.values.toList(),
    );
  }

  Future<Colecao> removerLivro({
    required Colecao colecao,
    required String livroId,
  }) async {
    final livrosAtualizados = colecao.books
        .where((livro) => livro.id != livroId)
        .toList();

    return atualizar(
      id: colecao.id,
      nome: colecao.name,
      descricao: colecao.description,
      books: livrosAtualizados,
    );
  }

  Future<void> deletar(String id) async {
    final response = await http.delete(
      Uri.parse('$_url/api/colection/$id'),
      headers: _headers,
    );

    if (response.statusCode != 204) {
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
