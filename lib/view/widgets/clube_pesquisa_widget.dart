import 'package:flutter/material.dart';
import 'package:projeto_mobile/config/app_colors.dart';

class ClubPesquisa extends StatelessWidget {
  final String title;
  final String category;
  final int participants;
  final String date;
  final VoidCallback? onTap;

  const ClubPesquisa({
    super.key,
    required this.title,
    required this.category,
    required this.participants,
    required this.date,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // inkwell da o efeito de toquezin
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 16),
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Theme.of(context).colorScheme.secondary,
            width: 0.8,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            //Ícone Livro
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: Color.lerp(AppColors.clube, Colors.white, 0.7),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(Icons.auto_stories, color: Color(0xFF4A7FA5)),
            ),

             SizedBox(width: 16),

            //Infos
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.tertiary,
                    ),
                  ),

                  SizedBox(height: 4),

                  //Categoria
                  Row(
                    mainAxisSize:
                        MainAxisSize.min, // Mantém o ícone e texto próximos
                    children: [
                        Icon(
                        Icons.label,
                        color: Color(0xFFD2B48C),
                        size: 18,
                      ),

                      SizedBox(width: 6),

                      Text(
                        category,
                        style: TextStyle(
                          color: AppColors.clube,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),

                   SizedBox(height: 6),

                  Row(
                    children: [
                      // Ícone de participantes
                       Icon(Icons.group, size: 16, color: Theme.of(context).colorScheme.onSurface,),
                       SizedBox(width: 4),
                      Text(
                        "$participants participantes",
                        style:  TextStyle(
                          color: Theme.of(context).colorScheme.onSurface,
                          fontSize: 13,
                        ),
                      ),

                       SizedBox(width: 10),

                      if (date.isNotEmpty) ...[
                         Icon(Icons.calendar_today, size: 16, color: Theme.of(context).colorScheme.onSurface,),
                         SizedBox(width: 4),
                        Text(
                          date,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onSurface,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
