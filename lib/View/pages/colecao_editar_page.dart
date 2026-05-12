import 'package:flutter/material.dart';
import 'package:projeto_mobile/config/app_colors.dart';
import 'package:projeto_mobile/models/livro_selecionavel.dart';
import 'package:projeto_mobile/View/widgets/bookly_appbar_widget.dart';
import 'package:projeto_mobile/View/widgets/bookly_text_field.dart';
import 'package:projeto_mobile/View/widgets/bookly_livro_row_widget.dart';
import 'package:projeto_mobile/View/widgets/colecao_form_widgets.dart';
import 'package:projeto_mobile/View/pages/colecao_home_page.dart';
import 'package:projeto_mobile/View/pages/colecoes_lista.dart';

class ColecaoEditarPage extends StatefulWidget {
  final String nomeInicial;
  final String descricaoInicial;

  const ColecaoEditarPage({
    super.key,
    this.nomeInicial = '',
    this.descricaoInicial = '',
  });

  @override
  State<ColecaoEditarPage> createState() => _ColecaoEditarPageState();
}

class _ColecaoEditarPageState extends State<ColecaoEditarPage> {
  late final TextEditingController _nomeController;
  late final TextEditingController _descricaoController;

  final List<LivroSelecionavel> _livros = [
    LivroSelecionavel(titulo: 'O Senhor dos Anéis', autor: 'J.R.R. Tolkien', cor: Color(0xFF7A5C3A)),
    LivroSelecionavel(titulo: 'Cem Anos de Solidão', autor: 'Gabriel García Márquez', cor: Color(0xFF4A7FA5)),
    LivroSelecionavel(titulo: '1984', autor: 'George Orwell', cor: Color(0xFF7A8C63)),
  ];

  bool get _podeSubmeter => _nomeController.text.trim().isNotEmpty;

  @override
  void initState() {
    super.initState();
    _nomeController = TextEditingController(text: widget.nomeInicial);
    _descricaoController = TextEditingController(text: widget.descricaoInicial);
    _nomeController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _descricaoController.dispose();
    super.dispose();
  }

  void _salvar() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const ColecaoHomePage()),
      (route) => route.isFirst,
    );
  }

  @override
  Widget build(BuildContext context) {
    final borderColor =
        Theme.of(context).colorScheme.tertiary.withValues(alpha: 0.15);
    final labelColor = Theme.of(context).colorScheme.tertiary;

    return Scaffold(
      appBar: BooklyAppBar(
        title: 'Editar Coleção',
        corDoTexto: AppColors.colecao,
        iconeMenu: false,
        iconeSeta: true,
        iconeCarrinho: false,
      ),
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            BooklyCardSection(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BooklySectionLabel(
                      texto: 'Detalhes da Coleção', cor: AppColors.colecao),
                  const SizedBox(height: 13),
                  BooklyTextField(
                    label: 'Nome da coleção *',
                    hintText: 'Ex: Minha estante de fantasia',
                    controller: _nomeController,
                  ),
                  const SizedBox(height: 13),
                  BooklyTextField(
                    label: 'Descrição (opcional)',
                    hintText: 'Fale um pouco sobre essa coleção…',
                    controller: _descricaoController,
                    maxLines: 3,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            BooklyCardSection(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BooklySectionLabel(
                      texto: 'Livros da Coleção', cor: AppColors.colecao),
                  const SizedBox(height: 12),
                  if (_livros.isEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Center(
                        child: Text(
                          'Nenhum livro nesta coleção',
                          style: TextStyle(fontSize: 13, color: labelColor),
                        ),
                      ),
                    )
                  else
                    ..._livros.asMap().entries.map((entry) {
                      final i = entry.key;
                      final livro = entry.value;
                      return Column(
                        children: [
                          BooklyLivroRow(
                            titulo: livro.titulo,
                            autor: livro.autor,
                            cor: livro.cor,
                            onRemover: () =>
                                setState(() => _livros.removeAt(i)),
                          ),
                          if (i < _livros.length - 1)
                            Divider(color: borderColor, height: 1),
                        ],
                      );
                    }),
                ],
              ),
            ),
            const SizedBox(height: 20),
            BooklyActionButton(
              label: 'Salvar alterações',
              onPressed: _podeSubmeter ? _salvar : null,
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              height: 43,
              child: OutlinedButton.icon(
                onPressed: () => Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const ColecoesListaPage()),
                  (route) => false,
                ),
                icon: const Icon(Icons.delete_outline,
                    size: 16, color: AppColors.danger),
                label: const Text(
                  'Excluir coleção',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColors.danger,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppColors.danger, width: 1.5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(99),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
