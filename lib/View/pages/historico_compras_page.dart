import 'package:flutter/material.dart';
import 'package:projeto_mobile/config/app_colors.dart';
import 'package:projeto_mobile/models/book.dart';
import 'package:projeto_mobile/models/pedido.dart';
import 'package:projeto_mobile/services/compra_service.dart';
import 'package:projeto_mobile/View/widgets/appbar_widget.dart';
import 'package:projeto_mobile/View/widgets/capa_widget.dart';

class HistoricoComprasPage extends StatefulWidget {
  const HistoricoComprasPage({super.key});

  @override
  State<HistoricoComprasPage> createState() => _HistoricoComprasPageState();
}

class _HistoricoComprasPageState extends State<HistoricoComprasPage> {
  final _compraService = CompraService();
  late Future<List<Pedido>> _futuro;

  @override
  void initState() {
    super.initState();
    _futuro = _compraService.buscarHistorico();
  }

  void _recarregar() {
    setState(() {
      _futuro = _compraService.buscarHistorico();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F0E8),
      appBar: BooklyAppBar(
        title: 'Histórico de Compras',
        corDoTexto: AppColors.compra,
        iconeMenu: false,
        iconeSeta: true,
        iconeCarrinho: false,
      ),
      body: FutureBuilder<List<Pedido>>(
        future: _futuro,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.compra),
            );
          }
          if (snapshot.hasError) {
            return _Erro(
              mensagem:
                  snapshot.error.toString().replaceFirst('Exception: ', ''),
              onTentarNovamente: _recarregar,
            );
          }

          final pedidos = snapshot.data ?? [];
          if (pedidos.isEmpty) {
            return const _Vazio();
          }

          final totalLivros = pedidos.fold(0, (s, p) => s + p.totalLivros);

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 4),
                child: Text(
                  '$totalLivros livros comprados',
                  style:
                      const TextStyle(fontSize: 13, color: Color(0xFF888888)),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.only(bottom: 20),
                  itemCount: pedidos.length,
                  itemBuilder: (_, i) => _PedidoCard(pedido: pedidos[i]),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _Vazio extends StatelessWidget {
  const _Vazio();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.receipt_long_outlined,
            size: 72,
            color: AppColors.compra.withValues(alpha: 0.3),
          ),
          const SizedBox(height: 16),
          Text(
            'Nenhuma compra ainda',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.compra.withValues(alpha: 0.6),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Suas compras aparecerão aqui',
            style: TextStyle(fontSize: 13, color: Color(0xFF999999)),
          ),
        ],
      ),
    );
  }
}

class _Erro extends StatelessWidget {
  final String mensagem;
  final VoidCallback onTentarNovamente;

  const _Erro({required this.mensagem, required this.onTentarNovamente});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Color(0xFFBBBBBB)),
            const SizedBox(height: 16),
            Text(
              mensagem,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14, color: Color(0xFF888888)),
            ),
            const SizedBox(height: 16),
            TextButton.icon(
              onPressed: onTentarNovamente,
              icon: const Icon(Icons.refresh, color: AppColors.compra),
              label: const Text(
                'Tentar novamente',
                style: TextStyle(color: AppColors.compra),
              ),
            ),
          ],
        ),
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
                Flexible(
                  child: Text(
                    '#${pedido.id}',
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF2D2D2D),
                    ),
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
          const CapaWidget(cor: AppColors.compra, largura: 48, altura: 64),
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
