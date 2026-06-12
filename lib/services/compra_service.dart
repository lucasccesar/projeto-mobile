import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:projeto_mobile/config/token_config.dart';
import 'package:projeto_mobile/config/url_config.dart';
import 'package:projeto_mobile/models/book.dart';
import 'package:projeto_mobile/models/carrinho_item.dart';
import 'package:projeto_mobile/models/pedido.dart';

class CompraService {
  final url = ApiConfig.baseUrl;

  Map<String, String> get _headers => {
        'Authorization': 'Bearer ${TokenConfig.token}',
        'Content-Type': 'application/json',
      };

  /// Cria a compra (POST /api/purchase). O back define a purchaseDate.
  Future<void> criarCompra(List<CarrinhoItem> itens) async {
    final total = itens.fold<double>(0, (s, i) => s + i.subtotal);

    final response = await http.post(
      Uri.parse('$url/api/purchase'),
      headers: _headers,
      body: jsonEncode({
        'idUser': TokenConfig.userId,
        'totalValuation': total,
        'books': itens
            .map((i) => {
                  'idBook': i.livro.id,
                  'quantity': i.quantidade,
                  'unitPrice': i.livro.price,
                })
            .toList(),
      }),
    );

    if (response.statusCode != 201) {
      throw Exception(_mensagemErro(response));
    }
  }

  /// Busca o histórico de compras do usuário logado
  /// (GET /api/purchase/PageId/{userId}).
  Future<List<Pedido>> buscarHistorico() async {
    final response = await http.get(
      Uri.parse(
        '$url/api/purchase/PageId/${TokenConfig.userId}?sort=purchaseDate,desc',
      ),
      headers: _headers,
    );

    // Usuário sem nenhuma compra → o back responde 400 (não página vazia).
    if (response.statusCode == 400) {
      return [];
    }
    if (response.statusCode != 200) {
      throw Exception(_mensagemErro(response));
    }

    final json = jsonDecode(response.body);
    final List content = json['content'] ?? [];

    // Cache para não buscar o mesmo livro várias vezes.
    final cacheLivros = <String, Book>{};
    final pedidos = <Pedido>[];

    for (final compra in content) {
      final books = (compra['books'] as List?) ?? [];
      final livros = <Book>[];

      for (final pb in books) {
        final idBook = pb['idBook']?.toString();
        if (idBook == null) continue;
        final quantidade = (pb['quantity'] as num?)?.toInt() ?? 1;
        final livro = await _buscarLivro(idBook, cacheLivros);
        if (livro == null) continue;
        // Repete o livro conforme a quantidade comprada.
        for (var i = 0; i < quantidade; i++) {
          livros.add(livro);
        }
      }

      // O response não tem id no nível raiz → usa o idPurchase do primeiro item.
      final idPedido =
          books.isNotEmpty ? (books.first['idPurchase']?.toString() ?? '') : '';

      pedidos.add(
        Pedido(
          id: idPedido,
          data: DateTime.tryParse(compra['purchaseDate']?.toString() ?? '') ??
              DateTime.now(),
          livros: livros,
          status: 'Concluído',
          total: (compra['totalValuation'] as num?)?.toDouble(),
        ),
      );
    }

    return pedidos;
  }

  /// Busca os dados de um livro (GET /api/books/{id}), com cache.
  Future<Book?> _buscarLivro(String id, Map<String, Book> cache) async {
    if (cache.containsKey(id)) return cache[id];

    final response = await http.get(
      Uri.parse('$url/api/books/$id'),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      final livro = Book.fromJson(jsonDecode(response.body));
      cache[id] = livro;
      return livro;
    }
    return null;
  }

  String _mensagemErro(http.Response response) {
    try {
      final json = jsonDecode(response.body);
      final message = json['message'];
      if (message is String && message.isNotEmpty) return message;
    } catch (_) {
      // corpo não-JSON
    }
    return 'Erro na requisição (${response.statusCode})';
  }
}
