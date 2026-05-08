import 'package:flutter/material.dart';

class BooklyPrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const BooklyPrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
  });

  static const Color _verde = Color(0xFF6B8F6E);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: _verde,
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
