import 'package:flutter/material.dart';

class ThemeLight {
  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme(
      brightness: Brightness.light,
      primary: Colors.white,
      onPrimary: Color(0xFFFFFDF7),
      //secondary: Color(0xFFF5F0E6),
      secondary: Color(0xFFF5F1EB),
      onSecondary: Colors.black,
      tertiary: Color(0xFF5A4632),
      surface: Colors.white,
      onSurface: Colors.black,
      error: Colors.red,
      onError: Colors.white,
    ),
    scaffoldBackgroundColor: Colors.white,
  );
}