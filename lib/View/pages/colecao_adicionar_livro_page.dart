import 'package:flutter/material.dart';
import 'package:projeto_mobile/config/app_colors.dart';
import 'package:projeto_mobile/models/livro_selecionavel.dart';
import 'package:projeto_mobile/View/widgets/appbar_widget.dart';
import 'package:projeto_mobile/View/widgets/text_field.dart';
import 'package:projeto_mobile/View/widgets/livro_row_widget.dart';
import 'package:projeto_mobile/View/widgets/colecao_form_widgets.dart';

class ColecaoAdicionarLivroPage extends StatefulWidget {
  const ColecaoAdicionarLivroPage({super.key});

  @override
  State<ColecaoAdicionarLivroPage> createState() =>
      _ColecaoAdicionarLivroPageState();
}

class _ColecaoAdicionarLivroPageState
    extends State<ColecaoAdicionarLivroPage> {
  final _buscaController = TextEditingController();

  final List<LivroSelecionavel> _livros = [
    LivroSelecionavel(titulo: 'O Nome do Vento', autor: 'Patrick Rothfuss', cor: Color(0xFF7B5EA7)),
    LivroSelecionavel(titulo: 'A Roda do Tempo', autor: 'Robert Jordan', cor: Color(0xFF5E8A6E)),
    LivroSelecionavel(titulo: 'Fundação', autor: 'Isaac Asimov', cor: Color(0xFF7A5C3A)),
    LivroSelecionavel(titulo: 'Neuromancer', autor: 'William Gibson', cor: Color(0xFF4A7FA5)),
    LivroSelecionavel(titulo: 'Drácula', autor: 'Bram Stoker', cor: Color(0xFF8B3A3A)),
  ];

  List<LivroSelecionavel> get _livrosFiltrados {
    final query = _buscaController.text.trim().toLowerCase();
    if (query.isEmpty) return _livros;
    return _livros
        .where((l) =>
            l.titulo.toLowerCase().contains(query) ||
            l.autor.toLowerCase().contains(query))
        .toList();
  }

  bool get _temSelecionados => _livros.any((l) => l.selecionado);

  @override
  void initState() {
    super.initState();
    _buscaController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _buscaController.dispose();
    super.dispose();
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
                        texto: 'Adicionar Livros', cor: AppColors.colecao),
                    const SizedBox(height: 13),
                    BooklyTextField(
                      hintText: '🔍 Buscar livro…',
                      controller: _buscaController,
                    ),
                    const SizedBox(height: 12),
                    if (filtrados.isEmpty)
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
                        return Column(
                          children: [
                            LivroRow(
                              titulo: livro.titulo,
                              autor: livro.autor,
                              cor: livro.cor,
                              selecionado: livro.selecionado,
                              onToggle: () => setState(
                                  () => livro.selecionado = !livro.selecionado),
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
              label: 'Adicionar à coleção',
              onPressed: _temSelecionados ? () => Navigator.pop(context) : null,
            ),
          ),
        ],
      ),
    );
  }
}
