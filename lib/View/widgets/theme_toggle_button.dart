import 'package:flutter/material.dart';
import 'package:projeto_mobile/config/theme_controller.dart';

class ThemeToggleButton extends StatelessWidget {
  const ThemeToggleButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (context, mode, _) {
        final escuro = mode == ThemeMode.dark;
        return IconButton(
          tooltip: escuro ? 'Modo claro' : 'Modo escuro',
          icon: Icon(
            escuro ? Icons.light_mode : Icons.dark_mode,
            color: Theme.of(context).colorScheme.tertiary,
          ),
          onPressed: toggleTheme,
        );
      },
    );
  }
}
