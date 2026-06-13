import 'package:flutter/material.dart';

class ClubeMembro extends StatelessWidget {
  final String nome;
  final bool mostrarRemover;
  final VoidCallback? onRemover;

  const ClubeMembro({
    super.key,
    required this.nome,
    this.mostrarRemover = false,
    this.onRemover,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 22,
          backgroundColor: Colors.grey.shade200,
          child: const Icon(Icons.person, color: Colors.grey),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            nome,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        if (mostrarRemover)
          TextButton(
            onPressed: onRemover,
            child: const Text(
              'Remover',
              style: TextStyle(color: Colors.red, fontSize: 13),
            ),
          ),
      ],
    );
  }
}