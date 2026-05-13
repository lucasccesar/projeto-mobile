import 'package:flutter/material.dart';
import 'package:projeto_mobile/config/app_colors.dart';
import 'package:projeto_mobile/models/book.dart';
import 'package:projeto_mobile/View/widgets/bookly_appbar_widget.dart';
import 'package:projeto_mobile/View/widgets/livro_card_widget.dart';
import 'package:projeto_mobile/View/widgets/rodape_widget.dart';
import 'package:projeto_mobile/View/widgets/sidebar_widget.dart';
import 'package:projeto_mobile/View/pages/clubes_page.dart';
import 'package:projeto_mobile/View/pages/colecoes_lista.dart';
import 'package:projeto_mobile/View/pages/adicionar_livro_page.dart';
import 'package:projeto_mobile/View/pages/favoritos_page.dart';

class CatalogoPage extends StatefulWidget {
  const CatalogoPage({super.key});

  @override
  State<CatalogoPage> createState() => _CatalogoPageState();
}

class _CatalogoPageState extends State<CatalogoPage> {
  final _searchController = TextEditingController();

  final _livros = <Book>[
    Book(
      id: '1',
      title: 'O Senhor dos Anéis',
      author: 'J.R.R. Tolkien',
      genre: 'Fantasia',
      rating: 9.8,
      price: 89.90,
    ),
    Book(
      id: '2',
      title: 'Cem Anos de Solidão',
      author: 'Gabriel García Márquez',
      genre: 'Realismo Mágico',
      rating: 9.5,
      price: 74.90,
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
      id: '4',
      title: 'Duna',
      author: 'Frank Herbert',
      genre: 'Ficção Científica',
      rating: 9.1,
      price: 99.90,
    ),
    Book(
      id: '5',
      title: 'Dom Quixote',
      author: 'Miguel de Cervantes',
      genre: 'Clássico',
      rating: 8.9,
      price: 64.90,
    ),
    Book(
      id: '6',
      title: 'A Revolução dos Bichos',
      author: 'George Orwell',
      genre: 'Fábula',
      rating: 9.0,
      price: 49.90,
    ),
    Book(
      id: '7',
      title: 'O Grande Gatsby',
      author: 'F. Scott Fitzgerald',
      genre: 'Clássico',
      rating: 8.7,
      price: 54.90,
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

  List<Book> get _livrosFiltrados {
    final query = _searchController.text.toLowerCase();
    if (query.isEmpty) return _livros;
    return _livros
        .where((l) =>
            l.title.toLowerCase().contains(query) ||
            l.author.toLowerCase().contains(query) ||
            l.genre.toLowerCase().contains(query))
        .toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _navegarParaAdicionar() async {
    final livro = await Navigator.push<Book>(
      context,
      MaterialPageRoute(builder: (_) => const AdicionarLivroPage()),
    );
    if (livro != null) {
      setState(() => _livros.add(livro));
    }
  }

  void _onTabChanged(NavTab tab) {
    if (tab == NavTab.clubes) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const ClubesPage()),
      );
    } else if (tab == NavTab.favoritos) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const FavoritosPage()),
      );
    } else if (tab == NavTab.leitura) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const ColecoesListaPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F0E8),
      drawer: const SidebarWidget(),
      appBar: BooklyAppBar(
        title: 'Catálogo',
        corDoTexto: AppColors.catalogo,
        iconeMenu: true,
        iconeSeta: false,
        iconeCarrinho: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    onChanged: (_) => setState(() {}),
                    decoration: InputDecoration(
                      hintText: 'Título, autor ou gênero...',
                      hintStyle: const TextStyle(
                        color: Color(0xFFAAAAAA),
                        fontSize: 14,
                      ),
                      prefixIcon: const Icon(
                        Icons.search,
                        color: Color(0xFFAAAAAA),
                        size: 20,
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(vertical: 0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide(
                          color: AppColors.catalogo.withValues(alpha: 0.5),
                          width: 1.5,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton.icon(
                  onPressed: _navegarParaAdicionar,
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('Adicionar'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.catalogo,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 12,
                    ),
                    textStyle: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.only(top: 4, bottom: 12),
              itemCount: _livrosFiltrados.length,
              itemBuilder: (context, index) {
                return LivroCardWidget(livro: _livrosFiltrados[index]);
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: const BooklyRodape(
        selectedTab: NavTab.catalogo,
      ),
    );
  }
}