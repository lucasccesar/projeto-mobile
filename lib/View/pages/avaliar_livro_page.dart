import 'package:flutter/material.dart';
import 'package:projeto_mobile/config/app_colors.dart';
import 'package:projeto_mobile/models/book.dart';
import 'package:projeto_mobile/View/widgets/bookly_appbar_widget.dart';
import 'package:projeto_mobile/View/widgets/bookly_text_field.dart';
import 'package:projeto_mobile/View/widgets/bookly_capa_widget.dart';
import 'package:projeto_mobile/View/widgets/colecao_form_widgets.dart';

class AvaliarLivroPage extends StatefulWidget {
  final Book livro;

  const AvaliarLivroPage({super.key, required this.livro});

  @override
  State<AvaliarLivroPage> createState() => _AvaliarLivroPageState();
}

class _AvaliarLivroPageState extends State<AvaliarLivroPage> {
  int _notaSelecionada = 0;
  final TextEditingController _comentarioController = TextEditingController();

  static const Color _highland = Color(0xFF7A8C63);
  static const Color _millbrook = Color(0xFF5A4631);
  static const Color _shadow = Color(0xFF8B7355);
  static const Color _starActive = Color(0xFFD4A84B);

  static const List<String> _legendas = [
    '',
    'Horrível',
    'Péssimo',
    'Ruim',
    'Fraco',
    'Regular',
    'Ok',
    'Bom',
    'Muito Bom',
    'Ótimo',
    'Excelente',
  ];

  bool get _podeEnviar => _notaSelecionada > 0;

  @override
  void dispose() {
    _comentarioController.dispose();
    super.dispose();
  }

  void _enviar() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      appBar: BooklyAppBar(
        title: 'Avaliar Livro',
        corDoTexto: AppColors.catalogo,
        iconeMenu: false,
        iconeSeta: true,
        iconeCarrinho: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildIdentificacaoLivro(),
            const SizedBox(height: 14),
            _buildSeletorEstrelas(),
            const SizedBox(height: 14),
            _buildCampoComentario(),
            const SizedBox(height: 24),
            BooklyActionButton(
              label: 'Enviar avaliação',
              onPressed: _podeEnviar ? _enviar : null,
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildIdentificacaoLivro() {
    return BooklyCardSection(
      child: Row(
        children: [
          const BooklyCapaWidget(cor: AppColors.catalogo, largura: 52, altura: 72),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.livro.title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: _millbrook,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  widget.livro.author,
                  style: const TextStyle(fontSize: 13, color: _shadow),
                ),
                const SizedBox(height: 5),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
                  decoration: BoxDecoration(
                    color: _highland.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(99),
                  ),
                  child: Text(
                    widget.livro.genre,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: _highland,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSeletorEstrelas() {
    return BooklyCardSection(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BooklySectionLabel(
            texto: 'Sua nota',
            cor: AppColors.catalogo,
          ),
          const SizedBox(height: 18),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(10, (i) {
              final numero = i + 1;
              final ativa = numero <= _notaSelecionada;
              return GestureDetector(
                onTap: () => setState(() => _notaSelecionada = numero),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 120),
                  width: 32,
                  height: 32,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Icon(
                        ativa
                            ? Icons.star_rounded
                            : Icons.star_outline_rounded,
                        size: 32,
                        color: ativa
                            ? _starActive
                            : _millbrook.withValues(alpha: 0.18),
                      ),
                      Text(
                        '$numero',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          color: ativa
                              ? Colors.white.withValues(alpha: 0.9)
                              : _millbrook.withValues(alpha: 0.35),
                          height: 1,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 14),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 180),
            child: _notaSelecionada > 0
                ? Center(
                    key: ValueKey(_notaSelecionada),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 5),
                      decoration: BoxDecoration(
                        color: _starActive.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(99),
                        border: Border.all(
                          color: _starActive.withValues(alpha: 0.3),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.star_rounded,
                              size: 14, color: _starActive),
                          const SizedBox(width: 6),
                          Text(
                            '$_notaSelecionada/10 — ${_legendas[_notaSelecionada]}',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: _starActive.withValues(alpha: 0.85),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : Center(
                    key: const ValueKey(0),
                    child: Text(
                      'Toque em uma estrela para avaliar',
                      style: TextStyle(
                        fontSize: 13,
                        color: _millbrook.withValues(alpha: 0.35),
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildCampoComentario() {
    return BooklyCardSection(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BooklySectionLabel(
            texto: 'Comentário',
            cor: AppColors.catalogo,
          ),
          const SizedBox(height: 14),
          BooklyTextField(
            label: 'Escreva sua opinião (opcional)',
            hintText: 'O que você achou deste livro? Conte sua experiência…',
            controller: _comentarioController,
            maxLines: 5,
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.info_outline_rounded,
                  size: 13, color: _millbrook.withValues(alpha: 0.3)),
              const SizedBox(width: 5),
              Text(
                'Sua avaliação ficará visível para outros leitores.',
                style: TextStyle(
                  fontSize: 11,
                  color: _millbrook.withValues(alpha: 0.4),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}