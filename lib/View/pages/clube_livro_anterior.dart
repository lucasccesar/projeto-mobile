import 'package:flutter/material.dart';
import 'package:projeto_mobile/config/app_colors.dart';
import 'package:projeto_mobile/view/pages/clube_livro_proximo.dart';
import 'package:projeto_mobile/view/widgets/bookly_appbar_widget.dart';
import 'package:projeto_mobile/view/widgets/clube_livro_anterior_proximo.dart';
import 'package:projeto_mobile/view/widgets/clube_navegacao.dart';
import 'package:projeto_mobile/view/widgets/rodape_navegacao_clube_widget.dart';
import 'package:projeto_mobile/view/widgets/sidebar_widget.dart';

class ClubeLivroAnterior extends StatelessWidget {
  const ClubeLivroAnterior({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: SidebarWidget(),
      appBar: BooklyAppBar(
        title: "Clube do Livro",
        iconeMenu: false,
        iconeCarrinho: false,
        iconeSeta: true,
        corDoTexto: AppColors.clube,
      ),

      body: Column(
        children: [
          ClubeNavegacao(
            onProximoTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ClubeLivroProximo()),
              );
            },
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
                      "Livros lidos pelo clube nos meses anteriores",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.tertiary,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                ),
                ClubeLivroAnteriorProximo(
                  anterior: true,
                  titulo: "O Senhor dos Anéis",
                  autor: "J.R.R. Tolkiin",
                  data: "15/03/2023",
                  nota: 4.6,
                ),
                ClubeLivroAnteriorProximo(
                  anterior: true,
                  titulo: "O Hobbit",
                  autor: "J.R.R. Tolkiin",
                  data: "15/04/2023",
                  nota: 4.2,
                ),
                ClubeLivroAnteriorProximo(
                  anterior: true,
                  titulo: "O Hobbit",
                  autor: "J.R.R. Tolkiin",
                  data: "15/04/2023",
                  nota: 4.2,
                ),
                ClubeLivroAnteriorProximo(
                  anterior: true,
                  titulo: "O Hobbit",
                  autor: "J.R.R. Tolkiin",
                  data: "15/04/2023",
                  nota: 4.2,
                ),
                ClubeLivroAnteriorProximo(
                  anterior: true,
                  titulo: "O Hobbit",
                  autor: "J.R.R. Tolkiin",
                  data: "15/04/2023",
                  nota: 4.2,
                ),
                ClubeLivroAnteriorProximo(
                  anterior: true,
                  titulo: "O Hobbit",
                  autor: "J.R.R. Tolkiin",
                  data: "15/04/2023",
                  nota: 4.2,
                ),
                ClubeLivroAnteriorProximo(
                  anterior: true,
                  titulo: "O Hobbit",
                  autor: "J.R.R. Tolkiin",
                  data: "15/04/2023",
                  nota: 4.2,
                ),
                ClubeLivroAnteriorProximo(
                  anterior: true,
                  titulo: "O Hobbit",
                  autor: "J.R.R. Tolkiin",
                  data: "15/04/2023",
                  nota: 4.2,
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: ClubeRodape(),
    );
  }
}
