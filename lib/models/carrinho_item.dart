import 'package:projeto_mobile/models/book.dart';

class CarrinhoItem {
  final Book livro;
  int quantidade;

  CarrinhoItem({required this.livro, this.quantidade = 1});

  double get subtotal => livro.price * quantidade;
}
