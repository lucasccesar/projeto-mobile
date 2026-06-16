import 'package:flutter/material.dart';
import 'package:projeto_mobile/config/app_colors.dart';
import 'package:projeto_mobile/View/widgets/botao_remover_widget.dart';
import 'package:projeto_mobile/View/widgets/capa_widget.dart';

class ColecaoItemWidget extends StatelessWidget {
  final String titulo;
  final String autor;
  final String genero;
  final double avaliacao;
  final String preco;
  final VoidCallback? onTap;
  final VoidCallback? onRemover;

  const ColecaoItemWidget({
    super.key,
    required this.titulo,
    required this.autor,
    required this.genero,
    required this.avaliacao,
    required this.preco,
    this.onTap,
    this.onRemover,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Theme.of(context).colorScheme.secondary,
            width: 0.8,
          ),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CapaWidget(cor: AppColors.colecao, largura: 52, altura: 76),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    titulo,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.tertiary,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.person_outline,
                        color: AppColors.colecao,
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          autor,
                          style: TextStyle(
                            fontSize: 13,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.label,
                        color: const Color(0xFFD2B48C),
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          genero,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: AppColors.colecao,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(
                        Icons.star_rounded,
                        color: AppColors.colecao,
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        avaliacao.toString(),
                        style: TextStyle(
                          fontSize: 13,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        preco,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: AppColors.colecao,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            if (onRemover != null) ...[
              const SizedBox(width: 12),
              BotaoRemover(
                onRemover: onRemover!,
                cor: const Color(0xFFE57373),
              ),
            ],
          ],
        ),
      ),
    );
  }
}