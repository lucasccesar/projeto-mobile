import 'package:flutter/material.dart';
import 'package:projeto_mobile/config/app_colors.dart';

class BooklyCardSection extends StatelessWidget {
  final Widget child;

  const BooklyCardSection({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 24),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).colorScheme.tertiary.withValues(alpha: 0.15),
          width: 1,
        ),
      ),
      child: child,
    );
  }
}

class BooklySectionLabel extends StatelessWidget {
  final String texto;
  final Color cor;

  const BooklySectionLabel({super.key, required this.texto, required this.cor});

  @override
  Widget build(BuildContext context) {
    return Text(
      texto.toUpperCase(),
      style: TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.bold,
        letterSpacing: 0.5,
        color: cor,
      ),
    );
  }
}

/// Botão de ação primária para páginas de coleção (verde, pill, altura fixa).
/// Passe [onPressed] como null para desabilitar com opacidade reduzida.
class BooklyActionButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;

  const BooklyActionButton({super.key, required this.label, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 43,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.confirmar,
          foregroundColor: Colors.white,
          disabledBackgroundColor: AppColors.confirmar.withValues(alpha: 0.45),
          disabledForegroundColor: Colors.white.withValues(alpha: 0.7),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(99),
          ),
        ),
        child: Text(
          label,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
