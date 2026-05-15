import 'package:flutter/material.dart';
import 'package:projeto_mobile/View/pages/clube_criar.dart';
import 'package:projeto_mobile/View/widgets/search_bar.dart';
import 'package:projeto_mobile/config/app_colors.dart';
import 'package:projeto_mobile/View/widgets/appbar_widget.dart';
import 'package:projeto_mobile/View/widgets/rodape_widget.dart';
import 'package:projeto_mobile/View/widgets/sidebar_widget.dart';
import 'package:projeto_mobile/View/pages/clube_home.dart';
import '../widgets/clube_pesquisa_widget.dart';

class ClubesPage extends StatelessWidget {
  const ClubesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: SidebarWidget(),
      appBar: BooklyAppBar(
        title: 'Clubes do Livro',
        corDoTexto: AppColors.clube,
        iconeMenu: true,
        iconeSeta: false,
        iconeCarrinho: false,
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: BooklySearchBar(hintText: 'Nome ou Tema'),
                ),
                SizedBox(width: 10),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const ClubeCriar()),
                    );
                  },
                  icon: Icon(Icons.add),
                  label: Text('Criar Clube'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.clube,
                    foregroundColor: Theme.of(context).colorScheme.onPrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: 20),
            
            Expanded(
              child: ListView(
                children: [
                  ClubPesquisa(
                    title: 'Fallen',
                    category: 'Professor',
                    participants: 12,
                    date: '14/04 - 29/04',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const ClubeHome()),
                    ),
                  ),
                  ClubPesquisa(
                    title: 'Molodoy',
                    category: 'Furioso',
                    participants: 8,
                    date: '01/05 - 20/05',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const ClubeHome()),
                    ),
                  ),
                  ClubPesquisa(
                    title: 'Yekindar',
                    category: 'Fraco?',
                    participants: 23,
                    date: '',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const ClubeHome()),
                    ),
                  ),
                  ClubPesquisa(
                    title: 'Kscerato',
                    category: 'Mira quente',
                    participants: 23,
                    date: '',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const ClubeHome()),
                    ),
                  ),
                  ClubPesquisa(
                    title: 'Yuri',
                    category: 'Enterna Promessa',
                    participants: 23,
                    date: '',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const ClubeHome()),
                    ),
                  ),
                  ClubPesquisa(
                    title: 'Sidde',
                    category: 'cabecao',
                    participants: 23,
                    date: '',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const ClubeHome()),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const Rodape(
        selectedTab: NavTab.clubes,
      ),
    );
  }
}