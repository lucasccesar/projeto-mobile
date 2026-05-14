import 'package:flutter/material.dart';

class BooklyPrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final Color? cor;

  const BooklyPrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.cor,
  });

  static const Color _verde = Color(0xFF6B8F6E);

  @override
  Widget build(BuildContext context) {
    final corEfetiva = cor ?? _verde;
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: corEfetiva,
          disabledBackgroundColor: corEfetiva.withValues(alpha: 0.4),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          elevation: 0,
        ),
        child: Text(
          label,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
