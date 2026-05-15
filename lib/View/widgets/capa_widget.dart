import 'package:flutter/material.dart';

class CapaWidget extends StatelessWidget {
  final Color cor;
  final double largura;
  final double altura;

  const CapaWidget({
    super.key,
    required this.cor,
    this.largura = 52,
    this.altura = 72,
  });

  @override
  Widget build(BuildContext context) {
    final double iconSize = (largura * 0.50).clamp(20.0, 44.0);
    return Container(
      width: largura,
      height: altura,
      decoration: BoxDecoration(
        color: cor.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(8),
      ),
      alignment: Alignment.center,
      child: Icon(Icons.menu_book_rounded, color: cor, size: iconSize),
    );
  }
}
