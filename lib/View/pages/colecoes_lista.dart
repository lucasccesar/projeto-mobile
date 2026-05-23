import 'package:flutter/material.dart';
import 'package:projeto_mobile/View/widgets/appbar_widget.dart';
import 'package:projeto_mobile/View/widgets/rodape_widget.dart';
import 'package:projeto_mobile/View/widgets/sidebar_widget.dart';
import 'package:projeto_mobile/View/widgets/colecao_card_widget.dart';
import 'package:projeto_mobile/View/pages/colecao_home_page.dart';
import 'package:projeto_mobile/View/pages/colecao_criar_page.dart';
import 'package:projeto_mobile/View/pages/catalogo_page.dart';
import 'package:projeto_mobile/View/pages/clubes_page.dart';
import 'package:projeto_mobile/config/app_colors.dart';

class ColecoesListaPage extends StatelessWidget {
  const ColecoesListaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: SidebarWidget(),
      appBar: BooklyAppBar(
        title: 'Coleções',
        corDoTexto: AppColors.colecao,
        iconeMenu: true,
        iconeSeta: false,
        iconeCarrinho: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton.icon(
                  // ← MODIFICADO: navega para ColecaoCriarPage
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const ColecaoCriarPage()),
                    );
                  },
                  icon: const Icon(Icons.add, size: 16),
                  label: const Text('Nova Coleção'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.colecao,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 8,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(99),
                    ),
                    textStyle: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ColecaoCardWidget(
                    emoji: '📚',
                    emojiBackgroundColor: const Color(0xFF4A7FA5),
                    nome: 'Para Ler',
                    quantidadeLivros: 14,
                    corQuantidade: AppColors.clube,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const ColecaoHomePage()),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ColecaoCardWidget(
                    emoji: '✅',
                    emojiBackgroundColor: const Color(0xFF7A8C63),
                    nome: 'Lidos em 2025',
                    quantidadeLivros: 22,
                    corQuantidade: AppColors.catalogo,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const ColecaoHomePage()),
                      );
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: ColecaoCardWidget(
                    emoji: '⭐',
                    emojiBackgroundColor: AppColors.colecao,
                    nome: 'Favoritos',
                    quantidadeLivros: 7,
                    corQuantidade: AppColors.colecao,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const ColecaoHomePage()),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ColecaoCardWidget(
                    emoji: '🛒',
                    emojiBackgroundColor: AppColors.compra,
                    nome: 'Lista de Compras',
                    quantidadeLivros: 5,
                    corQuantidade: AppColors.compra,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const ColecaoHomePage()),
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: const Rodape(
        //selectedTab: NavTab.leitura,
      ),
    );
  }
}