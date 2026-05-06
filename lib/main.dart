import 'package:flutter/material.dart';
import 'package:projeto_mobile/View/login.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BookLy',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF6B8F6E)),
        fontFamily: 'Roboto',
      ),
      home: const LoginPage(),
    );
  }
}
