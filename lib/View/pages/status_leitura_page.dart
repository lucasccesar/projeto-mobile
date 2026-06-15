import 'package:flutter/material.dart';
import 'package:projeto_mobile/models/book.dart';
import 'package:projeto_mobile/View/widgets/appbar_widget.dart';
import 'package:projeto_mobile/View/widgets/livro_card_widget.dart';
import 'package:projeto_mobile/View/widgets/rodape_widget.dart';
import 'package:projeto_mobile/View/widgets/sidebar_widget.dart';

class StatusLeituraPage extends StatelessWidget {
  const StatusLeituraPage({super.key});

  static const _lendoAgora = [
    Book(
      id: 'l1',
      title: 'Duna',
      author: 'Frank Herbert',
      genre: 'Ficção Científica',
      rating: 9.1,
      price: 99.90,
    ),
  ];

  static const _queroLer = [
    Book(
      id: 'l2',
      title: 'O Grande Gatsby',
      author: 'F. Scott Fitzgerald',
      genre: 'Clássico',
      rating: 8.7,
      price: 54.90,
    ),
    Book(
      id: 'l3',
      title: 'Dom Quixote',
      author: 'Miguel de Cervantes',
      genre: 'Clássico',
      rating: 8.9,
      price: 64.90,
    ),
  ];

  static const _jaLi = [
    Book(
      id: 'l4',
      title: '1984',
      author: 'George Orwell',
      genre: 'Distopia',
      rating: 9.3,
      price: 59.90,
    ),
    Book(
      id: 'l5',
      title: 'Crime e Castigo',
      author: 'Fiódor Dostoiévski',
      genre: 'Romance Psicológico',
      rating: 9.2,
      price: 69.90,
    ),
    Book(
      id: 'l6',
      title: 'A Revolução dos Bichos',
      author: 'George Orwell',
      genre: 'Fábula',
      rating: 9.0,
      price: 49.90,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      drawer: const SidebarWidget(),
      appBar: BooklyAppBar(
        title: 'Leitura',
        corDoTexto: const Color(0xFF3D9080),
        iconeMenu: true,
        iconeSeta: false,
        iconeCarrinho: false,
      ),
      body: ListView(
        padding: const EdgeInsets.only(top: 16, bottom: 12),
        children: [
          _CabecalhoSecao(
            titulo: 'Lendo agora',
            icone: Icons.auto_stories_outlined,
            corAccent: const Color(0xFF3D9080),
          ),
          ..._lendoAgora.map(
            (l) => _CardComBorda(livro: l, corAccent: const Color(0xFF3D9080)),
          ),
          const SizedBox(height: 8),
          _CabecalhoSecao(
            titulo: 'Quero ler',
            icone: Icons.bookmark_border_rounded,
            corAccent: const Color(0xFF4A7FA5),
          ),
          ..._queroLer.map(
            (l) => _CardComBorda(livro: l, corAccent: const Color(0xFF4A7FA5)),
          ),
          const SizedBox(height: 8),
          _CabecalhoSecao(
            titulo: 'Já li',
            icone: Icons.check_circle_outline_rounded,
            corAccent: const Color(0xFF7A8C63),
          ),
          ..._jaLi.map(
            (l) => _CardComBorda(livro: l, corAccent: const Color(0xFF7A8C63)),
          ),
        ],
      ),
      bottomNavigationBar: const Rodape(
        selectedTab: NavTab.leitura,
      ),
    );
  }
}

class _CabecalhoSecao extends StatelessWidget {
  final String titulo;
  final IconData icone;
  final Color corAccent;

  const _CabecalhoSecao({
    required this.titulo,
    required this.icone,
    required this.corAccent,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
      child: Row(
        children: [
          Icon(icone, size: 17, color: corAccent),
          const SizedBox(width: 7),
          Text(
            titulo,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: corAccent,
            ),
          ),
        ],
      ),
    );
  }
}

class _CardComBorda extends StatelessWidget {
  final Book livro;
  final Color corAccent;

  const _CardComBorda({required this.livro, required this.corAccent});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        LivroCardWidget(livro: livro),
        Positioned(
          left: 16,
          top: 6,
          bottom: 6,
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(12),
              bottomLeft: Radius.circular(12),
            ),
            child: Container(
              width: 3,
              color: corAccent,
            ),
          ),
        ),
      ],
    );
  }
}