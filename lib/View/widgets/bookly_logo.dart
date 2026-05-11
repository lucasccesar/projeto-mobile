import 'package:flutter/material.dart';

class BooklyLogo extends StatelessWidget {
  final String? subtitle;

  const BooklyLogo({super.key, this.subtitle});

  static const Color _verde = Color(0xFF6B8F6E);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 72,
          height: 72,
          decoration: BoxDecoration(
            color: const Color(0xFFE8E2D4),
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Icon(Icons.menu_book_rounded, size: 40, color: _verde),
        ),
        const SizedBox(height: 12),
        const Text(
          'BookLy',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: _verde,
          ),
        ),
        if (subtitle != null) ...[
          const SizedBox(height: 6),
          Text(
            subtitle!,
            style: const TextStyle(fontSize: 14, color: Color(0xFF7A7A6E)),
          ),
        ],
      ],
    );
  }
}
