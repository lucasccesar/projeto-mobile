import 'package:flutter/material.dart';
import 'package:projeto_mobile/View/widgets/rodape_widget.dart';
import 'package:projeto_mobile/config/app_colors.dart';
import 'package:projeto_mobile/View/pages/clube_livro_anterior.dart';
import 'package:projeto_mobile/View/widgets/appbar_widget.dart';
import 'package:projeto_mobile/View/widgets/clube_livro_anterior_proximo.dart';
import 'package:projeto_mobile/View/widgets/clube_navegacao.dart';
import 'package:projeto_mobile/View/widgets/sidebar_widget.dart';

class ClubeLivroProximo extends StatelessWidget {
  const ClubeLivroProximo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: SidebarWidget(),
      appBar: BooklyAppBar(
        title: 'Clube do Livro',
        iconeMenu: false,
        iconeCarrinho: false,
        iconeSeta: true,
        corDoTexto: AppColors.clube,
      ),
      body: Column(
        children: [
          ClubeNavegacao(
            abaSelecionada: 2,
            onAtualTap: () => Navigator.pop(context),
            onAnteriorTap: () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const ClubeLivroAnterior()),
            ),
          ),
          Divider(
            height: 1,
            color: Color.lerp(
              Theme.of(context).colorScheme.tertiary,
              Colors.white,
              0.8,
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                SizedBox(height: 14),
                Padding(
                  padding: EdgeInsets.only(left: 20),
                  child: SizedBox(
                    height: 20,
                    width: double.infinity,
                    child: Text(
                      'Próximos livros planejados para o clube',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.tertiary,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                ),
                ClubeLivroAnteriorProximo(
                  anterior: false,
                  titulo: 'O Senhor dos Anéis',
                  autor: 'J.R.R. Tolkien',
                  data: '15/03/2024',
                ),
                ClubeLivroAnteriorProximo(
                  anterior: false,
                  titulo: '1984',
                  autor: 'George Orwell',
                  data: '15/04/2024',
                ),
                ClubeLivroAnteriorProximo(
                  anterior: false,
                  titulo: 'Admirável Mundo Novo',
                  autor: 'Aldous Huxley',
                  data: '15/05/2024',
                ),
                ClubeLivroAnteriorProximo(
                  anterior: false,
                  titulo: 'Cem Anos de Solidão',
                  autor: 'Gabriel García Márquez',
                  data: '15/06/2024',
                ),
                ClubeLivroAnteriorProximo(
                  anterior: false,
                  titulo: 'Dom Casmurro',
                  autor: 'Machado de Assis',
                  data: '15/07/2024',
                ),
                ClubeLivroAnteriorProximo(
                  anterior: false,
                  titulo: 'A Revolução dos Bichos',
                  autor: 'George Orwell',
                  data: '15/08/2024',
                ),
                ClubeLivroAnteriorProximo(
                  anterior: false,
                  titulo: 'O Pequeno Príncipe',
                  autor: 'Antoine de Saint-Exupéry',
                  data: '15/09/2024',
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: const Rodape(
        selectedTab: NavTab.clubes,
      ),
    );
  }
}