import 'package:flutter/material.dart';
import 'capa_widget.dart';
import 'checkbox_widget.dart';
import 'botao_remover_widget.dart';

/// Row de livro reutilizável para listas de coleção.
///
/// Modo checkbox: passe [selecionado] + [onToggle] → mostra checkbox e torna a linha tocável.
/// Modo remover: passe [onRemover] → mostra botão vermelho de remoção.
class LivroRow extends StatelessWidget {
  final String titulo;
  final String autor;
  final Color cor;

  // Modo checkbox
  final bool? selecionado;
  final VoidCallback? onToggle;

  // Modo remover
  final VoidCallback? onRemover;

  const LivroRow({
    super.key,
    required this.titulo,
    required this.autor,
    required this.cor,
    this.selecionado,
    this.onToggle,
    this.onRemover,
  });

  @override
  Widget build(BuildContext context) {
    final content = Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CapaWidget(cor: cor, largura: 46, altura: 62),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  titulo,
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  autor,
                  style: TextStyle(
                    fontSize: 11,
                    color: Theme.of(context).colorScheme.tertiary,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          if (onRemover != null)
            BotaoRemover(
              onRemover: onRemover!,
              cor: const Color(0xFFE57373),
            )
          else if (selecionado != null)
            BooklyCheckbox(selecionado: selecionado!),
        ],
      ),
    );

    if (onToggle != null) {
      return GestureDetector(
        onTap: onToggle,
        behavior: HitTestBehavior.opaque,
        child: content,
      );
    }
    return content;
  }
}
