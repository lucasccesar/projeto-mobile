import 'package:flutter/material.dart';
import 'package:projeto_mobile/config/app_colors.dart';

class PerfilButtonWidget extends StatelessWidget {
  final String titulo;
  final Icon icone;
  final VoidCallback onTap;
  final bool sair;

  const PerfilButtonWidget({
    super.key,
    required this.titulo,
    required this.icone,
    required this.onTap,
    this.sair = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          border: Border.all(color: Theme.of(context).colorScheme.tertiary.withOpacity(0.2)),
          borderRadius: BorderRadius.circular(16),
        ),

        child: Row(
          children: [
            //icone
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: AppColors.perfil.withOpacity(0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(child: icone),
            ),
             SizedBox(width: 14),

            Expanded(
              child: Text(
                titulo,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: sair
                      ? Colors.red
                      : Theme.of(context).colorScheme.tertiary,
                ),
              ),
            ),

            //seta logica
            if (!sair)
              Icon(
                Icons.chevron_right,
                color: Colors.grey[400],
              ),
          ],
        ),
      ),
    );
  }
}