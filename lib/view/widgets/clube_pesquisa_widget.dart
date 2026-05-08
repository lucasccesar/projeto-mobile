import 'package:flutter/material.dart';

class ClubPesquisa extends StatelessWidget {
  final String title;
  final String category;
  final int participants;
  final String date;
  //final String status;

  const ClubPesquisa({
    super.key,
    required this.title,
    required this.category,
    required this.participants,
    required this.date,
    //required this.status,
  });

  @override
  Widget build(BuildContext context) {
    // inkwell da o efeito de toquezin
    return GestureDetector(
      onTap: () => print('Molodas'),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade300, width: 0.8),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 5,
              offset: Offset(0, 3),
            )
          ],
        ),
        child: Row(
          children: [
      
            //Ícone Livro
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.auto_stories, color: Color(0xFF4A7FA5)),
            ),
      
            const SizedBox(width: 16),
      
            //Infos
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF5A4632))),
                  const SizedBox(height: 4),
                  //Categoria
                  Row(
                    mainAxisSize: MainAxisSize.min, // Mantém o ícone e texto próximos
                    children: [
                      const Icon(
                        Icons.label, 
                        color: Color(0xFFD2B48C),
                        size: 18, 
                      ),
                      const SizedBox(width: 6),
                      Text(
                        category,
                        style: const TextStyle(
                          color: Color(0xFF4A7FA5),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      // Ícone de participantes 
                      const Icon(Icons.group, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        "$participants participantes",
                        style: const TextStyle(
                          color: Color(0xFF8B7355), 
                          fontSize: 13, 
                        ),
                      ),
                      const SizedBox(width: 10),
                      if (date.isNotEmpty) ...[
                        const Icon(Icons.calendar_today, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          date,
                          style: const TextStyle(
                            color: Color(0xFF8B7355),
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