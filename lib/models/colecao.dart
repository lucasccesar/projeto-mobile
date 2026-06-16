import 'package:projeto_mobile/models/book.dart';

class Colecao {
  final String id;
  final String name;
  final String description;
  final List<Book> books;

  const Colecao({
    required this.id,
    required this.name,
    required this.description,
    this.books = const [],
  });

  factory Colecao.fromJson(Map<String, dynamic> json) {
    final rawBooks = json['books'] as List<dynamic>? ?? [];
    return Colecao(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      books: rawBooks.map((b) => Book.fromJson(b as Map<String, dynamic>)).toList(),
    );
  }

  Colecao copyWith({String? id, String? name, String? description, List<Book>? books}) {
    return Colecao(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      books: books ?? this.books,
    );
  }
}