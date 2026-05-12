import 'package:flutter/material.dart';
import 'package:projeto_mobile/config/app_colors.dart';

class ClubeHomeWidget extends StatelessWidget {
  const ClubeHomeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Card do livro
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                border: Border.all(
                  color: Theme.of(context).colorScheme.tertiary.withOpacity(0.208),
                  style: BorderStyle.solid,
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(14),
              ),
              child:
               Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Capa do livro
                  Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Container(
                      width: 70,
                      height: 98,
                      decoration: BoxDecoration(
                        color: Color.lerp(AppColors.clube, Colors.white, 0.75),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        Icons.book_outlined,
                        color: AppColors.clube,
                        size: 36,
                      ),
                    ),
                  ),
      
                   SizedBox(width: 14),
      
                  // Informações do livro
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Título
                        Text(
                          'Título do Livro',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.tertiary,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
      
                         SizedBox(height: 2),
      
                        // Autor
                        Text(
                          'Autor do Livro',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.tertiary,
                            fontSize: 15,
                          ),
                        ),
      
                         SizedBox(height: 8),
      
                        // Tag de gênero
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.clube.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            'Aventura', // TODO: dinâmico
                            style: TextStyle(
                              color: AppColors.clube,
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
      
                         SizedBox(height: 8),
      
                        // Período de leitura
                        Row(
                          children: [
                            Icon(Icons.calendar_today_outlined, size: 13, color: Theme.of(context).colorScheme.tertiary),
                            SizedBox(width: 4),
                            Text(
                              '14/04/2026 – 29/04/2026', // TODO: variavel
                              style: TextStyle(
                                color: Theme.of(context)
                                    .colorScheme
                                    .tertiary,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
      
                        SizedBox(height: 4),
      
                        // Avaliação
                        Row(
                          children: [
                           Icon(Icons.star, color: AppColors.clube, size: 15),
                           SizedBox(width: 4),
                            Text(
                              '9.5 (3 avaliações)', // TODO: variavel
                              style: TextStyle(
                                color: Theme.of(context)
                                    .colorScheme
                                    .tertiary,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
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