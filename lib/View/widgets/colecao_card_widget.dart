import 'package:flutter/material.dart';

class ColecaoCardWidget extends StatelessWidget {
  final String emoji;
  final Color emojiBackgroundColor;
  final String nome;
  final int quantidadeLivros;
  final Color corQuantidade;
  final VoidCallback? onTap;

  const ColecaoCardWidget({
    super.key,
    required this.emoji,
    required this.emojiBackgroundColor,
    required this.nome,
    required this.quantidadeLivros,
    required this.corQuantidade,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: Theme.of(context).colorScheme.secondary.withOpacity(0.15),
            width: 1,
          ),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: Offset(0, 1),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: emojiBackgroundColor.withOpacity(0.094),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Text(
                  emoji,
                  style: const TextStyle(fontSize: 20),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              nome,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.tertiary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '$quantidadeLivros livros',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: corQuantidade,
              ),
            ),
          ],
        ),
      ),
    );
  }
}