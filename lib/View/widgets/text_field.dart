import 'package:flutter/material.dart';

class BooklyTextField extends StatelessWidget {
  final String? label;
  final String hintText;
  final TextEditingController? controller;
  final TextInputType keyboardType;
  final bool obscureText;
  final Widget? suffixIcon;
  final ValueChanged<String>? onChanged;
  final int maxLines;
  final Color? fillColor;
  final bool showBorder;

  const BooklyTextField({
    super.key,
    this.label,
    required this.hintText,
    this.controller,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.suffixIcon,
    this.onChanged,
    this.maxLines = 1,
    this.fillColor,
    this.showBorder = true,
  });

  @override
  Widget build(BuildContext context) {
    final resolvedFill = fillColor ?? Theme.of(context).colorScheme.surface;
    final borderColor =
        Theme.of(context).colorScheme.tertiary.withValues(alpha: 0.15);

    final border = showBorder
        ? OutlineInputBorder(
            borderRadius: BorderRadius.circular(9),
            borderSide: BorderSide(color: borderColor),
          )
        : OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Text(
            label!,
            style: TextStyle(
              fontSize: showBorder ? 12 : 11,
              fontWeight: FontWeight.bold,
              letterSpacing: showBorder ? 0.4 : 1.0,
              color: showBorder
                  ? Theme.of(context).colorScheme.tertiary
                  : const Color(0xFF4A4A40),
            ),
          ),
          SizedBox(height: showBorder ? 5 : 6),
        ],
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          obscureText: obscureText,
          onChanged: onChanged,
          maxLines: obscureText ? 1 : maxLines,
          style: const TextStyle(fontSize: 14),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(
              color: showBorder
                  ? const Color(0xFF6B7280)
                  : const Color(0xFFAAAAAA),
              fontSize: 14,
            ),
            filled: true,
            fillColor: resolvedFill,
            contentPadding: EdgeInsets.symmetric(
              horizontal: showBorder ? 14 : 16,
              vertical: 12,
            ),
            border: border,
            enabledBorder: border,
            focusedBorder: border,
            suffixIcon: suffixIcon,
          ),
        ),
      ],
    );
  }
}
