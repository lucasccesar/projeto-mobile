import 'package:flutter/material.dart';
import 'package:projeto_mobile/config/app_colors.dart';

class ClubeNavegacao extends StatelessWidget {
  final int abaSelecionada; // 0=atual, 1=anterior, 2=proximo
  final VoidCallback? onAtualTap;
  final VoidCallback? onAnteriorTap;
  final VoidCallback? onProximoTap;

  const ClubeNavegacao({
    super.key,
    required this.abaSelecionada,
    this.onAtualTap,
    this.onAnteriorTap,
    this.onProximoTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Divider(
          color: Theme.of(context).colorScheme.tertiary.withOpacity(0.15),
          height: 1,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _Aba(
              icone: Icons.menu_book_outlined,
              label: 'Atual',
              selecionada: abaSelecionada == 0,
              onTap: onAtualTap,
            ),
            _Aba(
              icone: Icons.skip_previous_outlined,
              label: 'Anteriores',
              selecionada: abaSelecionada == 1,
              onTap: onAnteriorTap,
            ),
            _Aba(
              icone: Icons.skip_next_outlined,
              label: 'Próximos',
              selecionada: abaSelecionada == 2,
              onTap: onProximoTap,
            ),
          ],
        ),
        Row(
          children: [
            _Linha(selecionada: abaSelecionada == 0),
            _Linha(selecionada: abaSelecionada == 1),
            _Linha(selecionada: abaSelecionada == 2),
          ],
        ),
      ],
    );
  }
}

class _Aba extends StatelessWidget {
  final IconData icone;
  final String label;
  final bool selecionada;
  final VoidCallback? onTap;

  const _Aba({
    required this.icone,
    required this.label,
    required this.selecionada,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cor = selecionada
        ? AppColors.clube
        : Color.lerp(Theme.of(context).colorScheme.tertiary, Colors.white, 0.3);

    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Icon(icone, color: cor, size: 18),
            SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                color: cor,
                fontWeight: selecionada ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Linha extends StatelessWidget {
  final bool selecionada;

   _Linha({required this.selecionada});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: 2,
        color: selecionada ? AppColors.clube : Colors.transparent,
      ),
    );
  }
}