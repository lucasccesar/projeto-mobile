import 'package:flutter/material.dart';
import 'package:projeto_mobile/View/pages/login.dart';
import 'package:projeto_mobile/config/light_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeLight.lightTheme,
      title: 'BookLy',
      debugShowCheckedModeBanner: false,
      home: const LoginPage(),
    );
  }
}
