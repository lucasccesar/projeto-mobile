import 'package:flutter/material.dart';

/// Controla o tema (claro/escuro) do app inteiro.
///
/// Use [themeNotifier] no [MaterialApp] com um [ValueListenableBuilder] e
/// chame [toggleTheme] para alternar entre os modos.
final ValueNotifier<ThemeMode> themeNotifier = ValueNotifier<ThemeMode>(
  ThemeMode.light,
);

/// Alterna entre o modo claro e o modo escuro.
void toggleTheme() {
  themeNotifier.value = themeNotifier.value == ThemeMode.dark
      ? ThemeMode.light
      : ThemeMode.dark;
}

/// Indica se o modo escuro está ativo no momento.
bool get isDarkMode => themeNotifier.value == ThemeMode.dark;
