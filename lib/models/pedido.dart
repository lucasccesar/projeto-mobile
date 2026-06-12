import 'package:projeto_mobile/models/book.dart';

class Pedido {
  final String id;
  final DateTime data;
  final List<Book> livros;
  final String status;
  final double? _total;

  const Pedido({
    required this.id,
    required this.data,
    required this.livros,
    required this.status,
    double? total,
  }) : _total = total;

  /// Usa o valor armazenado (totalValuation do back); se ausente, soma os livros.
  double get total => _total ?? livros.fold(0.0, (s, b) => s + b.price);
  int get totalLivros => livros.length;
}
