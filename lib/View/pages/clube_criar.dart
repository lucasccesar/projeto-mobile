import 'package:flutter/material.dart';
import 'package:projeto_mobile/View/pages/clube_home.dart';
import 'package:projeto_mobile/View/widgets/appbar_widget.dart';
import 'package:projeto_mobile/View/widgets/livro_row_widget.dart';
import 'package:projeto_mobile/View/widgets/text_field.dart';
import 'package:projeto_mobile/View/widgets/colecao_form_widgets.dart';
import 'package:projeto_mobile/config/app_colors.dart';
import 'package:projeto_mobile/models/clube_do_livro.dart';
import 'package:projeto_mobile/models/livro_selecionavel.dart';

class ClubeCriar extends StatefulWidget {
  const ClubeCriar({super.key});

  @override
  State<ClubeCriar> createState() => _ClubeCriarState();
}

class _ClubeCriarState extends State<ClubeCriar> {
  late final ClubeDoLivro clube;
  final _nomeController = TextEditingController();
  final _temaController = TextEditingController();
  final _descricaoController = TextEditingController();
  final _limiteMembrosController = TextEditingController();
  final _buscarLivroController = TextEditingController();
  LivroSelecionavel? _livroSelecionado;

  final List<LivroSelecionavel> _livros = [
    LivroSelecionavel(
      titulo: 'O Nome do Vento',
      autor: 'Patrick Rothfuss',
      cor: Color(0xFF7B5EA7),
    ),
    LivroSelecionavel(
      titulo: 'A Roda do Tempo',
      autor: 'Robert Jordan',
      cor: Color(0xFF5E8A6E),
    ),
    LivroSelecionavel(
      titulo: 'Fundação',
      autor: 'Isaac Asimov',
      cor: Color(0xFF7A5C3A),
    ),
    LivroSelecionavel(
      titulo: 'Neuromancer',
      autor: 'William Gibson',
      cor: Color(0xFF4A7FA5),
    ),
    LivroSelecionavel(
      titulo: 'Drácula',
      autor: 'Bram Stoker',
      cor: Color(0xFF8B3A3A),
    ),
  ];

  List<LivroSelecionavel> get _livrosFiltrados {
    final query = _buscarLivroController.text.trim().toLowerCase();
    if (query.isEmpty) return _livros;
    return _livros
        .where(
          (l) =>
              l.titulo.toLowerCase().contains(query) ||
              l.autor.toLowerCase().contains(query),
        )
        .toList();
  }

  bool get _podeCriar =>
      _nomeController.text.trim().isNotEmpty &&
      _temaController.text.trim().isNotEmpty &&
      _livroSelecionado != null;

  @override
  void initState() {
    super.initState();
    _buscarLivroController.addListener(() => setState(() {}));
    _nomeController.addListener(() => setState(() {}));
    _temaController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _temaController.dispose();
    _descricaoController.dispose();
    _limiteMembrosController.dispose();
    _buscarLivroController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BooklyAppBar(
        title: 'Criar Clube',
        iconeMenu: false,
        iconeCarrinho: false,
        iconeSeta: true,
        corDoTexto: AppColors.clube,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                height: 72,
                width: 72,
                decoration: BoxDecoration(
                  color: AppColors.clube.withOpacity(0.157),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Icon(
                  Icons.book_outlined,
                  color: AppColors.clube,
                  size: 28,
                ),
              ),
            ),

            SizedBox(height: 20),

            CardSection(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SectionLabel(texto: 'Sobre o Clube', cor: AppColors.clube),

                  SizedBox(height: 16),

                  BooklyTextField(
                    label: 'Nome do clube *',
                    hintText: 'Ex: Leitores do Amanhã',
                    controller: _nomeController,
                    showBorder: true,
                  ),

                  SizedBox(height: 16),

                  BooklyTextField(
                    label: 'Tema / Gênero principal*',
                    hintText: 'Ex: Aventura',
                    controller: _temaController,
                    showBorder: true,
                  ),

                  SizedBox(height: 16),

                  BooklyTextField(
                    label: 'Descrição',
                    hintText: 'Apresente o clube para novos membros...',
                    controller: _descricaoController,
                    maxLines: 3, //TODO: ajeitar limite no back
                    showBorder: true,
                  ),

                  SizedBox(height: 16),

                  BooklyTextField(
                    label: 'Limite de membros',
                    hintText: '10',
                    controller: _limiteMembrosController,
                    keyboardType: TextInputType.number,
                    showBorder: true,
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),

            CardSection(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SectionLabel(texto: 'Adicionar Livro*', cor: AppColors.clube),
                  SizedBox(height: 12),
                  BooklyTextField(
                    hintText: 'Buscar livro…',
                    controller: _buscarLivroController,
                  ),

                  SizedBox(height: 12),

                  ConstrainedBox(
                    constraints: BoxConstraints(maxHeight: 250),
                    child: SingleChildScrollView(
                      child: Column(
                        children: _livrosFiltrados.asMap().entries.map((entry) {
                          final i = entry.key;
                          final livro = entry.value;
                          final selecionado =
                              _livroSelecionado?.titulo == livro.titulo;
                          return Column(
                            children: [
                              LivroRow(
                                titulo: livro.titulo,
                                autor: livro.autor,
                                cor: livro.cor,
                                selecionado: selecionado,
                                onToggle: () => setState(() {
                                  _livroSelecionado = selecionado
                                      ? null
                                      : livro;
                                }),
                              ),
                              if (i < _livrosFiltrados.length - 1)
                                Divider(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.tertiary.withOpacity(0.15),
                                  height: 1,
                                ),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: EdgeInsets.fromLTRB(0, 18, 0, 18),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _podeCriar
                      ? () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ClubeHome(clube: clube),
                            ),
                          );
                        }
                      : null,

                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.clube,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: Text(
                    'Criar Clube do Livro',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
