import 'package:flutter/material.dart';
import 'package:projeto_mobile/View/widgets/bookly_appbar_widget.dart';
import 'package:projeto_mobile/View/widgets/rodape_widget.dart';
import 'package:projeto_mobile/config/app_colors.dart';
import 'package:projeto_mobile/View/pages/catalogo_page.dart';
import 'package:projeto_mobile/View/pages/clube_livro_anterior.dart';
import 'package:projeto_mobile/View/pages/clube_livro_proximo.dart';
import 'package:projeto_mobile/View/pages/clube_mensagem.dart';
import 'package:projeto_mobile/View/widgets/clube_home_widget.dart';
import 'package:projeto_mobile/View/widgets/clube_navegacao.dart';

class ClubeHome extends StatelessWidget {
  const ClubeHome({super.key});

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
                          //TODO: variavel nome
                          Text(
                            'Aventureiros do Texto',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.tertiary,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            //TODO: variavel tema e numero de participantes
                            'Tema: Aventura • 12 participantes',
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
                    // Botão Abrir Chat
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const ClubeMensagem(),
                            ),
                          );
                        },
                        icon: Icon(Icons.chat_bubble_outline, size: 18),
                        label: Text('Abrir Chat'),
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

                    // Botão Config
                    OutlinedButton.icon(
                      onPressed: () {
                        // TODO: abrir configurações
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

                  //descricao do livro
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 18.0),
                    child: Text(
                      'Uma aventura emocionante sobre coragem e amizade, escolhida por votação do grupo. Venha discutir no chat!',
                      textAlign: TextAlign.justify, // TODO: variavel
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
                          // TODO: navegar para detalhes do livro
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
      bottomNavigationBar: BooklyRodape(
        selectedTab: NavTab.clubes,
        onTabChanged: (tab) {
          if (tab == NavTab.catalogo) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const CatalogoPage()),
            );
          }
        },
      ),
    );
  }
}
