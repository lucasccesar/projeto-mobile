import 'package:flutter/material.dart';
import 'package:projeto_mobile/View/pages/book_page.dart';
import 'package:projeto_mobile/View/pages/clube_config.dart';
import 'package:projeto_mobile/View/widgets/appbar_widget.dart';
import 'package:projeto_mobile/View/widgets/rodape_widget.dart';
import 'package:projeto_mobile/config/app_colors.dart';
import 'package:projeto_mobile/View/pages/clube_livro_anterior.dart';
import 'package:projeto_mobile/View/pages/clube_livro_proximo.dart';
import 'package:projeto_mobile/View/pages/clube_mensagem.dart';
import 'package:projeto_mobile/View/widgets/clube_home_widget.dart';
import 'package:projeto_mobile/View/widgets/clube_navegacao.dart';
import 'package:projeto_mobile/config/token_config.dart';
import 'package:projeto_mobile/models/book.dart';
import 'package:projeto_mobile/models/clube_do_livro.dart';
import 'package:projeto_mobile/services/book_service.dart';
import 'package:projeto_mobile/services/clube_assignment.dart';
import 'package:projeto_mobile/services/rating_service.dart';
import 'package:projeto_mobile/services/usuario_participante_service.dart';

class ClubeHome extends StatefulWidget {
  final ClubeDoLivro clube;
  final bool jaParticipante;
  const ClubeHome({
    super.key,
    required this.clube,
    this.jaParticipante = false,
  });

  @override
  State<ClubeHome> createState() => _ClubeHomeState();
}

class _ClubeHomeState extends State<ClubeHome> {
  final ParticipantUserService _participantService = ParticipantUserService();
  final BookService _bookService = BookService();
  final BookClubAssignmentService _assignmentService =
      BookClubAssignmentService();
  final RatingService _ratingService = RatingService();
  double _avaliacaoMedia = 0;
  int _totalAvaliacoes = 0;

  late Future<bool> _ehParticipante;
  Book? _livroAtual;
  String? _startDate;
  String? _finishDate;

  String get meuUserId => TokenConfig.userId!;

  @override
  void initState() {
    super.initState();
    // print('creatorId do clube: ${widget.clube.creatorId}');
    // print('meuUserId: ${TokenConfig.userId}');
    _carregarLivroAtual();
    if (widget.jaParticipante) {
      widget.clube.participantes = 1;
      _ehParticipante = Future.value(true);
    } else {
      _ehParticipante = _verificarParticipacao();
    }
  }

  Future<void> _carregarLivroAtual() async {
    final assignment = await _assignmentService.fetchAssignmentAtual(
      widget.clube.id,
    );
    if (assignment == null) return;

    final livro = await _bookService.fetchLivroPorId(assignment['bookId']!);

    final resultados = await Future.wait([
      _ratingService.fetchAverage(livro.id),
      _ratingService.fetchCount(livro.id),
    ]);

    setState(() {
      _livroAtual = livro;
      _startDate = assignment['startDate'];
      _finishDate = assignment['finishDate'];
      _avaliacaoMedia = resultados[0] as double;
      _totalAvaliacoes = resultados[1] as int;
    });
  }

  Future<bool> _verificarParticipacao() async {
    return await _participantService.usuarioEhParticipante(
      clubId: widget.clube.id,
      userId: meuUserId,
    );
  }

  Future<void> _entrarNoClube() async {
    await _participantService.entrarNoClube(
      userId: meuUserId,
      clubId: widget.clube.id,
    );
    setState(() {
      _ehParticipante = Future.value(true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BooklyAppBar(
        title: 'Clube do Livro',
        iconeMenu: false,
        iconeCarrinho: false,
        iconeSeta: true,
        corDoTexto: AppColors.clube,
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            color: AppColors.clube.withOpacity(0.157),
            padding: EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Color.lerp(AppColors.clube, Colors.white, 0.7),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.auto_stories_outlined,
                        color: Color(0xFF4A7FA5),
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.clube.nome,
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.tertiary,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'Tema: ${widget.clube.tema} • ${widget.clube.participantes} participantes',
                            style: TextStyle(
                              color: AppColors.clube,
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 10),

                Row(
                  children: [
                    // botão entrar
                    FutureBuilder<bool>(
                      future: _ehParticipante,
                      builder: (context, snapshot) {
                        final ehParticipante = snapshot.data ?? true;
                        if (ehParticipante) return SizedBox.shrink();

                        return Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: ElevatedButton.icon(
                              onPressed: _entrarNoClube,
                              icon: Icon(Icons.group_add_outlined, size: 18),
                              label: Text('Entrar'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.clube,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(24),
                                ),
                                padding: EdgeInsets.symmetric(vertical: 12),
                              ),
                            ),
                          ),
                        );
                      },
                    ),

                    // botão chat
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          final participante = await _ehParticipante;
                          if (!mounted) return;
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ClubeMensagem(
                                clubeId: widget.clube.id,
                                ehParticipante: participante,
                              ),
                            ),
                          );
                        },
                        icon: Icon(Icons.chat_bubble_outline, size: 18),
                        label: Text('Chat'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.clube,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                          padding: EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),

                    // botão config — só aparece para o criador
                    if (widget.clube.creatorId == TokenConfig.userId) ...[
                      SizedBox(width: 10),
                      OutlinedButton.icon(
                        onPressed: () async {
                          final resultado = await Navigator.push<dynamic>(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ClubeConfig(clube: widget.clube),
                            ),
                          );

                          if (resultado == 'deletado') {
                            Navigator.pop(context, true);
                          } else if (resultado is ClubeDoLivro) {
                            setState(() {
                              widget.clube.nome = resultado.nome;
                              widget.clube.tema = resultado.tema;
                              widget.clube.descricao = resultado.descricao;
                            });
                          }
                        },
                        icon: Icon(Icons.settings_outlined, size: 18),
                        label: Text('Config'),
                        style: OutlinedButton.styleFrom(
                          backgroundColor: Theme.of(
                            context,
                          ).colorScheme.primary,
                          foregroundColor: Theme.of(
                            context,
                          ).colorScheme.tertiary,
                          side: BorderSide(
                            color: Theme.of(
                              context,
                            ).colorScheme.tertiary.withOpacity(0.25),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                          padding: EdgeInsets.symmetric(
                            vertical: 12,
                            horizontal: 16,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),

                SizedBox(height: 4),
              ],
            ),
          ),

          // Abas de navegação
          ClubeNavegacao(
            abaSelecionada: 0,
            onAnteriorTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ClubeLivroAnterior(clubeId: widget.clube.id),
              ),
            ),
            onProximoTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ClubeLivroProximo(clubeId: widget.clube.id),
              ),
            ),
          ),

          Divider(
            color: Theme.of(context).colorScheme.tertiary.withOpacity(0.15),
            height: 1,
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  SizedBox(height: 5),

                  // descrição do clube
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                        border: Border.all(
                          color: Theme.of(
                            context,
                          ).colorScheme.tertiary.withOpacity(0.208),
                        ),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.info_outline,
                                size: 16,
                                color: AppColors.clube,
                              ),
                              SizedBox(width: 6),
                              Text(
                                'Sobre o clube',
                                style: TextStyle(
                                  color: AppColors.clube,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 8),
                          Text(
                            widget.clube.descricao,
                            textAlign: TextAlign.justify,
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.tertiary,
                              fontSize: 14,
                              height:
                                  1.4, // ⬅️ espaçamento entre linhas, melhora a leitura
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // widget do livro atual
                  ClubeHomeWidget(
                    livro: _livroAtual,
                    startDate: _startDate,
                    finishDate: _finishDate,
                    avaliacaoMedia: _avaliacaoMedia,
                    totalAvaliacoes: _totalAvaliacoes,
                  ),

                  SizedBox(height: 5),

                  // botão ver detalhes do livro
                  Padding(
                    padding: EdgeInsets.fromLTRB(18.0, 0, 18.0, 0),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _livroAtual == null
                            ? null // desabilita se não tiver livro
                            : () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        BookPage(livro: _livroAtual!),
                                  ),
                                );
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.clube,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        child: Text(
                          _livroAtual == null
                              ? 'Nenhum livro no momento'
                              : 'Ver Detalhes do Livro',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const Rodape(selectedTab: NavTab.clubes),
    );
  }
}
