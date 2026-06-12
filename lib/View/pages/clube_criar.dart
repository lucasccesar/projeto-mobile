import 'package:flutter/material.dart';
import 'package:projeto_mobile/View/pages/clube_home.dart';
import 'package:projeto_mobile/View/widgets/appbar_widget.dart';
import 'package:projeto_mobile/View/widgets/livro_row_widget.dart';
import 'package:projeto_mobile/View/widgets/text_field.dart';
import 'package:projeto_mobile/View/widgets/colecao_form_widgets.dart';
import 'package:projeto_mobile/config/app_colors.dart';
import 'package:projeto_mobile/config/token_config.dart';
import 'package:projeto_mobile/models/livro_selecionavel.dart';
import 'package:projeto_mobile/services/clube_do_livro_service.dart';

class ClubeCriar extends StatefulWidget {
  const ClubeCriar({super.key});

  @override
  State<ClubeCriar> createState() => _ClubeCriarState();
}

class _ClubeCriarState extends State<ClubeCriar> {
  final _nomeController = TextEditingController();
  final _temaController = TextEditingController();
  final _descricaoController = TextEditingController();
  final _buscarLivroController = TextEditingController();
  LivroSelecionavel? _livroSelecionado;
  final ClubeDoLivroService _clubeService = ClubeDoLivroService();
  bool _criando = false;
  String? _frequenciaSelecionada;

  String get meuUserId => TokenConfig.userId!;

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
      _livroSelecionado != null &&
      _frequenciaSelecionada != null &&
      !_criando;

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
    _buscarLivroController.dispose();
    super.dispose();
  }

  Future<void> _criarClube() async {
    if (!_podeCriar) return;
    setState(() => _criando = true);

    try {
      final clube = await _clubeService.criarClube(
        nome: _nomeController.text.trim(),
        tema: _temaController.text.trim(),
        descricao: _descricaoController.text.trim(),
        creatorId: meuUserId,
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => ClubeHome(clube: clube, jaParticipante: true),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Erro ao criar clube')));
    } finally {
      setState(() => _criando = false);
    }
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
                    label: 'Tema / Gênero principal *',
                    hintText: 'Ex: Aventura',
                    controller: _temaController,
                    showBorder: true,
                  ),
                  SizedBox(height: 16),
                  BooklyTextField(
                    label: 'Descrição',
                    hintText: 'Apresente o clube para novos membros...',
                    controller: _descricaoController,
                    maxLines: 3,
                    showBorder: true,
                  ),

                  SizedBox(height: 16),

                  SectionLabel(
                    texto: 'Frequência de discussão dos livros *',
                    cor: AppColors.clube,
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: ['Semanal', 'Quinzenal', 'Mensal'].map((
                      frequencia,
                    ) {
                      final selecionado = _frequenciaSelecionada == frequencia;
                      return Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() {
                            _frequenciaSelecionada = selecionado
                                ? null
                                : frequencia;
                          }),
                          child: Row(
                            children: [
                              Checkbox(
                                value: selecionado,
                                onChanged: (_) => setState(() {
                                  _frequenciaSelecionada = selecionado
                                      ? null
                                      : frequencia;
                                }),
                                activeColor: AppColors.clube,
                              ),
                              Text(
                                frequencia,
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.tertiary,
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),

            SizedBox(height: 16),

            CardSection(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SectionLabel(
                    texto: 'Adicionar Livro *',
                    cor: AppColors.clube,
                  ),
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
                  onPressed: _podeCriar ? _criarClube : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.clube,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: _criando
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : Text(
                          'Criar Clube do Livro',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
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
