import 'package:projeto_mobile/config/token_config.dart';
import 'package:flutter/material.dart';
import 'package:projeto_mobile/config/app_colors.dart';
import 'package:projeto_mobile/models/book.dart';
import 'package:projeto_mobile/services/book_service.dart';
import 'package:projeto_mobile/View/widgets/appbar_widget.dart';
import 'package:projeto_mobile/View/widgets/livro_card_widget.dart';
import 'package:projeto_mobile/View/widgets/rodape_widget.dart';
import 'package:projeto_mobile/View/widgets/sidebar_widget.dart';
import 'package:projeto_mobile/View/widgets/search_bar.dart';
import 'package:projeto_mobile/View/pages/adicionar_livro_page.dart';
import 'package:projeto_mobile/View/pages/carrinho_page.dart';
import 'package:projeto_mobile/View/pages/book_page.dart';
import 'package:projeto_mobile/View/pages/editar_livro_page.dart';
import 'package:projeto_mobile/View/widgets/theme_toggle_button.dart';

class CatalogoPage extends StatefulWidget {
  const CatalogoPage({super.key});

  @override
  State<CatalogoPage> createState() => _CatalogoPageState();
}

class _CatalogoPageState extends State<CatalogoPage> {
  final _searchController = TextEditingController();
  final _bookService = BookService();

  List<Book> _livros = [];
  final _carrinho = <Book>[];
  bool _carregando = true;
  String? _erro;

  @override
  void initState() {
    super.initState();
    _carregarLivros();
  }

  Future<void> _carregarLivros() async {
    setState(() {
      _carregando = true;
      _erro = null;
    });
    try {
      final livros = await _bookService.fetchLivros();
      setState(() => _livros = livros);
    } catch (e) {
      setState(() => _erro = e.toString());
    } finally {
      setState(() => _carregando = false);
    }
  }

  void _adicionarAoCarrinho(Book livro) {
    if (!_carrinho.any((b) => b.id == livro.id)) {
      setState(() => _carrinho.add(livro));
    }
  }

  List<Book> get _livrosFiltrados {
    final query = _searchController.text.toLowerCase();
    if (query.isEmpty) return _livros;
    return _livros
        .where(
          (l) =>
              l.title.toLowerCase().contains(query) ||
              l.author.toLowerCase().contains(query) ||
              l.genre.toLowerCase().contains(query),
        )
        .toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _navegarParaAdicionar() async {
    final livro = await Navigator.push<Book>(
      context,
      MaterialPageRoute(builder: (_) => const AdicionarLivroPage()),
    );
    if (livro != null) {
      setState(() => _livros.add(livro));
    }
  }

  @override
  Widget build(BuildContext context) {
    print('userRole: ${TokenConfig.userRole}');
    print('isAdmin: ${TokenConfig.isAdmin}');
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      drawer: SidebarWidget(carrinho: _carrinho),
      appBar: BooklyAppBar(
        title: 'Catálogo',
        corDoTexto: AppColors.catalogo,
        iconeMenu: true,
        iconeSeta: false,
        iconeCarrinho: true,
        onCarrinhoTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => CarrinhoPage(itens: _carrinho)),
        ),
        extraActions: const [ThemeToggleButton()],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Row(
              children: [
                Expanded(
                  child: BooklySearchBar(
                    controller: _searchController,
                    hintText: 'Título, autor ou gênero...',
                    onChanged: (_) => setState(() {}),
                    fillColor: Colors.white,
                    focusedBorderColor: AppColors.catalogo.withValues(
                      alpha: 0.5,
                    ),
                    focusedBorderWidth: 1.5,
                    showEnabledBorder: false,
                  ),
                ),
                if (TokenConfig.isAdmin) ...[
                  const SizedBox(width: 10),
                  ElevatedButton.icon(
                    onPressed: _navegarParaAdicionar,
                    icon: const Icon(Icons.add, size: 18),
                    label: const Text('Adicionar'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.catalogo,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 12,
                      ),
                      textStyle: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          Expanded(child: _buildBody()),
        ],
      ),
      bottomNavigationBar: const Rodape(selectedTab: NavTab.catalogo),
    );
  }

  Widget _buildBody() {
    if (_carregando) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_erro != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Color(0xFF8B7355)),
            const SizedBox(height: 12),
            const Text(
              'Erro ao carregar livros',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Color(0xFF5A4631),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _carregarLivros,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.catalogo,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: const Text('Tentar novamente'),
            ),
          ],
        ),
      );
    }
    if (_livrosFiltrados.isEmpty) {
      return const Center(
        child: Text(
          'Nenhum livro encontrado.',
          style: TextStyle(fontSize: 14, color: Color(0xFF8B7355)),
        ),
      );
    }
    return RefreshIndicator(
      onRefresh: _carregarLivros,
      color: AppColors.catalogo,
      child: ListView.builder(
        padding: const EdgeInsets.only(top: 4, bottom: 12),
        itemCount: _livrosFiltrados.length,
        itemBuilder: (context, index) {
          final livro = _livrosFiltrados[index];
          return LivroCardWidget(
            livro: livro,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => BookPage(
                  livro: livro,
                  onAdicionarAoCarrinho: _adicionarAoCarrinho,
                ),
              ),
            ),
            onLongPress: TokenConfig.isAdmin
                ? () async {
                    final atualizado = await Navigator.push<dynamic>(
                      context,
                      MaterialPageRoute(
                        builder: (_) => EditarLivroPage(livro: livro),
                      ),
                    );

                    if (atualizado == 'deleted') {
                      setState(() {
                        _livros.removeWhere((b) => b.id == livro.id);
                      });
                      return;
                    }

                    if (atualizado is Book) {
                      setState(() {
                        final indexOriginal = _livros.indexWhere(
                          (b) => b.id == atualizado.id,
                        );
                        if (indexOriginal != -1) {
                          _livros[indexOriginal] = atualizado;
                        }
                      });
                    }
                  }
                : null,
          );
        },
      ),
    );
  }
}
