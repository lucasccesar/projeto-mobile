import 'package:flutter/material.dart';
import 'package:projeto_mobile/config/app_colors.dart';

class ClubeNavegacao extends StatefulWidget {
  final VoidCallback? onAnteriorTap;
  final VoidCallback? onProximoTap;

  const ClubeNavegacao({
    super.key,
    this.onAnteriorTap,
    this.onProximoTap,
  });

  @override
  State<ClubeNavegacao> createState() => _ClubeNavegacaoState();
}

class _ClubeNavegacaoState extends State<ClubeNavegacao> {
  int _abaSelecionada = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _Aba(
              icone: Icons.menu_book_outlined,
              label: 'Atual',
              selecionada: _abaSelecionada == 0,
              onTap: () => setState(() => _abaSelecionada = 0),
            ),
            _Aba(
              icone: Icons.skip_previous_outlined,
              label: 'Anteriores',
              selecionada: _abaSelecionada == 1,
              onTap: () {
                setState(() => _abaSelecionada = 1);
                widget.onAnteriorTap?.call();
              },
            ),
            _Aba(
              icone: Icons.skip_next_outlined,
              label: 'Próximos',
              selecionada: _abaSelecionada == 2,
              onTap: () {
                setState(() => _abaSelecionada = 2);
                widget.onProximoTap?.call();
              },
            ),
          ],
        ),
        // linha que fica embaixo de cada aba
        Row(
          children: [
            _Linha(selecionada: _abaSelecionada == 0),
            _Linha(selecionada: _abaSelecionada == 1),
            _Linha(selecionada: _abaSelecionada == 2),
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
  final VoidCallback onTap;

  const _Aba({
    required this.icone,
    required this.label,
    required this.selecionada,
    required this.onTap,
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

  const _Linha({required this.selecionada});

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