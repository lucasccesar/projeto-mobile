import 'package:flutter/material.dart';

class BookThumbWidget extends StatelessWidget {
  final Color cor;

  const BookThumbWidget({super.key, required this.cor});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(4),
      child: SizedBox(
        width: 46,
        height: 62,
        child: Stack(
          children: [
            Container(
              width: 46,
              height: 62,
              color: cor.withValues(alpha: 0.25),
              child: Center(
                child: Icon(Icons.menu_book_rounded, color: cor, size: 22),
              ),
            ),
            Positioned(
              left: 0,
              top: 0,
              bottom: 0,
              child: Container(
                width: 5,
                color: cor.withValues(alpha: 0.75),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
