import 'package:flutter/material.dart';
import 'package:projeto_mobile/config/app_colors.dart';
import 'package:projeto_mobile/models/book.dart';
import 'package:projeto_mobile/View/widgets/bookly_appbar_widget.dart';
import 'package:projeto_mobile/View/widgets/bookly_capa_widget.dart';
import 'package:projeto_mobile/View/widgets/rodape_widget.dart';
import 'package:projeto_mobile/View/widgets/sidebar_widget.dart';

class FavoritosPage extends StatefulWidget {
  const FavoritosPage({super.key});

  @override
  State<FavoritosPage> createState() => _FavoritosPageState();
}

class _FavoritosPageState extends State<FavoritosPage> {
  final List<Book> _favoritos = [
    Book(
      id: '1',
      title: 'O Senhor dos Anéis',
      author: 'J.R.R. Tolkien',
      genre: 'Fantasia',
      rating: 9.8,
      price: 89.90,
    ),
    Book(
      id: '3',
      title: '1984',
      author: 'George Orwell',
      genre: 'Distopia',
      rating: 9.3,
      price: 59.90,
    ),
    Book(
      id: '8',
      title: 'Crime e Castigo',
      author: 'Fiódor Dostoiévski',
      genre: 'Romance Psicológico',
      rating: 9.2,
      price: 69.90,
    ),
  ];

  void _removerFavorito(String id) {
    setState(() => _favoritos.removeWhere((l) => l.id == id));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F0E8),
      drawer: const SidebarWidget(),
      appBar: BooklyAppBar(
        title: 'Favoritos',
        corDoTexto: AppColors.favoritos,
        iconeMenu: true,
        iconeSeta: false,
        iconeCarrinho: false,
      ),
      body: _favoritos.isEmpty
          ? const _EmptyFavoritos()
          : ListView.separated(
              padding: const EdgeInsets.symmetric(vertical: 16),
              itemCount: _favoritos.length,
              separatorBuilder: (_, __) => const SizedBox(height: 0),
              itemBuilder: (context, index) {
                return _FavoritoCard(
                  livro: _favoritos[index],
                  onRemover: () => _removerFavorito(_favoritos[index].id),
                );
              },
            ),
      bottomNavigationBar: const BooklyRodape(
        selectedTab: NavTab.favoritos,
      ),
    );
  }
}

class _FavoritoCard extends StatelessWidget {
  final Book livro;
  final VoidCallback onRemover;

  const _FavoritoCard({required this.livro, required this.onRemover});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const BooklyCapaWidget(cor: AppColors.favoritos, largura: 56, altura: 76),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  livro.title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF2D2D2D),
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  livro.author,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF6B6B6B),
                  ),
                ),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.favoritos.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(99),
                  ),
                  child: Text(
                    livro.genre,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: AppColors.favoritos,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      Icons.star_rounded,
                      size: 14,
                      color: AppColors.favoritos,
                    ),
                    const SizedBox(width: 3),
                    Text(
                      livro.rating.toString(),
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF555555),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      'R\$${livro.price.toStringAsFixed(2).replaceAll('.', ',')}',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: AppColors.favoritos,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          GestureDetector(
            onTap: onRemover,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.favoritos.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.favorite_rounded,
                size: 20,
                color: AppColors.favoritos,
              ),
            ),
          ),
        ],
      ),
    );
  }
}


class _EmptyFavoritos extends StatelessWidget {
  const _EmptyFavoritos();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.favorite_border_rounded,
            size: 56,
            color: AppColors.favoritos.withValues(alpha: 0.35),
          ),
          const SizedBox(height: 16),
          const Text(
            'Nenhum favorito ainda',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF5A4631),
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Adicione livros aos seus favoritos\npara encontrá-los aqui.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              color: Color(0xFF8B7355),
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}