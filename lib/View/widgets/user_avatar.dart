import 'package:flutter/material.dart';

class UserAvatar extends StatelessWidget {
  final int? avatarId;
  final String nome;
  final double radius;
  final Color backgroundColor;
  final Color textColor;

  const UserAvatar({
    super.key,
    required this.avatarId,
    required this.nome,
    this.radius = 17,
    required this.backgroundColor,
    required this.textColor,
  });

  String get _iniciais {
    final partes = nome.trim().split(RegExp(r'\s+'));
    if (partes.length >= 2) {
      return '${partes[0][0]}${partes[1][0]}'.toUpperCase();
    }
    if (nome.length >= 2) return nome.substring(0, 2).toUpperCase();
    if (nome.isNotEmpty) return nome[0].toUpperCase();
    return 'U';
  }

  @override
  Widget build(BuildContext context) {
    if (avatarId != null && avatarId! >= 1 && avatarId! <= 5) {
      return CircleAvatar(
        radius: radius,
        backgroundImage: AssetImage('assets/images/avatars/pfp$avatarId.png'),
      );
    }

    return CircleAvatar(
      radius: radius,
      backgroundColor: backgroundColor,
      child: Text(
        _iniciais,
        style: TextStyle(
          fontSize: radius * 0.65,
          fontWeight: FontWeight.w700,
          color: textColor,
        ),
      ),
    );
  }
}