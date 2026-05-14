import 'package:flutter/material.dart';
import 'package:projeto_mobile/View/pages/catalogo_page.dart';
import 'package:projeto_mobile/View/pages/clubes_page.dart';
import 'package:projeto_mobile/View/pages/colecoes_lista.dart';
import 'package:projeto_mobile/View/pages/favoritos_page.dart';
import 'package:projeto_mobile/View/pages/perfil_home.dart';
import 'package:projeto_mobile/View/pages/status_leitura_page.dart';
import 'package:projeto_mobile/config/app_colors.dart';

enum NavTab { catalogo, clubes, leitura, favoritos, conta }

class BooklyRodape extends StatefulWidget {
  final NavTab? selectedTab;

  const BooklyRodape({super.key, this.selectedTab});

  @override
  State<BooklyRodape> createState() => _BooklyRodapeState();
}

class _BooklyRodapeState extends State<BooklyRodape> {
  NavTab? _selected;

  @override
  void initState() {
    super.initState();
    _selected = widget.selectedTab;
  }

  final List<_NavItem> _items = const [
    _NavItem(
      tab: NavTab.catalogo,
      icon: Icons.menu_book_outlined,
      label: 'Catálogo',
      activeColor: AppColors.catalogo,
    ),
    _NavItem(
      tab: NavTab.clubes,
      icon: Icons.people_outline,
      label: 'Clubes',
      activeColor: AppColors.clube,
    ),
    _NavItem(
      tab: NavTab.leitura,
      icon: Icons.show_chart,
      label: 'Leitura',
      activeColor: AppColors.leitura,
    ),
    _NavItem(
      tab: NavTab.favoritos,
      icon: Icons.favorite_border,
      label: 'Favoritos',
      activeColor: AppColors.favoritos,
    ),
    _NavItem(
      tab: NavTab.conta,
      icon: Icons.person_outline,
      label: 'Conta',
      activeColor: AppColors.perfil,
    ),
  ];

  void _onTap(NavTab tab) {
    if (tab == _selected) return;
    setState(() => _selected = tab);

    Widget page;
    switch (tab) {
      case NavTab.catalogo:
        page = const CatalogoPage();
      case NavTab.clubes:
        page = const ClubesPage();
      case NavTab.leitura:
        page = const StatusLeituraPage();
      case NavTab.favoritos:
        page = const FavoritosPage();
      case NavTab.conta:
        page = const PerfilHome();
      default:
        page = const CatalogoPage();
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => page),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration:  BoxDecoration(
        color: Theme.of(context).colorScheme.secondary,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, -1),
          ),
        ],
      ),
      child: SafeArea(
        child: SizedBox(
          height: 60,
          child: Row(
            children: _items.map((item) {
              final isSelected = item.tab == _selected;
              return Expanded(
                child: GestureDetector(
                  onTap: () => _onTap(item.tab),
                  behavior: HitTestBehavior.opaque,
                  child: _NavBarItem(item: item, isSelected: isSelected),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}

class _NavBarItem extends StatelessWidget {
  final _NavItem item;
  final bool isSelected;

  const _NavBarItem({required this.item, required this.isSelected});

  static const _inactiveColor = Color(0xFF9E9E9E);
  static const _indicatorWidth = 28.0;

  @override
  Widget build(BuildContext context) {
    final color = isSelected ? item.activeColor : _inactiveColor;

    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeInOut,
          height: 2.5,
          width: isSelected ? _indicatorWidth : 0,
          margin: const EdgeInsets.only(bottom: 6),
          decoration: BoxDecoration(
            color: item.activeColor,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: Icon(
            item.icon,
            key: ValueKey(isSelected),
            size: 22,
            color: color,
          ),
        ),
        SizedBox(height: 3),
        AnimatedDefaultTextStyle(
          duration: const Duration(milliseconds: 200),
          style: TextStyle(
            fontSize: 10,
            color: color,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
          ),
          child: Text(item.label),
        ),
      ],
    );
  }
}

class _NavItem {
  final NavTab tab;
  final IconData icon;
  final String label;
  final Color activeColor;

  const _NavItem({
    required this.tab,
    required this.icon,
    required this.label,
    required this.activeColor,
  });
}