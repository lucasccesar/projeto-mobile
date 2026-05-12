import 'package:flutter/material.dart';
import 'package:projeto_mobile/View/pages/cadastro.dart';
import 'package:projeto_mobile/View/pages/login.dart';
import 'package:projeto_mobile/View/pages/recuperar_senha.dart';
import 'package:projeto_mobile/config/light_theme.dart';
import 'package:projeto_mobile/view/pages/clube_livro_anterior.dart';
import 'package:projeto_mobile/view/pages/clube_livro_proximo.dart';
import 'package:projeto_mobile/view/pages/clubes_page.dart';
import 'package:projeto_mobile/view/pages/colecao_home_page.dart';

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
      home: ColecaoHomePage(),
    );
  }
}
