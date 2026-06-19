class Usuario {
  final String id;
  final String nome;
  final String email;
  final String? tipo;
  final int? avatarId;

  const Usuario({
    required this.id,
    required this.nome,
    required this.email,
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
      tipo: (tipo != null && tipo.isNotEmpty) ? tipo : null,
      avatarId: json['avatarId'] as int?,
    );
  }

  Map<String, dynamic> toJson() => {
        'name': nome,
        'email': email,
        if (tipo != null) 'type': tipo,
        if (avatarId != null) 'avatarId': avatarId,
      };

  Usuario copyWith({
    String? id,
    String? nome,
    String? email,
    String? tipo,
    int? avatarId,
  }) {
    return Usuario(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      email: email ?? this.email,
      tipo: tipo ?? this.tipo,
      avatarId: avatarId ?? this.avatarId,
    );
  }
}