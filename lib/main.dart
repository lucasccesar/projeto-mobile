import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:projeto_mobile/View/pages/splash_page.dart';
import 'package:projeto_mobile/config/light_theme.dart';
import 'package:projeto_mobile/config/dark_theme.dart';
import 'package:projeto_mobile/config/theme_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (context, mode, _) {
        return MaterialApp(
          theme: ThemeLight.lightTheme,
          darkTheme: ThemeDark.darkTheme,
          themeMode: mode,
          title: 'BookLy',
          debugShowCheckedModeBanner: false,
          locale: const Locale('pt', 'BR'),
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [Locale('pt', 'BR')],
          home: const SplashPage(),
        );
      },
    );
  }
}