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

class ClubesPage extends StatefulWidget {
  const ClubesPage({super.key});

  @override
  State<ClubesPage> createState() => _ClubesPageState();
}

class _ClubesPageState extends State<ClubesPage> {
  final ClubeDoLivroService clubeService = ClubeDoLivroService();
  late Future<List<ClubeDoLivro>> _future;
  String _busca = '';

  @override
  void initState() {
    super.initState();
    _future = clubeService.fetchClubesDoLivro();
  }

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
                  child: BooklySearchBar(
                    hintText: 'Nome ou Tema',
                    onChanged: (value) {
                      setState(() {
                        _busca = value;
                      });
                    },
                  ),
                ),
                SizedBox(width: 10),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const ClubeCriar()),
                    ).then((_) {
                      setState(() {
                        _future = clubeService.fetchClubesDoLivro();
                      });
                    });
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
                future: _future,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        'Erro ao carregar clubes',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.error,
                        ),
                      ),
                    );
                  }

                  final clubes = snapshot.data ?? [];

                  if (clubes.isEmpty) {
                    return Center(
                      child: Text(
                        'Nenhum clube encontrado',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.error,
                        ),
                      ),
                    );
                  }

                  final clubesFiltrados = clubes.where((clube) {
                    final buscaLower = _busca.toLowerCase();
                    return clube.nome.toLowerCase().contains(buscaLower) ||
                        clube.tema.toLowerCase().contains(buscaLower);
                  }).toList();

                  if (clubesFiltrados.isEmpty) {
                    return Center(
                      child: Text(
                        'Nenhum clube encontrado para essa busca',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.error,
                        ),
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: clubesFiltrados.length,
                    itemBuilder: (context, index) {
                      final clube = clubesFiltrados[index];
                      return ClubPesquisa(
                        title: clube.nome,
                        category: clube.tema,
                        participants: clube.participantes,
                        date: clube.datas,
                        onTap: () =>
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ClubeHome(clube: clube),
                              ),
                            ).then((deletado) {
                              if (deletado == true) {
                                setState(() {
                                  _future = clubeService.fetchClubesDoLivro();
                                });
                              }
                            }),
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
