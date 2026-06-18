class Usuario {
  final String id;
  final String nome;
  final String email;
  final DateTime? nascimento;
  final String? tipo;
  final int? avatarId;

  const Usuario({
    required this.id,
    required this.nome,
    required this.email,
    this.nascimento,
    this.tipo,
    this.avatarId,
  });

  bool get isAdmin {
    final role = tipo?.trim().toUpperCase();
    return role == 'ADMINISTRATOR' || role == 'ROLE_ADMINISTRATOR';
  }

  factory Usuario.fromJson(Map<String, dynamic> json) {
    final tipo =
        json['type']?.toString() ??
        json['userType']?.toString() ??
        json['role']?.toString();

    return Usuario(
      id: json['id']?.toString() ?? '',
      nome: json['name']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      nascimento: _parseData(json['birthday']),
      tipo: (tipo != null && tipo.isNotEmpty) ? tipo : null,
      avatarId: json['avatarId'] as int?,
    );
  }

  Map<String, dynamic> toJson() => {
        'name': nome,
        'email': email,
        if (nascimento != null) 'birthday': _formatData(nascimento!),
        if (tipo != null) 'type': tipo,
        if (avatarId != null) 'avatarId': avatarId,
      };

  Usuario copyWith({
    String? id,
    String? nome,
    String? email,
    DateTime? nascimento,
    String? tipo,
    int? avatarId,
  }) {
    return Usuario(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      email: email ?? this.email,
      nascimento: nascimento ?? this.nascimento,
      tipo: tipo ?? this.tipo,
      avatarId: avatarId ?? this.avatarId,
    );
  }

  static DateTime? _parseData(dynamic valor) {
    if (valor == null) return null;
    if (valor is DateTime) return valor;
    return DateTime.tryParse(valor.toString());
  }

  static String _formatData(DateTime data) {
    return '${data.year.toString().padLeft(4, '0')}-'
        '${data.month.toString().padLeft(2, '0')}-'
        '${data.day.toString().padLeft(2, '0')}';
  }
}