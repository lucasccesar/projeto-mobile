class Rating {
  final String id;
  final String userId;
  final String bookId;
  final String comment;
  final int ratingValue;
  final DateTime? ratingDate;
  final String? userName;

  const Rating({
    required this.id,
    required this.userId,
    required this.bookId,
    required this.comment,
    required this.ratingValue,
    this.ratingDate,
    this.userName,
  });

  factory Rating.fromJson(Map<String, dynamic> json) {
    return Rating(
      id: json['id']?.toString() ?? '',
      userId: json['user']?.toString() ?? '',
      bookId: json['book']?.toString() ?? '',
      comment: json['comment']?.toString() ?? '',
      ratingValue: (json['ratingValue'] ?? 0) as int,
      ratingDate: _parseDate(json['ratingDate']),
      userName: json['userName']?.toString(),
    );
  }

  static DateTime? _parseDate(dynamic value) {
    if (value == null) return null;
    return DateTime.tryParse(value.toString());
  }
}