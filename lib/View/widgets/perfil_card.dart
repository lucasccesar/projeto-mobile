import 'package:flutter/material.dart';
import 'package:projeto_mobile/View/pages/perfil_editar.dart';
import 'package:projeto_mobile/View/widgets/user_avatar.dart';
import 'package:projeto_mobile/config/app_colors.dart';
import 'package:projeto_mobile/config/token_config.dart';

class PerfilCardWidget extends StatelessWidget {
  final String nome;
  final String email;
  final String clubes;
  final VoidCallback? onEditarVoltar;

  const PerfilCardWidget({
    super.key,
    required this.nome,
    required this.email,
    required this.clubes,
    this.onEditarVoltar,
  });

  @override
  Widget build(BuildContext context) {
    final avatarId = TokenConfig.usuario?.avatarId;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.perfil.withOpacity(0.157),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          UserAvatar(
            avatarId: avatarId,
            nome: nome,
            radius: 30,
            backgroundColor: AppColors.perfil.withOpacity(0.3),
            textColor: AppColors.clube,
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  nome,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.tertiary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  email,
                  style: TextStyle(
                    fontSize: 13,
                    color: Theme.of(context).colorScheme.tertiary,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Icon(
                      Icons.group,
                      size: 15,
                      color: AppColors.clube,
                      fontWeight: FontWeight.bold,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '$clubes clubes',
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.clube,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const PerfilEditar()),
              ).then((_) {
                onEditarVoltar?.call();
              });
            },
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.primary,
              side: BorderSide(
                color: Theme.of(context).colorScheme.tertiary.withOpacity(0.27),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              minimumSize: Size.zero,
            ),
            child: Text(
              'Editar',
              style: TextStyle(
                fontSize: 13,
                color: Theme.of(context).colorScheme.tertiary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}