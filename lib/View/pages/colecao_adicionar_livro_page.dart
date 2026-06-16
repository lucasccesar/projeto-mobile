import 'package:flutter/material.dart';
import 'package:projeto_mobile/View/widgets/appbar_widget.dart';
import 'package:projeto_mobile/View/widgets/colecao_form_widgets.dart';
import 'package:projeto_mobile/View/widgets/livro_row_widget.dart';
import 'package:projeto_mobile/View/widgets/text_field.dart';
import 'package:projeto_mobile/config/app_colors.dart';
import 'package:projeto_mobile/models/book.dart';
import 'package:projeto_mobile/models/colecao.dart';
import 'package:projeto_mobile/services/book_service.dart';
import 'package:projeto_mobile/services/colecao_service.dart';

class ColecaoAdicionarLivroPage extends StatefulWidget {
  final Colecao colecao;

  const ColecaoAdicionarLivroPage({
    super.key,
    required this.colecao,
  });

  @override
  State<ColecaoAdicionarLivroPage> createState() =>
      _ColecaoAdicionarLivroPageState();
}

class _ColecaoAdicionarLivroPageState extends State<ColecaoAdicionarLivroPage> {
  final _buscaController = TextEditingController();
  final _bookService = BookService();
  final _colecaoService = ColecaoService();

  final Set<String> _selecionados = {};
  bool _carregando = true;
  bool _salvando = false;
  String? _erro;
  List<Book> _livros = [];

  @override
  void initState() {
    super.initState();
    _buscaController.addListener(() => setState(() {}));
    _carregarLivros();
  }

  @override
  void dispose() {
    _buscaController.dispose();
    super.dispose();
  }

  Future<void> _carregarLivros() async {
    setState(() {
      _carregando = true;
      _erro = null;
    });

    try {
      final livros = await _bookService.fetchLivros();
      final idsDaColecao = widget.colecao.books.map((e) => e.id).toSet();

      final disponiveis = livros
          .where((livro) => !idsDaColecao.contains(livro.id))
          .toList();

      if (!mounted) return;

      setState(() {
        _livros = disponiveis;
        _carregando = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _erro = e.toString().replaceFirst('Exception: ', '');
        _carregando = false;
      });
    }
  }

  List<Book> get _livrosFiltrados {
    final query = _buscaController.text.trim().toLowerCase();
    if (query.isEmpty) return _livros;

    return _livros.where((livro) {
      return livro.title.toLowerCase().contains(query) ||
          livro.author.toLowerCase().contains(query) ||
          livro.genre.toLowerCase().contains(query);
    }).toList();
  }

  bool get _temSelecionados => _selecionados.isNotEmpty;

  Color _corDaCapa(Book livro, int index) {
    const cores = [
      Color(0xFF7B5EA7),
      Color(0xFF5E8A6E),
      Color(0xFF7A5C3A),
      Color(0xFF4A7FA5),
      Color(0xFF8B3A3A),
      Color(0xFFD17A22),
    ];
    final base = livro.id.isEmpty ? index : livro.id.codeUnits.fold(0, (a, b) => a + b);
    return cores[base % cores.length];
  }

  Future<void> _adicionarLivros() async {
    if (!_temSelecionados || _salvando) return;

    setState(() => _salvando = true);

    try {
      final livrosSelecionados = _livros
          .where((livro) => _selecionados.contains(livro.id))
          .toList();

      final colecaoAtualizada = await _colecaoService.adicionarLivros(
        colecao: widget.colecao,
        livrosParaAdicionar: livrosSelecionados,
      );

      if (!mounted) return;
      Navigator.pop(context, colecaoAtualizada);
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
    } finally {
      if (mounted) {
        setState(() => _salvando = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final borderColor =
        Theme.of(context).colorScheme.tertiary.withValues(alpha: 0.15);
    final filtrados = _livrosFiltrados;

    return Scaffold(
      appBar: BooklyAppBar(
        title: 'Adicionar Livro',
        corDoTexto: AppColors.colecao,
        iconeMenu: false,
        iconeSeta: true,
        iconeCarrinho: false,
      ),
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: CardSection(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SectionLabel(
                      texto: 'Adicionar Livros',
                      cor: AppColors.colecao,
                    ),
                    const SizedBox(height: 13),
                    BooklyTextField(
                      hintText: '🔍 Buscar livro…',
                      controller: _buscaController,
                    ),
                    const SizedBox(height: 12),
                    if (_carregando)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 24),
                        child: Center(
                          child: CircularProgressIndicator(
                            color: AppColors.colecao,
                          ),
                        ),
                      )
                    else if (_erro != null)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 24),
                        child: Center(
                          child: Column(
                            children: [
                              Text(
                                _erro!,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Theme.of(context).colorScheme.tertiary,
                                ),
                              ),
                              const SizedBox(height: 12),
                              TextButton(
                                onPressed: _carregarLivros,
                                child: const Text(
                                  'Tentar novamente',
                                  style: TextStyle(color: AppColors.colecao),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    else if (_livros.isEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 24),
                        child: Center(
                          child: Text(
                            'Todos os livros já estão na coleção',
                            style: TextStyle(
                              fontSize: 13,
                              color: Theme.of(context).colorScheme.tertiary,
                            ),
                          ),
                        ),
                      )
                    else if (filtrados.isEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 24),
                        child: Center(
                          child: Text(
                            'Nenhum livro encontrado',
                            style: TextStyle(
                              fontSize: 13,
                              color: Theme.of(context).colorScheme.tertiary,
                            ),
                          ),
                        ),
                      )
                    else
                      ...filtrados.asMap().entries.map((entry) {
                        final i = entry.key;
                        final livro = entry.value;
                        final selecionado = _selecionados.contains(livro.id);

                        return Column(
                          children: [
                            LivroRow(
                              titulo: livro.title,
                              autor: livro.author,
                              cor: _corDaCapa(livro, i),
                              selecionado: selecionado,
                              onToggle: () {
                                setState(() {
                                  if (selecionado) {
                                    _selecionados.remove(livro.id);
                                  } else {
                                    _selecionados.add(livro.id);
                                  }
                                });
                              },
                            ),
                            if (i < filtrados.length - 1)
                              Divider(color: borderColor, height: 1),
                          ],
                        );
                      }),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
            child: ActionButton(
              label: _salvando ? 'Adicionando...' : 'Adicionar à coleção',
              onPressed: _temSelecionados && !_salvando ? _adicionarLivros : null,
            ),
          ),
        ],
      ),
    );
  }
}