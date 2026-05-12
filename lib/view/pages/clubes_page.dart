import 'package:flutter/material.dart';
import 'package:projeto_mobile/config/app_colors.dart';
import 'package:projeto_mobile/config/light_theme.dart';
import 'package:projeto_mobile/View/widgets/bookly_appbar_widget.dart';
import 'package:projeto_mobile/View/widgets/rodape_widget.dart';
import 'package:projeto_mobile/View/widgets/sidebar_widget.dart';
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
        //Ajeitando as bordas dos clubes
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            // Busca + botão
            Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Nome ou Tema',
                      hintStyle: TextStyle(
                        color: Theme.of(context).colorScheme.tertiary,
                        fontSize: 16,
                      ),
                      prefixIcon: Icon(
                        Icons.search,
                        color: Theme.of(context).colorScheme.tertiary,
                      ),
                      filled: true,
                      fillColor: Theme.of(context).colorScheme.secondary,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.secondary,
                          width: 1.0,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide(
                          color: Color.lerp(
                            Theme.of(context).colorScheme.tertiary,
                            Theme.of(context).colorScheme.primary,
                            //tem que usar ! pq o lerp pode retornar null
                            0.7,
                          )!,
                          width: 1.0,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide(
                          color: Color.lerp(
                            Theme.of(context).colorScheme.tertiary,
                            Theme.of(context).colorScheme.primary,
                            0.7,
                          )!,
                          width: 1.0,
                        ),
                      ),
                    ),
                  ),
                ),

                SizedBox(width: 10),

                ElevatedButton.icon(
                  onPressed: () {},
                  icon: Icon(Icons.add),
                  label: Text("Criar Clube"),

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

            // Lista de clubes
            Expanded(
              child: ListView(
                children: [
                  ClubPesquisa(
                    title: "Fallen",
                    category: "Professor",
                    participants: 12,
                    date: "14/04 - 29/04",
                    //status: "Ativo",
                  ),
                  ClubPesquisa(
                    title: "Molodoy",
                    category: "Furioso",
                    participants: 8,
                    date: "01/05 - 20/05",
                    //status: "Ativo",
                  ),
                  ClubPesquisa(
                    title: "Yekindar",
                    category: "Fraco?",
                    participants: 23,
                    date: "",
                    //status: "Encerrado",
                  ),
                  ClubPesquisa(
                    title: "Kscerato",
                    category: "Mira quente",
                    participants: 23,
                    date: "",
                    //status: "Encerrado",
                  ),
                  ClubPesquisa(
                    title: "Yuri",
                    category: "Enterna Promessa",
                    participants: 23,
                    date: "",
                    //status: "Encerrado",
                  ),
                  ClubPesquisa(
                    title: "Sidde",
                    category: "cabecao",
                    participants: 23,
                    date: "",
                    //status: "Encerrado",
                  ),
                ],
              ),
            ),
          ],
        ),
      ),

      bottomNavigationBar: BooklyRodape(selectedTab: NavTab.clubes),
    );
  }
}
