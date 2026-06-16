import 'package:projeto_mobile/models/book.dart';

class ReadingStatus {
  final String id;
  final String userId;
  final String status;
  final Book book;

  const ReadingStatus({
    required this.id,
    required this.userId,
    required this.status,
    required this.book,
  });

  factory ReadingStatus.fromJson(Map<String, dynamic> json) {
    return ReadingStatus(
      id: json['id']?.toString() ?? '',
      userId: json['userId']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      book: Book.fromJson(json['book'] ?? {}),
    );
  }

  Map<String, dynamic> toCreateJson({
    required String bookId,
    required String userId,
    required String status,
  }) {
    return {
      'users': {'id': userId},
      'book': {'idBook': bookId},
      'status': status,
    };
  }

  Map<String, dynamic> toUpdateJson(String status) {
    return {
      'status': status,
    };
  }
}