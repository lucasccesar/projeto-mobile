class Book {
  final String id;
  final String title;
  final String author;
  final String genre;
  final double rating;
  final double price;
  final String? synopsis;
  final String? isbn;
  final int? pages;
  final int? year;
  final bool isFavorite;
  final String? coverUrl;

  const Book({
    required this.id,
    required this.title,
    required this.author,
    required this.genre,
    required this.rating,
    required this.price,
    this.synopsis,
    this.isbn,
    this.pages,
    this.year,
    this.isFavorite = false,
    this.coverUrl,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    final authors = json['authors'] as List?;
    final authorName = authors != null && authors.isNotEmpty
        ? (authors.first['name'] ?? '')
        : (json['author'] ?? '');

    return Book(
      id: json['id']?.toString() ?? '',
      title: json['title'] ?? '',
      author: authorName.toString(),
      genre: json['genre'] ?? '',
      rating: (json['rating'] ?? 0).toDouble(),
      price: (json['price'] ?? 0).toDouble(),
      synopsis: json['synopsis'],
      isbn: json['isbn'],
      pages: json['pages'],
      year: json['year'],
      isFavorite: json['isFavorite'] ?? false,
      coverUrl: json['coverUrl'],
    );
  }

  Map<String, dynamic> toJson() => {
        'title': title,
        'genre': genre,
        'price': price,
        'synopsis': synopsis,
        'isbn': isbn,
        'pages': pages,
        'year': year,
      };

  Book copyWith({
    String? id,
    String? title,
    String? author,
    String? genre,
    double? rating,
    double? price,
    String? synopsis,
    String? isbn,
    int? pages,
    int? year,
    bool? isFavorite,
    String? coverUrl,
  }) {
    return Book(
      id: id ?? this.id,
      title: title ?? this.title,
      author: author ?? this.author,
      genre: genre ?? this.genre,
      rating: rating ?? this.rating,
      price: price ?? this.price,
      synopsis: synopsis ?? this.synopsis,
      isbn: isbn ?? this.isbn,
      pages: pages ?? this.pages,
      year: year ?? this.year,
      isFavorite: isFavorite ?? this.isFavorite,
      coverUrl: coverUrl ?? this.coverUrl,
    );
  }
}