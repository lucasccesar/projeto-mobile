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
  late Future<bool> _ehParticipante;

  String get meuUserId => TokenConfig.userId!;

  @override
  void initState() {
    super.initState();
    if (widget.jaParticipante) {
      widget.clube.participantes = 1;
      _ehParticipante = Future.value(true);
    } else {
      _ehParticipante = _verificarParticipacao();
    }
  }

  Future<bool> _verificarParticipacao() async {
    final count = await _participantService.fetchParticipantCount(
      widget.clube.id,
    );
    // busca a lista completa para verificar se o usuário está
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
                // linha com icone + nome e tema+ botoes
                Row(
                  children: [
                    //icone do clube
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

                    //nome e tema do clube
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

                // botao abrir chat e config
                Row(
                  children: [
                    // botão entrar
                    FutureBuilder<bool>(
                      future: _ehParticipante,
                      builder: (context, snapshot) {
                        final ehParticipante = snapshot.data ?? true;
                        if (ehParticipante)
                          return SizedBox.shrink(); //esconde o botão

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

                    // botão abrir chat
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  ClubeMensagem(clubeId: widget.clube.id),
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

                    SizedBox(width: 10),

                    // botão config
                    if (widget.clube.creatorId == TokenConfig.userId)
                    OutlinedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const ClubeConfig(),
                          ),
                        );
                      },
                      icon: Icon(Icons.settings_outlined, size: 18),
                      label: Text('Config'),
                      style: OutlinedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        foregroundColor: Theme.of(context).colorScheme.tertiary,
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
              MaterialPageRoute(builder: (_) => const ClubeLivroAnterior()),
            ),
            onProximoTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ClubeLivroProximo()),
            ),
          ),

          Divider(
            color: Theme.of(context).colorScheme.tertiary.withOpacity(0.15),
            height: 1,
          ),

          //SizedBox(height: 15),

          // resto da tela
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClubeHomeWidget(),

                  SizedBox(height: 5),

                  //descricao do clube
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 18.0),
                    child: Text(
                      widget.clube.descricao,
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.tertiary,
                        fontSize: 14,
                      ),
                    ),
                  ),

                  SizedBox(height: 15),

                  //botao
                  Padding(
                    padding: EdgeInsets.fromLTRB(18.0, 0, 18.0, 0),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          final livro = Book(
                            id: '1',
                            title: 'O Senhor dos Anéis',
                            author: 'J.R.R. Tolkien',
                            genre: 'Fantasia',
                            price: 59.90,
                            rating: 9.8,
                          );

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => BookPage(livro: livro),
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
                          'Ver Detalhes do Livro',
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
          ),
        ],
      ),
      bottomNavigationBar: const Rodape(selectedTab: NavTab.clubes),
    );
  }
}
