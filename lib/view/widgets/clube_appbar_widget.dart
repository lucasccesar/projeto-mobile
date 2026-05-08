import 'package:flutter/material.dart';

class ClubeAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const ClubeAppBar({
    super.key,
    required this.title,
  });

  //TODO: config alutra e largura appbar - OK
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 1.0);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: const Color(0xFFF5F1EB),
      elevation: 0,
      centerTitle: false,
      titleSpacing: 20,
      leading: Builder(
        builder: (context) => IconButton(
          icon: const Icon(
            Icons.menu,
            color: Color(0xFF333333),
            size: 25,
          ),
          onPressed: () => Scaffold.of(context).openDrawer(),
        ),
      ),
      title: Row(
        children: [
          const Icon(
            Icons.book_outlined,
            color: Color(0xFF4A7FA5),
            size: 25,
          ),
          const SizedBox(width: 8),
          Text(
            title,
            style: const TextStyle(
              color: Color(0xFF4A7FA5),
              fontWeight: FontWeight.w700,
              fontSize: 21,
            ),
          ),
        ],
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1.0),
        child: Container(
          color: Colors.black12,
          height: 1.0,
        ),
      ),
    );
  }
}