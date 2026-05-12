import 'package:flutter/material.dart';
import 'package:projeto_mobile/config/app_colors.dart';

class ClubeLivroAnteriorProximo extends StatelessWidget {
  final String titulo;
  final String autor;
  final String data;
  final bool anterior;
  final double? nota;

  const ClubeLivroAnteriorProximo({
    super.key,
    //required this.icone,
    required this.anterior,
    required this.titulo,
    required this.autor,
    required this.data,
    this.nota,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin:  EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      padding:  EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(12),
        //configuracao bordas
        border: anterior
            ? Border.all(
                color: 
                  Theme.of(context).colorScheme.tertiary.withOpacity(0.2),
                style: BorderStyle.solid,
                width: 1,
              )
            : Border.all(
                color: AppColors.clube.withOpacity(0.5),
                style: BorderStyle.solid,
                width: 1,
              ),
      ),

      child: Row(
        children: [
          //ICON DO LIVRO
          Container(
            width: 40,
            height: 54,
            decoration: BoxDecoration(
              color: anterior
                  ? Color.lerp(
                      Theme.of(context).colorScheme.tertiary,
                      Colors.white,
                      0.75,
                    )
                  : Color.lerp(AppColors.clube, Colors.white, 0.7),

              borderRadius: BorderRadius.circular(8),
            ),

            child: Icon(
              anterior ? Icons.book_outlined : Icons.access_time_outlined,

              color: anterior
                  ? Theme.of(context).colorScheme.tertiary
                  : AppColors.clube,
            ),
          ),

          SizedBox(width: 12),

          // TÍTULO, AUTOR E DATA
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  titulo,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.tertiary,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  autor,
                  style: TextStyle(
                    fontSize: 13,
                    color: Theme.of(context).colorScheme.tertiary,
                  ),
                ),
                SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today_outlined,
                      size: 13,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                    SizedBox(width: 4),
                    anterior ?
                    Text(
                      data,
                      style: TextStyle(
                        fontSize: 13,
                        color: Theme.of(context).colorScheme.tertiary,
                      ),
                    ) :
                    Text(
                      data,
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.clube,
                        fontWeight: FontWeight.bold,
                      ),
                    ) 
                  ],
                ),
              ],
            ),
          ),

          // NOTA ou EM BREVE
          anterior
              ? Column(
                //mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  //Spacer(),
                  Row(
                      children: [
                        Icon(Icons.star, color: Color(0xFFF59E0B), size: 13),
                        SizedBox(width: 2),
                        Text(
                          '${nota ?? ''}',
                          style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.tertiary),
                        ),
                      ],
                    ),
                ],
              )
              : Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Color.lerp(AppColors.clube, Colors.white, 0.7),
                    borderRadius: BorderRadius.circular(99),
                  ),
                  child: Text(
                    'Em breve',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.clube,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}
