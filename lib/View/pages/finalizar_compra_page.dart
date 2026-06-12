import 'package:flutter/material.dart';
import 'package:projeto_mobile/config/app_colors.dart';
import 'package:projeto_mobile/models/carrinho_item.dart';
import 'package:projeto_mobile/services/compra_service.dart';
import 'package:projeto_mobile/View/widgets/appbar_widget.dart';
import 'package:projeto_mobile/View/widgets/primary_button.dart';
import 'package:projeto_mobile/View/pages/historico_compras_page.dart';

class FinalizarCompraPage extends StatefulWidget {
  final List<CarrinhoItem> itens;
  final VoidCallback onCompraConcluida;

  const FinalizarCompraPage({
    super.key,
    required this.itens,
    required this.onCompraConcluida,
  });

  @override
  State<FinalizarCompraPage> createState() => _FinalizarCompraPageState();
}

class _FinalizarCompraPageState extends State<FinalizarCompraPage> {
  final _compraService = CompraService();
  bool _carregando = false;

  double get _total => widget.itens.fold(0.0, (s, i) => s + i.subtotal);

  String _formatarPreco(double valor) =>
      'R\$${valor.toStringAsFixed(2).replaceAll('.', ',')}';

  Future<void> _confirmar() async {
    setState(() => _carregando = true);
    try {
      await _compraService.criarCompra(widget.itens);
      widget.onCompraConcluida();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Compra realizada com sucesso!'),
          backgroundColor: AppColors.confirmar,
        ),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HistoricoComprasPage()),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString().replaceFirst('Exception: ', '')),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) setState(() => _carregando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F0E8),
      appBar: BooklyAppBar(
        title: 'Finalizar Compra',
        corDoTexto: AppColors.compra,
        iconeMenu: false,
        iconeSeta: true,
        iconeCarrinho: false,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(20, 16, 20, 8),
            child: Text(
              'Resumo do pedido',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: Color(0xFF2D2D2D),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.only(bottom: 8),
              itemCount: widget.itens.length,
              itemBuilder: (_, i) => _ResumoItem(
                item: widget.itens[i],
                formatarPreco: _formatarPreco,
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 8,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Total',
                    style: TextStyle(fontSize: 13, color: Color(0xFF666666)),
                  ),
                  Text(
                    _formatarPreco(_total),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppColors.compra,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              PrimaryButton(
                label: _carregando ? 'Confirmando...' : 'Confirmar Compra',
                onPressed: _carregando ? null : _confirmar,
                cor: AppColors.compra,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ResumoItem extends StatelessWidget {
  final CarrinhoItem item;
  final String Function(double) formatarPreco;

  const _ResumoItem({required this.item, required this.formatarPreco});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.livro.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2D2D2D),
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  '${item.quantidade}x  ${formatarPreco(item.livro.price)}',
                  style: const TextStyle(fontSize: 12, color: Color(0xFF888888)),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(
            formatarPreco(item.subtotal),
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
