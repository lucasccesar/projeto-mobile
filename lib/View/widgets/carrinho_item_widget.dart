import 'package:flutter/material.dart';
import 'package:projeto_mobile/config/app_colors.dart';
import 'package:projeto_mobile/models/carrinho_item.dart';
import 'package:projeto_mobile/View/widgets/bookly_botao_remover_widget.dart';

class CarrinhoItemWidget extends StatelessWidget {
  final CarrinhoItem item;
  final VoidCallback onRemover;

  const CarrinhoItemWidget({
    super.key,
    required this.item,
    required this.onRemover,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _Capa(),
          const SizedBox(width: 14),
          Expanded(child: _Info(item: item)),
          const SizedBox(width: 8),
          BooklyBotaoRemover(onRemover: onRemover),
        ],
      ),
    );
  }
}

class _Capa extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 58,
      height: 78,
      decoration: BoxDecoration(
        color: AppColors.compra.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(8),
      ),
      alignment: Alignment.center,
      child: const Icon(
        Icons.menu_book_rounded,
        color: AppColors.compra,
        size: 30,
      ),
    );
  }
}

class _Info extends StatelessWidget {
  final CarrinhoItem item;
  const _Info({required this.item});

  @override
  Widget build(BuildContext context) {
    final preco = 'R\$${item.livro.price.toStringAsFixed(2).replaceAll('.', ',')}';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          item.livro.title,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: Color(0xFF2D2D2D),
            height: 1.3,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          item.livro.author,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontSize: 11, color: Color(0xFF888888)),
        ),
        const SizedBox(height: 10),
        Text(
          preco,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: AppColors.compra,
          ),
        ),
      ],
    );
  }
}

