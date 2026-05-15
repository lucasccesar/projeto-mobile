import 'package:flutter/material.dart';

class BooklySearchBar extends StatelessWidget {
  final TextEditingController? controller;
  final String hintText;
  final ValueChanged<String>? onChanged;
  final Color? fillColor;
  final Color? focusedBorderColor;
  final double focusedBorderWidth;
  final bool showEnabledBorder;

  const BooklySearchBar({
    super.key,
    this.controller,
    required this.hintText,
    this.onChanged,
    this.fillColor,
    this.focusedBorderColor,
    this.focusedBorderWidth = 1.0,
    this.showEnabledBorder = true,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final resolvedFill = fillColor ?? scheme.secondary;
    final enabledColor = Color.lerp(scheme.tertiary, scheme.primary, 0.7)!;
    final resolvedFocusedColor = focusedBorderColor ?? enabledColor;

    return TextField(
      controller: controller,
      onChanged: null,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: scheme.tertiary, fontSize: 14),
        prefixIcon: Icon(Icons.search, color: scheme.tertiary, size: 20),
        filled: true,
        fillColor: resolvedFill,
        contentPadding: const EdgeInsets.symmetric(vertical: 0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: showEnabledBorder
              ? BorderSide(color: enabledColor, width: 1.0)
              : BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(
            color: resolvedFocusedColor,
            width: focusedBorderWidth,
          ),
        ),
      ),
    );
  }
}
