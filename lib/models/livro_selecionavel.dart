import 'package:flutter/material.dart';

class LivroSelecionavel {
  final String titulo;
  final String autor;
  final Color cor;
  bool selecionado;

  LivroSelecionavel({
    required this.titulo,
    required this.autor,
    required this.cor,
    this.selecionado = false,
  });
}
