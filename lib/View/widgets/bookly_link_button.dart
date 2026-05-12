import 'package:flutter/material.dart';

/// Botão de texto sutil usado nas páginas de autenticação.
/// Passe [icone] para exibir um ícone à esquerda do label (ex: seta de voltar).
class BooklyLinkButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final IconData? icone;

  const BooklyLinkButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icone,
  });

  static const _cor = Color(0xFF5A5A50);
  static const _textStyle = TextStyle(color: _cor, fontSize: 13);
  static final _buttonStyle = TextButton.styleFrom(
    padding: EdgeInsets.zero,
    minimumSize: Size.zero,
    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
  );

  @override
  Widget build(BuildContext context) {
    if (icone != null) {
      return TextButton.icon(
        onPressed: onPressed,
        style: _buttonStyle,
        icon: Icon(icone, size: 14, color: _cor),
        label: Text(label, style: _textStyle),
      );
    }
    return TextButton(
      onPressed: onPressed,
      style: _buttonStyle,
      child: Text(label, style: _textStyle),
    );
  }
}
