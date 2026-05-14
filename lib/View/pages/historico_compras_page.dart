import 'package:flutter/material.dart';
import 'package:projeto_mobile/config/app_colors.dart';
import 'package:projeto_mobile/models/book.dart';
import 'package:projeto_mobile/models/pedido.dart';
import 'package:projeto_mobile/View/widgets/bookly_appbar_widget.dart';
import 'package:projeto_mobile/View/widgets/bookly_capa_widget.dart';

class HistoricoComprasPage extends StatelessWidget {
  const HistoricoComprasPage({super.key});

  static final List<Pedido> _pedidos = [
    Pedido(
      id: '2041',
      data: DateTime(2026, 4, 20),
      status: 'Entregue',
      livros: [
        const Book(
          id: 'b1',
          title: 'O Senhor dos Anéis',
          author: 'J.R.R. Tolkien',
          genre: 'Fantasia',
          rating: 4.9,
          price: 89.90,
        ),
        const Book(
          id: 'b2',
          title: 'Duna',
          author: 'Frank Herbert',
          genre: 'Ficção Científica',
          rating: 4.8,
          price: 99.90,
        ),
      ],
    ),
    Pedido(
      id: '1988',
      data: DateTime(2026, 4, 5),
      status: 'Entregue',
      livros: [
        const Book(
          id: 'b3',
          title: '1984',
          author: 'George Orwell',
          genre: 'Distopia',
          rating: 4.7,
          price: 59.90,
        ),
      ],
    ),
    Pedido(
      id: '1754',
      data: DateTime(2026, 3, 12),
      status: 'Entregue',
      livros: [
        const Book(
          id: 'b4',
          title: 'Fundação',
          author: 'Isaac Asimov',
          genre: 'Ficção Científica',
          rating: 4.8,
          price: 74.90,
        ),
        const Book(
          id: 'b5',
          title: 'Dom Quixote',
          author: 'Cervantes',
          genre: 'Clássico',
          rating: 4.6,
          price: 59.90,
        ),
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final totalLivros = _pedidos.fold(0, (s, p) => s + p.totalLivros);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F0E8),
      appBar: BooklyAppBar(
        title: 'Histórico de Compras',
        corDoTexto: AppColors.compra,
        iconeMenu: false,
        iconeSeta: true,
        iconeCarrinho: false,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 4),
            child: Text(
              '$totalLivros livros comprados',
              style: const TextStyle(fontSize: 13, color: Color(0xFF888888)),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.only(bottom: 20),
              itemCount: _pedidos.length,
              itemBuilder: (_, i) => _PedidoCard(pedido: _pedidos[i]),
            ),
          ),
        ],
      ),
    );
  }
}

class _PedidoCard extends StatelessWidget {
  final Pedido pedido;
  const _PedidoCard({required this.pedido});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
            child: Row(
              children: [
                Text(
                  '#${pedido.id}',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF2D2D2D),
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  _formatarData(pedido.data),
                  style: const TextStyle(fontSize: 12, color: Color(0xFF888888)),
                ),
                const Spacer(),
                _StatusBadge(status: pedido.status),
              ],
            ),
          ),
          const Divider(height: 1, color: Color(0xFFF0EBE3)),
          ...pedido.livros.map((livro) => _LivroItem(livro: livro)),
          const Divider(height: 1, color: Color(0xFFF0EBE3)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total',
                  style: TextStyle(fontSize: 13, color: Color(0xFF888888)),
                ),
                Text(
                  'R\$${pedido.total.toStringAsFixed(2).replaceAll('.', ',')}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.compra,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatarData(DateTime data) {
    const meses = [
      'Jan', 'Fev', 'Mar', 'Abr', 'Mai', 'Jun',
      'Jul', 'Ago', 'Set', 'Out', 'Nov', 'Dez',
    ];
    return '${data.day} ${meses[data.month - 1]} ${data.year}';
  }
}

class _StatusBadge extends StatelessWidget {
  final String status;
  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.confirmar.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status,
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: AppColors.confirmar,
        ),
      ),
    );
  }
}

class _LivroItem extends StatelessWidget {
  final Book livro;
  const _LivroItem({required this.livro});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          const BooklyCapaWidget(cor: AppColors.compra, largura: 48, altura: 64),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  livro.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF2D2D2D),
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  livro.author,
                  style: const TextStyle(fontSize: 11, color: Color(0xFF888888)),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(
            'R\$${livro.price.toStringAsFixed(2).replaceAll('.', ',')}',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: Color(0xFF2D2D2D),
            ),
          ),
        ],
      ),
    );
  }
}

