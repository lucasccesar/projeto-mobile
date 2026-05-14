import 'package:projeto_mobile/models/book.dart';

class Pedido {
  final String id;
  final DateTime data;
  final List<Book> livros;
  final String status;

  const Pedido({
    required this.id,
    required this.data,
    required this.livros,
    required this.status,
  });

  double get total => livros.fold(0.0, (s, b) => s + b.price);
  int get totalLivros => livros.length;
}
