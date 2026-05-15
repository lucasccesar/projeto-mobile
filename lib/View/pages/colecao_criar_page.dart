import 'package:flutter/material.dart';
import 'package:projeto_mobile/config/app_colors.dart';
import 'package:projeto_mobile/models/livro_selecionavel.dart';
import 'package:projeto_mobile/View/widgets/appbar_widget.dart';
import 'package:projeto_mobile/View/widgets/text_field.dart';
import 'package:projeto_mobile/View/widgets/livro_row_widget.dart';
import 'package:projeto_mobile/View/widgets/colecao_form_widgets.dart';

class ColecaoCriarPage extends StatefulWidget {
  const ColecaoCriarPage({super.key});

  @override
  State<ColecaoCriarPage> createState() => _ColecaoCriarPageState();
}

class _ColecaoCriarPageState extends State<ColecaoCriarPage> {
  final _nomeController = TextEditingController();
  final _descricaoController = TextEditingController();
  final _buscaController = TextEditingController();

  final List<LivroSelecionavel> _livros = [
    LivroSelecionavel(titulo: 'O Senhor dos Anéis', autor: 'J.R.R. Tolkien', cor: Color(0xFF7A5C3A)),
    LivroSelecionavel(titulo: 'Harry Potter', autor: 'J.K. Rowling', cor: Color(0xFF4A7FA5)),
    LivroSelecionavel(titulo: 'Duna', autor: 'Frank Herbert', cor: Color(0xFF7A8C63)),
  ];

  bool get _podeSubmeter => _nomeController.text.trim().isNotEmpty;

  @override
  void initState() {
    super.initState();
    _nomeController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _descricaoController.dispose();
    _buscaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BooklyAppBar(
        title: 'Criar Coleção',
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
            CardSection(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SectionLabel(texto: 'Detalhes', cor: AppColors.colecao),
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
            CardSection(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SectionLabel(
                      texto: 'Adicionar livros', cor: AppColors.colecao),
                  const SizedBox(height: 10),
                  BooklyTextField(
                    hintText: '🔍 Buscar livro…',
                    controller: _buscaController,
                    onChanged: (_) => setState(() {}),
                  ),
                  const SizedBox(height: 12),
                  ..._livros.asMap().entries.map((entry) {
                    final i = entry.key;
                    final livro = entry.value;
                    final borderColor = Theme.of(context)
                        .colorScheme
                        .tertiary
                        .withValues(alpha: 0.15);
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
                        if (i < _livros.length - 1)
                          Divider(color: borderColor, height: 1),
                      ],
                    );
                  }),
                ],
              ),
            ),
            const SizedBox(height: 20),
            ActionButton(
              label: 'Criar coleção',
              onPressed: _podeSubmeter ? () => Navigator.pop(context) : null,
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
