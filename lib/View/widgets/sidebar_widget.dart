import 'package:flutter/material.dart';
import 'package:projeto_mobile/config/app_colors.dart';
import 'package:projeto_mobile/models/book.dart';
import 'package:projeto_mobile/View/pages/login.dart';
import 'package:projeto_mobile/View/pages/catalogo_page.dart';
import 'package:projeto_mobile/View/pages/clubes_page.dart';
import 'package:projeto_mobile/View/pages/colecoes_lista.dart';
import 'package:projeto_mobile/View/pages/carrinho_page.dart';
import 'package:projeto_mobile/View/widgets/bookly_logo.dart';

class SidebarWidget extends StatelessWidget {
  final List<Book> carrinho;

  const SidebarWidget({super.key, this.carrinho = const []});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.secondary,
      child: Column(
        children: [
          //TODO: AJEITAR TAMANHO DO DRAWERHEADER
          SizedBox(height: 140,
            child: DrawerHeader(
              child: Row(
                children: [
                  Icon(Icons.book_outlined,
                  size: 44,
                  color: AppColors.catalogo),
                  SizedBox(width: 12),
                  Text(
                    'BookLy',
                    style: TextStyle(
                      color: AppColors.catalogo,
                      fontSize: 34,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),

          //body do drwaer
          ListTile(
            leading: Icon(Icons.home_outlined),
            title: Text(
              'Início',
              style: TextStyle(
                color: Theme.of(context).colorScheme.tertiary,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            trailing: Icon(
              Icons.chevron_right,
              color: Theme.of(context).colorScheme.tertiary,
            ),
            onTap: () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const CatalogoPage()),
            ),
          ),

          ListTile(
            leading: Icon(Icons.group_outlined),
            title: Text(
              'Clubes do Livro',
              style: TextStyle(
                color: Theme.of(context).colorScheme.tertiary,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            trailing: Icon(
              Icons.chevron_right,
              color: Theme.of(context).colorScheme.tertiary,
            ),
            onTap: () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const ClubesPage()),
            ),
          ),

          // TÍTULO DE SEÇÃO
          Padding(
            padding: EdgeInsets.only(left: 16, top: 8),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'PESSOAL',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.tertiary,
                ),
              ),
            ),
          ),

          ListTile(
            leading: Icon(Icons.bar_chart_outlined),
            title: Text(
              'Minha Leitura',
              style: TextStyle(
                color: Theme.of(context).colorScheme.tertiary,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            trailing: Icon(
              Icons.chevron_right,
              color: Theme.of(context).colorScheme.tertiary,
            ),
            onTap: () {},
          ),

          ListTile(
            leading: Icon(Icons.favorite_outline),
            title: Text(
              'Favoritos',
              style: TextStyle(
                color: Theme.of(context).colorScheme.tertiary,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            trailing: Icon(
              Icons.chevron_right,
              color: Theme.of(context).colorScheme.tertiary,
            ),
            onTap: () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const ColecoesListaPage()),
            ),
          ),

          ListTile(
            leading: Icon(Icons.folder_outlined),
            title: Text(
              'Coleções',
              style: TextStyle(
                color: Theme.of(context).colorScheme.tertiary,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            trailing: Icon(
              Icons.chevron_right,
              color: Theme.of(context).colorScheme.tertiary,
            ),
            onTap: () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const ColecoesListaPage()),
            ),
          ),

          Padding(
            padding: EdgeInsets.only(left: 16, top: 8),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'COMPRAS',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.tertiary,
                ),
              ),
            ),
          ),

          ListTile(
            leading: Icon(Icons.shopping_cart_outlined),
            title: Text(
              'Carrinho',
              style: TextStyle(
                color: Theme.of(context).colorScheme.tertiary,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            trailing: Icon(
              Icons.chevron_right,
              color: Theme.of(context).colorScheme.tertiary,
            ),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => CarrinhoPage(itens: carrinho)),
            ),
          ),

          ListTile(
            leading: Icon(Icons.history_outlined),
            title: Text(
              'Histórico',
              style: TextStyle(
                color: Theme.of(context).colorScheme.tertiary,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            trailing: Icon(
              Icons.chevron_right,
              color: Theme.of(context).colorScheme.tertiary,
            ),
            onTap: () {},
          ),

          Spacer(),
          Divider(
            height: 1,
            color: Color.lerp(Theme.of(context).colorScheme.tertiary, Colors.white, 0.8),
          ),
          
          ListTile(
            leading: Icon(Icons.person_outline),
            title: Text('Perfil', style: TextStyle(color: Theme.of(context).colorScheme.tertiary, fontWeight: FontWeight.bold, fontSize: 16)),
            trailing: Icon(Icons.chevron_right, color: Theme.of(context).colorScheme.tertiary),
            onTap: () {},
          ),

          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Sair', style: TextStyle(color: Theme.of(context).colorScheme.tertiary, fontWeight: FontWeight.bold, fontSize: 16)),
            trailing: Icon(Icons.chevron_right, color: Theme.of(context).colorScheme.tertiary),
            onTap: () {
              Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => LoginPage(),)
          );},
          ),
            SizedBox(height: 16,)
        ],
      ),
    );
  }
}
