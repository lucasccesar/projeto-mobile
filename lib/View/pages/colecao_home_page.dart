import 'package:flutter/material.dart';
import 'package:projeto_mobile/config/app_colors.dart';
import 'package:projeto_mobile/View/widgets/bookly_appbar_widget.dart';
import 'package:projeto_mobile/View/widgets/sidebar_widget.dart';
import 'package:projeto_mobile/View/widgets/colecao_item_widget.dart';
import 'package:projeto_mobile/View/widgets/rodape_widget.dart';

class ColecaoHomePage extends StatelessWidget {
  const ColecaoHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const SidebarWidget(),
      appBar: BooklyAppBar(
        title: 'Livros Lidos em 2026',
        corDoTexto: AppColors.colecao,
        iconeMenu: true,
        iconeSeta: false,
        iconeCarrinho: false,
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Título, autor ou gênero...',
                      hintStyle: TextStyle(
                        color: Theme.of(context).colorScheme.tertiary,
                        fontSize: 13,
                      ),
                      prefixIcon: Icon(
                        Icons.search,
                        color: Theme.of(context).colorScheme.tertiary,
                        size: 15,
                      ),
                      filled: true,
                      fillColor: Theme.of(context).colorScheme.secondary,
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 34),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
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

                const SizedBox(width: 8),

                ElevatedButton.icon(
                  onPressed: () {
                  },
                  icon: const Icon(Icons.add, size: 12),
                  label: const Text('Adicionar'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.colecao,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 10),
                    textStyle: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(99),
                    ),
                    elevation: 2,
                  ),
                ),

                const SizedBox(width: 8),

                ElevatedButton.icon(
                  onPressed: () {
                  },
                  icon: const Icon(Icons.edit, size: 12),
                  label: const Text('Editar'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.colecao,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 10),
                    textStyle: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(99),
                    ),
                    elevation: 2,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            Expanded(
              child: ListView(
                children: [
                  ColecaoItemWidget(
                    titulo: 'O Senhor dos Anéis',
                    autor: 'J.R.R. Tolkien',
                    genero: 'Fantasia',
                    avaliacao: 9.8,
                    preco: 'R\$89,90',
                    onTap: () {
                    },
                  ),
                  ColecaoItemWidget(
                    titulo: 'Cem Anos de Solidão',
                    autor: 'Gabriel García Márquez',
                    genero: 'Realismo Mágico',
                    avaliacao: 9.5,
                    preco: 'R\$74,90',
                    onTap: () {},
                  ),
                  ColecaoItemWidget(
                    titulo: '1984',
                    autor: 'George Orwell',
                    genero: 'Distopia',
                    avaliacao: 9.3,
                    preco: 'R\$49,90',
                    onTap: () {},
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const BooklyRodape()
    );
  }
}