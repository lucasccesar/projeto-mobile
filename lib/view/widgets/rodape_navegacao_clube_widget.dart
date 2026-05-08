import 'package:flutter/material.dart';

// Enum para representar cada aba
enum NavTab { catalogo, clubes, leitura, favoritos, conta }

class ClubeRodape extends StatefulWidget {
  const ClubeRodape({super.key});

  @override
  State<ClubeRodape> createState() => _ClubeRodapeState();
}

class _ClubeRodapeState extends State<ClubeRodape> {
  NavTab _selected = NavTab.clubes;

  final List<_NavItem> _items = const [
    _NavItem(
      tab: NavTab.catalogo,
      icon: Icons.menu_book_outlined,
      label: 'Catálogo',
      activeColor: Color(0xFF7A8C63), 
    ),
    _NavItem(
      tab: NavTab.clubes,
      icon: Icons.people_outline,
      label: 'Clubes',
      activeColor: Color(0xFF4A7FA5),
    ),
    _NavItem(
      tab: NavTab.leitura,
      icon: Icons.show_chart,
      label: 'Leitura',
      activeColor: Color(0xFF3D9080), 
    ),
    _NavItem(
      tab: NavTab.favoritos,
      icon: Icons.favorite_border,
      label: 'Favoritos',
      activeColor: Color(0xFFC0624E), 
    ),
    _NavItem(
      tab: NavTab.conta,
      icon: Icons.person_outline,
      label: 'Conta',
      activeColor: Color(0xFF6B7280), 
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFFF9F4EE),
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
                  onTap: () => setState(() => _selected = item.tab),
                  behavior: HitTestBehavior.opaque,
                  child: _NavBarItem(
                    item: item,
                    isSelected: isSelected,
                  ),
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
        // Linha indicadora animada no topo
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

        // Ícone com animação de cor
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: Icon(
            item.icon,
            key: ValueKey(isSelected),
            size: 22,
            color: color,
          ),
        ),
        const SizedBox(height: 3),
        
        // Label com animação de cor
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