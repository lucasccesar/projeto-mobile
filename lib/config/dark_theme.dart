import 'package:flutter/material.dart';

class ThemeDark {
  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: const ColorScheme(
      brightness: Brightness.dark,
      // Fundo de cards/campos e barras escuras
      primary: Color(0xFF1E1E1E),
      // Texto/ícones claros sobre superfícies coloridas/escuras
      onPrimary: Color(0xFFFFFDF7),
      // Barras (appbar, rodapé, drawer)
      secondary: Color(0xFF242424),
      onSecondary: Colors.white,
      // Texto/ícones sobre as barras (tom bege claro p/ manter identidade)
      tertiary: Color(0xFFCBB893),
      // Fundo de campos/cards
      surface: Color(0xFF2A2A2A),
      onSurface: Color(0xFFE8E8E8),
      error: Color(0xFFEF5350),
      onError: Colors.white,
    ),
    scaffoldBackgroundColor: const Color(0xFF121212),
  );
}
