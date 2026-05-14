import 'package:flutter/material.dart';
import 'package:projeto_mobile/View/pages/perfil_editar.dart';
import 'package:projeto_mobile/config/app_colors.dart';

class PerfilCardWidget extends StatelessWidget {
  final String nome;
  final String email;
  final String livros;
  final String clubes;

  const PerfilCardWidget({
    super.key,
    required this.nome,
    required this.email,
    required this.livros,
    required this.clubes,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.perfil.withOpacity(0.157),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          // Avatar
          CircleAvatar(
            radius: 30,
            backgroundColor: AppColors.perfil.withOpacity(0.3),
            child: Icon(Icons.person, size: 32, color: AppColors.clube),
          ),

          SizedBox(width: 12),

          //infos do usuario
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
                SizedBox(height: 2),
                Text(
                  email,
                  style: TextStyle(
                    fontSize: 13,
                    color: Theme.of(context).colorScheme.tertiary,
                  ),
                ),
                SizedBox(height: 6),
                Row(
                  children: [
                    Icon(
                      Icons.library_books_outlined,
                      size: 15,
                      color: AppColors.catalogo,
                      fontWeight: FontWeight.bold,
                    ),

                    SizedBox(width: 4),

                    Text(
                      '$livros livros',
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.catalogo,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    SizedBox(width: 12),

                    Icon(
                      Icons.group,
                      size: 15,
                      color: AppColors.clube,
                      fontWeight: FontWeight.bold,
                    ),

                    SizedBox(width: 4),

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

          //botao editar
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const PerfilEditar()),
              );
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
