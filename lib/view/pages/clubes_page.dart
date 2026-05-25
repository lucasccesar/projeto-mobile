import 'package:flutter/material.dart';
import 'package:projeto_mobile/View/pages/clube_criar.dart';
import 'package:projeto_mobile/View/widgets/search_bar.dart';
import 'package:projeto_mobile/config/app_colors.dart';
import 'package:projeto_mobile/View/widgets/appbar_widget.dart';
import 'package:projeto_mobile/View/widgets/rodape_widget.dart';
import 'package:projeto_mobile/View/widgets/sidebar_widget.dart';
import 'package:projeto_mobile/View/pages/clube_home.dart';
import 'package:projeto_mobile/models/clube_do_livro.dart';
import 'package:projeto_mobile/services/clube_do_livro_service.dart';
import '../widgets/clube_pesquisa_widget.dart';

class ClubesPage extends StatelessWidget {
  const ClubesPage({super.key});

  @override
  Widget build(BuildContext context) {

    final clubeService = ClubeDoLivroService();

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
              child: FutureBuilder<List<ClubeDoLivro>>(
                future: clubeService.fetchClubesDoLivro(),
                builder: (context, snapshot) {

                  
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  
                  if (snapshot.hasError) {
                    return Center(
                      child: Text('Erro ao carregar clubes', style: TextStyle(color: Theme.of(context).colorScheme.error)),
                    );
                  }
                
                  final clubes = snapshot.data ?? [];
                  if (clubes.isEmpty) {
                    return Center(child: Text('Nenhum clube encontrado', style: TextStyle(color: Theme.of(context).colorScheme.error)));
                  }


                  return ListView.builder(
                    itemCount: clubes.length,
                    itemBuilder: (context, index) {
                      final clube = clubes[index];
                      return ClubPesquisa(
                        title: clube.nome,
                        category: clube.tema,
                        participants: clube.participantes,
                        date: '',        // TODO: puxar do backend dps
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const ClubeHome()),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const Rodape(selectedTab: NavTab.clubes),
    );
  }
}