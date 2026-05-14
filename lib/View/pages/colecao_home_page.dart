import 'package:flutter/material.dart';
import 'package:projeto_mobile/config/app_colors.dart';
import 'package:projeto_mobile/View/widgets/bookly_appbar_widget.dart';
import 'package:projeto_mobile/View/widgets/bookly_search_bar.dart';
import 'package:projeto_mobile/View/widgets/sidebar_widget.dart';
import 'package:projeto_mobile/View/widgets/colecao_item_widget.dart';
import 'package:projeto_mobile/View/widgets/rodape_widget.dart';
import 'package:projeto_mobile/View/pages/colecao_editar_page.dart';
import 'package:projeto_mobile/View/pages/colecao_adicionar_livro_page.dart'; // ← ADICIONADO

class ColecaoHomePage extends StatelessWidget {
  const ColecaoHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const SidebarWidget(),
      appBar: BooklyAppBar(
        title: 'Livros Lidos em 2026',
        corDoTexto: AppColors.colecao,
        iconeMenu: false,
        iconeSeta: true,
        iconeCarrinho: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: BooklySearchBar(hintText: 'Título, autor ou gênero...'),
                ),
                const SizedBox(width: 8),
                ElevatedButton.icon(
                  // ← MODIFICADO: navega para ColecaoAdicionarLivroPage
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const ColecaoAdicionarLivroPage(),
                      ),
                    );
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
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const ColecaoEditarPage(
                          nomeInicial: 'Livros Lidos em 2026',
                          descricaoInicial: '',
                        ),
                      ),
                    );
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
                    onTap: () {},
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
      bottomNavigationBar: const BooklyRodape(),
    );
  }
}