import 'package:flutter/material.dart';
import 'package:projeto_mobile/config/app_colors.dart';
import 'package:projeto_mobile/models/colecao.dart';
import 'package:projeto_mobile/services/colecao_service.dart';
import 'package:projeto_mobile/View/widgets/appbar_widget.dart';
import 'package:projeto_mobile/View/widgets/search_bar.dart';
import 'package:projeto_mobile/View/widgets/sidebar_widget.dart';
import 'package:projeto_mobile/View/widgets/colecao_item_widget.dart';
import 'package:projeto_mobile/View/widgets/rodape_widget.dart';
import 'package:projeto_mobile/View/pages/colecao_editar_page.dart';
import 'package:projeto_mobile/View/pages/colecao_adicionar_livro_page.dart';

class ColecaoHomePage extends StatefulWidget {
  final Colecao colecao;

  const ColecaoHomePage({
    super.key,
    required this.colecao,
  });

  @override
  State<ColecaoHomePage> createState() => _ColecaoHomePageState();
}

class _ColecaoHomePageState extends State<ColecaoHomePage> {
  final _buscaController = TextEditingController();
  final _colecaoService = ColecaoService();
  late Colecao _colecao;

  @override
  void initState() {
    super.initState();
    _colecao = widget.colecao;
    _buscaController.addListener(() => setState(() {}));
  }

  List<dynamic> get _livrosFiltrados {
    final query = _buscaController.text.trim().toLowerCase();

    if (query.isEmpty) return _colecao.books;

    return _colecao.books.where((livro) {
      return livro.title.toLowerCase().contains(query) ||
          livro.author.toLowerCase().contains(query) ||
          livro.genre.toLowerCase().contains(query);
    }).toList();
  }

  Future<void> _removerLivro(String livroId, String titulo) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Remover livro'),
        content: Text('Deseja remover "$titulo" desta coleção?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              'Remover',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );

    if (confirmar != true) return;

    try {
      final colecaoAtualizada = await _colecaoService.removerLivro(
        colecao: _colecao,
        livroId: livroId,
      );

      if (!mounted) return;

      setState(() {
        _colecao = colecaoAtualizada;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('"$titulo" removido da coleção'),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString().replaceFirst('Exception: ', '')),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    }
  }

  @override
  void dispose() {
    _buscaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const SidebarWidget(),
      appBar: BooklyAppBar(
        title: _colecao.name,
        corDoTexto: AppColors.colecao,
        iconeMenu: false,
        iconeSeta: true,
        iconeCarrinho: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: BooklySearchBar(
                    hintText: 'Título, autor ou gênero...',
                    controller: _buscaController,
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton.icon(
                  onPressed: () async {
                    final colecaoAtualizada = await Navigator.push<Colecao>(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ColecaoAdicionarLivroPage(
                          colecao: _colecao,
                        ),
                      ),
                    );

                    if (colecaoAtualizada != null && mounted) {
                      setState(() {
                        _colecao = colecaoAtualizada;
                      });
                    }
                  },
                  icon: const Icon(Icons.add, size: 12),
                  label: const Text('Adicionar'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.colecao,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 10,
                    ),
                    textStyle: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(99),
                    ),
                    elevation: 2,
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton.icon(
                  onPressed: () async {
                    final colecaoAtualizada = await Navigator.push<Colecao>(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ColecaoEditarPage(
                          colecao: _colecao,
                        ),
                      ),
                    );

                    if (colecaoAtualizada != null && mounted) {
                      setState(() {
                        _colecao = colecaoAtualizada;
                      });
                    }
                  },
                  icon: const Icon(Icons.edit, size: 12),
                  label: const Text('Editar'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.colecao,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 10,
                    ),
                    textStyle: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(99),
                    ),
                    elevation: 2,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: _livrosFiltrados.isEmpty
                  ? const Center(
                      child: Text(
                        'Nenhum livro encontrado',
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF888888),
                        ),
                      ),
                    )
                  : ListView(
                      children: _livrosFiltrados.map((livro) {
                        return ColecaoItemWidget(
                          titulo: livro.title,
                          autor: livro.author,
                          genero: livro.genre,
                          avaliacao: livro.rating,
                          preco:
                              'R\$${livro.price.toStringAsFixed(2).replaceAll('.', ',')}',
                          onTap: () {},
                          onRemover: () => _removerLivro(livro.id, livro.title),
                        );
                      }).toList(),
                    ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const Rodape(),
    );
  }
}