import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:projeto_mobile/config/app_colors.dart';

class ClubeMensagemWidget extends StatelessWidget {
  final String autor;
  final String texto;
  final String hora;
  final bool isMe;

  const ClubeMensagemWidget({
    super.key,
    required this.autor,
    required this.texto,
    required this.hora,
    required this.isMe,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      //TODO: ajustar espaco entre mensagens
      padding: EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      child: Column(
        crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [

          // aparecer nome do autor logica
          if (!isMe)
            Text(
              autor,
              style: TextStyle(
                color: AppColors.clube,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),

          // mensagem widget
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: isMe ? AppColors.clube : Theme.of(context).colorScheme.onPrimary,
              border: Border.all(color: isMe ? AppColors.clube : Color.lerp(
                Theme.of(context).colorScheme.tertiary,
                Colors.white,
                0.8,
              )!),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(isMe ? 14 : 2),
                topRight: Radius.circular(isMe ? 2 : 14),
                bottomLeft: Radius.circular(14),
                bottomRight: Radius.circular(14),
              ),
            ),
            child: Text(
              texto,
              style: TextStyle(
                color: isMe ? Colors.white : Theme.of(context).colorScheme.onSurface,
                fontSize: 15,
              ),
            ),
          ),

          // Hora
          Text(
            hora,
            style: TextStyle(
              color: Theme.of(context).colorScheme.tertiary,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}