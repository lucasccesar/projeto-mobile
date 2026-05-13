import 'package:flutter/material.dart';

class ClubeMembro extends StatelessWidget {
  final String nome;
  final String cargo;
  final bool mostrarRemover;
  final VoidCallback? onRemover;

  const ClubeMembro({
    super.key,
    required this.nome,
    required this.cargo,
    this.mostrarRemover = false,
    this.onRemover,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Avatar com ícone
        CircleAvatar(
          radius: 22,
          backgroundColor: Colors.grey.shade200,
          child: const Icon(Icons.person, color: Colors.grey),
        ),

        const SizedBox(width: 12),

        // Nome e cargo
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                nome,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                cargo,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade500,
                ),
              ),
            ],
          ),
        ),

        // Botão remover (só aparece se mostrarRemover = true)
        if (mostrarRemover)
          TextButton(
            onPressed: onRemover,
            child: const Text(
              'Remover',
              style: TextStyle(
                color: Colors.red,
                fontSize: 13,
              ),
            ),
          ),
      ],
    );
  }
}