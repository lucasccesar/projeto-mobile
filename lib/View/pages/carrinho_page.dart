import 'package:flutter/material.dart';
import 'package:projeto_mobile/View/widgets/primary_button.dart';
import 'package:projeto_mobile/config/app_colors.dart';
import 'package:projeto_mobile/models/book.dart';
import 'package:projeto_mobile/models/carrinho_item.dart';
import 'package:projeto_mobile/View/widgets/appbar_widget.dart';
import 'package:projeto_mobile/View/widgets/carrinho_item_widget.dart';
import 'package:projeto_mobile/View/pages/finalizar_compra_page.dart';

class CarrinhoPage extends StatefulWidget {
  final List<Book> itens;

  const CarrinhoPage({super.key, required this.itens});

  @override
  State<CarrinhoPage> createState() => _CarrinhoPageState();
}

class _CarrinhoPageState extends State<CarrinhoPage> {
  late final List<CarrinhoItem> _itens;

  @override
  void initState() {
    super.initState();
    _itens = widget.itens.map((b) => CarrinhoItem(livro: b)).toList();
  }

  double get _totalPreco => _itens.fold(0.0, (s, i) => s + i.subtotal);
  int get _totalItens => _itens.fold(0, (s, i) => s + i.quantidade);

  void _remover(String livroId) {
    setState(() {
      _itens.removeWhere((i) => i.livro.id == livroId);
      widget.itens.removeWhere((b) => b.id == livroId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F0E8),
      appBar: BooklyAppBar(
        title: 'Carrinho',
        corDoTexto: AppColors.compra,
        iconeMenu: false,
        iconeSeta: true,
        iconeCarrinho: false,
      ),
      body: _itens.isEmpty
          ? const CarrinhoVazio()
          : ListView.builder(
              padding: const EdgeInsets.only(top: 8, bottom: 8),
              itemCount: _itens.length,
              itemBuilder: (context, index) {
                final item = _itens[index];
                return CarrinhoItemWidget(
                  item: item,
                  onRemover: () => _remover(item.livro.id),
                );
              },
            ),
      bottomNavigationBar: CarrinhoRodape(
        totalItens: _totalItens,
        totalPreco: _totalPreco,
        onFinalizar: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => FinalizarCompraPage(
              itens: _itens,
              onCompraConcluida: () {
                setState(() {
                  _itens.clear();
                  widget.itens.clear();
                });
              },
            ),
          ),
        ),
      ),
    );
  }
}

class CarrinhoVazio extends StatelessWidget {
  const CarrinhoVazio({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.shopping_cart_outlined,
            size: 72,
            color: AppColors.compra.withValues(alpha: 0.3),
          ),
          const SizedBox(height: 16),
          Text(
            'Seu carrinho está vazio',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.compra.withValues(alpha: 0.6),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Adicione livros do catálogo para comprar',
            style: TextStyle(
              fontSize: 13,
              color: Color(0xFF999999),
            ),
          ),
        ],
      ),
    );
  }
}

class CarrinhoRodape extends StatelessWidget {
  final int totalItens;
  final double totalPreco;
  final VoidCallback onFinalizar;

  const CarrinhoRodape({
    super.key,
    required this.totalItens,
    required this.totalPreco,
    required this.onFinalizar,
  });

  @override
  Widget build(BuildContext context) {
    final label = totalItens == 1 ? 'item' : 'itens';
    final precoFormatado = 'R\$${totalPreco.toStringAsFixed(2).replaceAll('.', ',')}';

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, -2)),
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
                Text(
                  'Total: $totalItens $label',
                  style: const TextStyle(fontSize: 13, color: Color(0xFF666666)),
                ),
                Text(
                  precoFormatado,
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
              label: 'Finalizar Compra',
              onPressed: totalItens > 0 ? onFinalizar : null,
              cor: AppColors.compra,
            ),
          ],
        ),
      ),
    );
  }
}

