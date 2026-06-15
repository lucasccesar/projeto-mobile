import 'package:flutter/material.dart';

class ThemeLight {
  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: const ColorScheme(
      brightness: Brightness.light,
      // Fundo de cards/campos e barras claras
      primary: Colors.white,
      onPrimary: Color(0xFFFFFDF7),
      // Barras (appbar, rodapé, drawer)
      secondary: Color(0xFFF5F1EB),
      onSecondary: Colors.black,
      // Texto/ícones sobre as barras
      tertiary: Color(0xFF5A4632),
      // Fundo de campos/cards
      surface: Colors.white,
      onSurface: Colors.black,
      error: Colors.red,
      onError: Colors.white,
    ),
    scaffoldBackgroundColor: const Color(0xFFF5F0E8),
  );
}
