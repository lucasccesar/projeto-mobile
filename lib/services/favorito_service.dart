import 'package:projeto_mobile/models/book.dart';
import 'package:projeto_mobile/models/colecao.dart';
import 'package:projeto_mobile/services/colecao_service.dart';

class FavoritoService {
  final ColecaoService _colecaoService = ColecaoService();

  static const String _nomeFavoritos = 'Favoritos';

  Future<Colecao?> _buscarColecaoFavoritos() async {
    final colecoes = await _colecaoService.buscarPorUsuario();
    try {
      return colecoes.firstWhere((c) => c.name == _nomeFavoritos);
    } catch (_) {
      return null;
    }
  }

  Future<bool> isFavoritado(String bookId) async {
    final colecao = await _buscarColecaoFavoritos();
    if (colecao == null) return false;
    return colecao.books.any((b) => b.id == bookId);
  }

  Future<bool> favoritar(Book livro) async {
    Colecao? colecao = await _buscarColecaoFavoritos();

    if (colecao == null) {
      colecao = await _colecaoService.criar(
        nome: _nomeFavoritos,
        descricao: 'Meus livros favoritos',
      );
    }

    await _colecaoService.adicionarLivros(
      colecao: colecao,
      livrosParaAdicionar: [livro],
    );
    return true;
  }

  Future<bool> desfavoritar(Book livro) async {
    final colecao = await _buscarColecaoFavoritos();
    if (colecao == null) return false;

    await _colecaoService.removerLivro(
      colecao: colecao,
      livroId: livro.id,
    );
    return false;
  }
}