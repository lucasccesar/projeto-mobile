import 'package:flutter/material.dart';
import 'package:projeto_mobile/config/app_colors.dart';

class BotaoRemover extends StatelessWidget {
  final VoidCallback onRemover;
  final Color cor;

  const BotaoRemover({
    super.key,
    required this.onRemover,
    this.cor = AppColors.compra,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onRemover,
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          color: cor.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(99),
          border: Border.all(color: cor.withValues(alpha: 0.25)),
        ),
        alignment: Alignment.center,
        child: Icon(Icons.close_rounded, size: 16, color: cor),
      ),
    );
  }
}