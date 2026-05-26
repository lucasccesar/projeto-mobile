class ClubeMensagemModel {
  final String id;
  final String userId;
  final String clubId;
  final String message;
  final DateTime messageDate;

  ClubeMensagemModel({
    required this.id,
    required this.userId,
    required this.clubId,
    required this.message,
    required this.messageDate,
  });

  factory ClubeMensagemModel.fromJson(Map<String, dynamic> json) {
    return ClubeMensagemModel(
      id: json['idClubMessage'],
      userId: json['userId'],
      clubId: json['clubId'],
      message: json['message'],
      messageDate: DateTime.parse(json['messageDate']),
    );
  }
}