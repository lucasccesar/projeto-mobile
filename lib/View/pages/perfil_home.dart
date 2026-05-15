// perfil_home.dart

import 'package:flutter/material.dart';
import 'package:projeto_mobile/View/pages/historico_compras_page.dart';
import 'package:projeto_mobile/View/pages/login.dart';
import 'package:projeto_mobile/View/pages/status_leitura_page.dart';
import 'package:projeto_mobile/View/widgets/appbar_widget.dart';
import 'package:projeto_mobile/View/widgets/perfil_button_widget.dart';
import 'package:projeto_mobile/View/widgets/perfil_card.dart';
import 'package:projeto_mobile/View/widgets/rodape_widget.dart';
import 'package:projeto_mobile/View/widgets/sidebar_widget.dart';
import 'package:projeto_mobile/config/app_colors.dart';

class PerfilHome extends StatelessWidget {
  final String nome;
  final String email;
  final String livros;
  final String clubes;

  const PerfilHome({
    //TODO: linkar com back
    super.key,
    this.nome = 'nome do user',
    this.email = 'email do user',
    this.livros = '42',
    this.clubes = '2',
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: SidebarWidget(),
      appBar: BooklyAppBar(
        title: 'Minha Conta',
        iconeMenu: true,
        iconeCarrinho: false,
        iconeSeta: false,
        corDoTexto: AppColors.perfil,
      ),

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          spacing: 12,
          children: [
            PerfilCardWidget(
              nome: nome,
              email: email,
              livros: livros,
              clubes: clubes,
            ),

            PerfilButtonWidget(
              titulo: 'Histórico de Compras',
              icone: Icon(Icons.receipt_long, color: AppColors.perfil),

              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const HistoricoComprasPage(),
                  ),
                );
              },
            ),

            PerfilButtonWidget(
              titulo: 'Minha Leitura',
              icone: Icon(Icons.bar_chart, color: Colors.green),

              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const StatusLeituraPage()),
                );
              },
            ),

            PerfilButtonWidget(
              titulo: 'Modo Escuro',
              icone: Icon(Icons.nightlight_round, color: Colors.orange),

              onTap: () {
                //TODO:
              },
            ),

            PerfilButtonWidget(
              titulo: 'Sair da Conta',
              icone: Icon(Icons.logout, color: Colors.red),

              sair: true,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginPage()),
                );
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: Rodape( selectedTab: NavTab.conta,),
    );
  }
}
