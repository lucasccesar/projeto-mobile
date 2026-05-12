import 'package:flutter/material.dart';
import 'package:projeto_mobile/models/book.dart';

class LivroCardWidget extends StatelessWidget {
  final Book livro;
  final VoidCallback? onTap;

  const LivroCardWidget({super.key, required this.livro, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Capa placeholder
            Container(
              width: 56,
              height: 76,
              decoration: BoxDecoration(
                color: const Color(0xFFE8E2D4),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.tablet_android_outlined,
                color: Color(0xFF9E9E9E),
                size: 30,
              ),
            ),
            const SizedBox(width: 14),
            // Informações do livro
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    livro.title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF2D2D2D),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    livro.author,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF6B6B6B),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEEF1E8),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      livro.genre,
                      style: const TextStyle(
                        fontSize: 10,
                        color: Color(0xFF5A6B47),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.star, size: 14, color: Color(0xFFFFC107)),
                      const SizedBox(width: 3),
                      Text(
                        livro.rating.toString(),
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF555555),
                        ),
                      ),
                      const Spacer(),
                      Text(
                        'R\$${livro.price.toStringAsFixed(2).replaceAll('.', ',')}',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF2D2D2D),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
