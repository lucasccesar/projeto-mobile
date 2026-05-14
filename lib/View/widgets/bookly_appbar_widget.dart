import 'package:flutter/material.dart';

class BooklyAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Color corDoTexto;
  final bool iconeMenu;
  final bool iconeCarrinho;
  final bool iconeSeta;

  final VoidCallback? onCarrinhoTap;

  const BooklyAppBar({
    super.key,
    required this.title,
    required this.iconeMenu,
    required this.iconeCarrinho,
    required this.iconeSeta,
    required this.corDoTexto,
    this.onCarrinhoTap,
  });
  //TODO: criar um widget para o Drawer
  //TODO: config alutra e largura appbar - OK
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 1.0);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).colorScheme.secondary,
      elevation: 0,
      centerTitle: false,
      titleSpacing: 0,

      //TODO: logica para aparecer, carrinho de compras | seta | drawer
      leading: iconeMenu
          ? Builder(
              builder: (context) => IconButton(
                icon:  Icon(Icons.menu, color: Theme.of(context).colorScheme.tertiary),
                onPressed: () => Scaffold.of(context).openDrawer(),
              ),
            )
          : iconeSeta
          ? IconButton(
              icon: Icon(Icons.chevron_left, color: Theme.of(context).colorScheme.tertiary),
              onPressed: () => Navigator.maybePop(context),
            )
          : null,

      // texto e icone appbar
      title: Row(
        children: [
          Icon(Icons.book_outlined, color: corDoTexto, size: 25),
          SizedBox(width: 8),
          Text(
            title,
            style: TextStyle(
              color: corDoTexto,
              fontWeight: FontWeight.w700,
              fontSize: 21,
            ),
          ),
        ],
      ),

      actions: [
        if (iconeCarrinho)
          IconButton(
            icon: Icon(
              Icons.shopping_cart_outlined,
              color: Theme.of(context).colorScheme.tertiary,
            ),
            onPressed: onCarrinhoTap,
          ),
      ],
    );
  }
}
