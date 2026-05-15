import 'package:flutter/material.dart';

class BooklyCheckbox extends StatelessWidget {
  final bool selecionado;

  const BooklyCheckbox({super.key, required this.selecionado});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        color: selecionado ? const Color(0xFF6B8F6E) : Colors.transparent,
        borderRadius: BorderRadius.circular(5),
        border: Border.all(
          color: selecionado
              ? const Color(0xFF6B8F6E)
              : Theme.of(context).colorScheme.tertiary.withValues(alpha: 0.4),
          width: 1.5,
        ),
      ),
      child: selecionado
          ? const Icon(Icons.check, color: Colors.white, size: 13)
          : null,
    );
  }
}
