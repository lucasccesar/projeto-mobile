import 'package:flutter/material.dart';
import 'package:projeto_mobile/View/widgets/appbar_widget.dart';
import 'package:projeto_mobile/View/widgets/livro_row_widget.dart';
import 'package:projeto_mobile/View/widgets/text_field.dart';
import 'package:projeto_mobile/View/widgets/clube_mebro.dart';
import 'package:projeto_mobile/View/widgets/colecao_form_widgets.dart';
import 'package:projeto_mobile/config/app_colors.dart';
import 'package:projeto_mobile/config/token_config.dart';
import 'package:projeto_mobile/models/book.dart';
import 'package:projeto_mobile/models/clube_do_livro.dart';
import 'package:projeto_mobile/services/book_service.dart';
import 'package:projeto_mobile/services/clube_assignment.dart';
import 'package:projeto_mobile/services/clube_do_livro_service.dart';
import 'package:projeto_mobile/services/usuario_participante_service.dart';
import 'package:projeto_mobile/services/usuario_service.dart';

class ClubeConfig extends StatefulWidget {
  final ClubeDoLivro clube;
  const ClubeConfig({super.key, required this.clube});

  @override
  State<ClubeConfig> createState() => _ClubeConfigState();
}

class _ClubeConfigState extends State<ClubeConfig> {
  final ClubeDoLivroService _clubeService = ClubeDoLivroService();
  final ParticipantUserService _participantService = ParticipantUserService();
  final UsuarioService _usuarioService = UsuarioService();
  final BookService _bookService = BookService();
  final BookClubAssignmentService _assignmentService =
      BookClubAssignmentService();

  bool _salvando = false;
  List<Book> _livros = [];
  Set<String> _livrosDoClube = {};
  Set<String> _livrosSelecionados = {};
  bool _carregandoLivros = true;
  final _buscarLivroAdicionarController = TextEditingController();
  final _nomeController = TextEditingController();
  final _temaController = TextEditingController();
  final _descricaoController = TextEditingController();
  final _buscaMembroController = TextEditingController();

  // lista de {idParticipantUser, userId, nome}
  List<Map<String, String>> _membros = [];
  bool _carregandoMembros = true;

  List<Map<String, String>> get _membrosFiltrados {
    final query = _buscaMembroController.text.trim().toLowerCase();
    if (query.isEmpty) return _membros;
    return _membros
        .where((m) => (m['nome'] ?? '').toLowerCase().contains(query))
        .toList();
  }

  List<Book> get _livrosFiltradosAdicionar {
    final query = _buscarLivroAdicionarController.text.trim().toLowerCase();
    if (query.isEmpty) return _livros;
    return _livros
        .where(
          (l) =>
              l.title.toLowerCase().contains(query) ||
              l.author.toLowerCase().contains(query),
        )
        .toList();
  }

  bool get _podeConfirmar =>
      _nomeController.text.trim().isNotEmpty ||
      _temaController.text.trim().isNotEmpty ||
      _descricaoController.text.trim().isNotEmpty;

  @override
  void initState() {
    super.initState();
    _nomeController.text = widget.clube.nome;
    _temaController.text = widget.clube.tema;
    _descricaoController.text = widget.clube.descricao;
    _nomeController.addListener(() => setState(() {}));
    _temaController.addListener(() => setState(() {}));
    _descricaoController.addListener(() => setState(() {}));
    _buscaMembroController.addListener(() => setState(() {}));
    _carregarMembros();
    _buscarLivroAdicionarController.addListener(() => setState(() {}));
    _carregarLivros();
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _temaController.dispose();
    _descricaoController.dispose();
    _buscaMembroController.dispose();
    _buscarLivroAdicionarController.dispose();
    super.dispose();
  }

  Future<void> _carregarMembros() async {
    try {
      final participantes = await _participantService.fetchParticipantes(
        widget.clube.id,
      );

      // busca nomes em paralelo
      final membrosComNome = await Future.wait(
        participantes.map((p) async {
          final nome = await _usuarioService.fetchNome(p['userId']!);
          return {
            'idParticipantUser': p['idParticipantUser']!,
            'userId': p['userId']!,
            'nome': nome,
          };
        }),
      );

      setState(() {
        _membros = membrosComNome;
        _carregandoMembros = false;
      });
    } catch (e) {
      setState(() => _carregandoMembros = false);
    }
  }

  Future<void> _removerMembro(String idParticipantUser) async {
    try {
      await _participantService.removerParticipante(idParticipantUser);
      setState(() {
        _membros.removeWhere(
          (m) => m['idParticipantUser'] == idParticipantUser,
        );
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Membro removido!')));
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Erro ao remover membro')));
    }
  }

  Future<void> _salvarAlteracoes() async {
    if (!_podeConfirmar || _salvando) return;
    setState(() => _salvando = true);

    try {
      final clubeAtualizado = await _clubeService.atualizarClube(
        id: widget.clube.id,
        nome: _nomeController.text.trim(),
        tema: _temaController.text.trim(),
        descricao: _descricaoController.text.trim(),
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Clube atualizado com sucesso!')),
      );

      Navigator.pop(context, clubeAtualizado);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Erro ao atualizar clube')));
    } finally {
      setState(() => _salvando = false);
    }
  }

  Future<void> _deletarClube() async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Deletar clube'),
        content: const Text('Tem certeza? Esta ação não pode ser desfeita.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Deletar', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmar != true) return;

    try {
      await _clubeService.deletarClube(widget.clube.id);
      if (!mounted) return;
      Navigator.pop(context, 'deletado');
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Erro ao deletar clube')));
    }
  }

  Future<void> _carregarLivros() async {
    try {
      final livros = await _bookService.fetchLivros();
      final bookIds = await _assignmentService.fetchBookIdsDoClube(
        widget.clube.id,
      );
      setState(() {
        _livros = livros;
        _livrosDoClube = bookIds;
        _carregandoLivros = false;
      });
    } catch (e) {
      setState(() => _carregandoLivros = false);
    }
  }

  Future<void> _adicionarLivros() async {
  if (_livrosSelecionados.isEmpty) return;

  try {
    
    for (final bookId in _livrosSelecionados) {
      await _assignmentService.addBookToClub(
        clubId: widget.clube.id,
        bookId: bookId,
      );
    }

    setState(() {
      _livrosDoClube.addAll(_livrosSelecionados);
      _livrosSelecionados.clear();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Livros adicionados com sucesso!')),
    );
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Erro ao adicionar livros')),
    );
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BooklyAppBar(
        title: 'Config. do Clube',
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
                  SectionLabel(
                    texto: 'Informações do Clube',
                    cor: AppColors.clube,
                  ),
                  SizedBox(height: 16),
                  BooklyTextField(
                    label: 'Nome do clube',
                    hintText: 'Ex: Leitores do Amanhã',
                    controller: _nomeController,
                    showBorder: true,
                  ),
                  SizedBox(height: 16),
                  BooklyTextField(
                    label: 'Tema / Gênero',
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
                ],
              ),
            ),

            SizedBox(height: 16),

            CardSection(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SectionLabel(
                    texto: 'Membros (${_membros.length})',
                    cor: AppColors.clube,
                  ),
                  SizedBox(height: 12),
                  BooklyTextField(
                    hintText: 'Buscar membro...',
                    controller: _buscaMembroController,
                  ),
                  SizedBox(height: 12),
                  if (_carregandoMembros)
                    const Center(
                      child: CircularProgressIndicator(color: AppColors.clube),
                    )
                  else if (_membrosFiltrados.isEmpty)
                    const Center(child: Text('Nenhum membro encontrado'))
                  else
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxHeight: 300),
                      child: SingleChildScrollView(
                        child: Column(
                          children: _membrosFiltrados.map((membro) {
                            final ehCriador =
                                membro['userId'] == widget.clube.creatorId;
                            final ehEuMesmo =
                                membro['userId'] == TokenConfig.userId;
                            return ClubeMembro(
                              nome: membro['nome'] ?? 'Usuário',
                              mostrarRemover:
                                  !ehCriador &&
                                  !ehEuMesmo, // não remove criador nem a si mesmo
                              onRemover: () =>
                                  _removerMembro(membro['idParticipantUser']!),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            
            SizedBox(height: 16),

            CardSection(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SectionLabel(texto: 'Adicionar Livros', cor: AppColors.clube),
                  SizedBox(height: 12),
                  BooklyTextField(
                    hintText: 'Buscar livro…',
                    controller: _buscarLivroAdicionarController,
                  ),
                  SizedBox(height: 12),
                  if (_carregandoLivros)
                    const Center(child: CircularProgressIndicator())
                  else if (_livrosFiltradosAdicionar.isEmpty)
                    const Center(child: Text('Nenhum livro encontrado'))
                  else
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxHeight: 250),
                      child: SingleChildScrollView(
                        child: Column(
                          children: _livrosFiltradosAdicionar
                              .asMap()
                              .entries
                              .map((entry) {
                                final i = entry.key;
                                final livro = entry.value;
                                final jaNoClube = _livrosDoClube.contains(
                                  livro.id,
                                );
                                final selecionado = _livrosSelecionados
                                    .contains(livro.id);

                                return Column(
                                  children: [
                                    LivroRow(
                                      titulo: livro.title,
                                      autor: livro.author,
                                      cor: jaNoClube
                                          ? Colors.grey
                                          : AppColors.clube,
                                      selecionado: jaNoClube || selecionado,
                                      onToggle: jaNoClube
                                          ? null
                                          : () {
                                              setState(() {
                                                if (selecionado) {
                                                  _livrosSelecionados.remove(
                                                    livro.id,
                                                  );
                                                } else {
                                                  _livrosSelecionados.add(
                                                    livro.id,
                                                  );
                                                }
                                              });
                                            },
                                    ),
                                    if (i <
                                        _livrosFiltradosAdicionar.length - 1)
                                      Divider(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .tertiary
                                            .withOpacity(0.15),
                                        height: 1,
                                      ),
                                  ],
                                );
                              })
                              .toList(),
                        ),
                      ),
                    ),
                  if (_livrosSelecionados.isNotEmpty) ...[
                    SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _adicionarLivros,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.clube,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: Text(
                          'Adicionar ${_livrosSelecionados.length} livro(s)',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(0, 18, 0, 18),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _podeConfirmar ? _salvarAlteracoes : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.clube,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: _salvando
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Text(
                          'Confirmar Mudanças',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 18),
              child: SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: _deletarClube,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.red,
                    side: const BorderSide(color: Colors.red),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: const Text(
                    'Deletar Clube',
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
