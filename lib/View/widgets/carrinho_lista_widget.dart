import 'package:flutter/material.dart';
import 'package:projeto_mobile/models/carrinho_item.dart';
import 'package:projeto_mobile/View/widgets/carrinho_item_widget.dart';

class CarrinhoListaWidget extends StatelessWidget {
  final List<CarrinhoItem> itens;
  final void Function(String livroId) onRemover;

  const CarrinhoListaWidget({
    super.key,
    required this.itens,
    required this.onRemover,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.only(top: 8, bottom: 8),
      itemCount: itens.length,
      itemBuilder: (context, index) {
        final item = itens[index];
        return CarrinhoItemWidget(
          item: item,
          onRemover: () => onRemover(item.livro.id),
        );
      },
    );
  }
}
