/// Representa um usuário da aplicação.
///
/// Os dados vêm do backend em `/api/auth/register` (cadastro) e
/// `/api/users/me` (carregar usuário logado). As chaves do JSON são em inglês
/// (`name`, `email`, `birthday`, `type`/`userType`/`role`), enquanto as
/// propriedades aqui seguem o português usado na camada de View.
class Usuario {
  final String id;
  final String nome;
  final String email;
  final DateTime? nascimento;

  /// Tipo/perfil do usuário (ex.: `CLIENT`, `ADMINISTRATOR`).
  final String? tipo;

  const Usuario({
    required this.id,
    required this.nome,
    required this.email,
    this.nascimento,
    this.tipo,
  });

  /// `true` quando o usuário é administrador.
  ///
  /// Mesma regra usada em [TokenConfig.isAdmin].
  bool get isAdmin {
    final role = tipo?.trim().toUpperCase();
    return role == 'ADMINISTRATOR' || role == 'ROLE_ADMINISTRATOR';
  }

  factory Usuario.fromJson(Map<String, dynamic> json) {
    // O back pode mandar o tipo em chaves diferentes (igual ao auth_service).
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
    );
  }

  Map<String, dynamic> toJson() => {
        'name': nome,
        'email': email,
        if (nascimento != null) 'birthday': _formatData(nascimento!),
        if (tipo != null) 'type': tipo,
      };

  Usuario copyWith({
    String? id,
    String? nome,
    String? email,
    DateTime? nascimento,
    String? tipo,
  }) {
    return Usuario(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      email: email ?? this.email,
      nascimento: nascimento ?? this.nascimento,
      tipo: tipo ?? this.tipo,
    );
  }

  /// Converte a data do back (`yyyy-MM-dd`) em [DateTime], tolerando `null`.
  static DateTime? _parseData(dynamic valor) {
    if (valor == null) return null;
    if (valor is DateTime) return valor;
    return DateTime.tryParse(valor.toString());
  }

  /// Formata a data no padrão esperado pelo back (`yyyy-MM-dd`).
  static String _formatData(DateTime data) {
    return '${data.year.toString().padLeft(4, '0')}-'
        '${data.month.toString().padLeft(2, '0')}-'
        '${data.day.toString().padLeft(2, '0')}';
  }
}
