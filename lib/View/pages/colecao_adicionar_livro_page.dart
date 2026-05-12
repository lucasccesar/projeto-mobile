import 'package:flutter/material.dart';
import 'package:projeto_mobile/config/app_colors.dart';
import 'package:projeto_mobile/View/widgets/bookly_appbar_widget.dart';

class ColecaoAdicionarLivroPage extends StatefulWidget {
  const ColecaoAdicionarLivroPage({super.key});

  @override
  State<ColecaoAdicionarLivroPage> createState() =>
      _ColecaoAdicionarLivroPageState();
}

class _ColecaoAdicionarLivroPageState
    extends State<ColecaoAdicionarLivroPage> {
  final _buscaController = TextEditingController();

  final List<_LivroItem> _livros = [
    _LivroItem(
      titulo: 'O Nome do Vento',
      autor: 'Patrick Rothfuss',
      cor: Color(0xFF7B5EA7),
    ),
    _LivroItem(
      titulo: 'A Roda do Tempo',
      autor: 'Robert Jordan',
      cor: Color(0xFF5E8A6E),
    ),
    _LivroItem(
      titulo: 'Fundação',
      autor: 'Isaac Asimov',
      cor: Color(0xFF7A5C3A),
    ),
    _LivroItem(
      titulo: 'Neuromancer',
      autor: 'William Gibson',
      cor: Color(0xFF4A7FA5),
    ),
    _LivroItem(
      titulo: 'Drácula',
      autor: 'Bram Stoker',
      cor: Color(0xFF8B3A3A),
    ),
  ];

  List<_LivroItem> get _livrosFiltrados {
    final query = _buscaController.text.trim().toLowerCase();
    if (query.isEmpty) return _livros;
    return _livros
        .where(
          (l) =>
              l.titulo.toLowerCase().contains(query) ||
              l.autor.toLowerCase().contains(query),
        )
        .toList();
  }

  bool get _temSelecionados => _livros.any((l) => l.selecionado);

  @override
  void initState() {
    super.initState();
    _buscaController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _buscaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final borderColor =
        Theme.of(context).colorScheme.tertiary.withOpacity(0.15);
    final hintColor = const Color(0xFF6B7280);
    final cardColor = Theme.of(context).colorScheme.secondary;
    final filtrados = _livrosFiltrados;

    return Scaffold(
      appBar: BooklyAppBar(
        title: 'Adicionar Livro',
        corDoTexto: AppColors.colecao,
        iconeMenu: false,
        iconeSeta: true,
        iconeCarrinho: false,
      ),
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(16, 18, 16, 24),
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: borderColor, width: 1),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'ADICIONAR LIVROS',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                        color: AppColors.colecao,
                      ),
                    ),
                    const SizedBox(height: 13),
                    TextField(
                      controller: _buscaController,
                      style: const TextStyle(fontSize: 14),
                      decoration: InputDecoration(
                        hintText: '🔍 Buscar livro…',
                        hintStyle:
                            TextStyle(color: hintColor, fontSize: 14),
                        filled: true,
                        fillColor:
                            Theme.of(context).colorScheme.surface,
                        contentPadding: const EdgeInsets.only(
                          left: 34,
                          right: 14,
                          top: 12,
                          bottom: 12,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(9),
                          borderSide: BorderSide(color: borderColor),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(9),
                          borderSide: BorderSide(color: borderColor),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(9),
                          borderSide: BorderSide(color: borderColor),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    if (filtrados.isEmpty)
                      Padding(
                        padding:
                            const EdgeInsets.symmetric(vertical: 24),
                        child: Center(
                          child: Text(
                            'Nenhum livro encontrado',
                            style: TextStyle(
                              fontSize: 13,
                              color: Theme.of(context)
                                  .colorScheme
                                  .tertiary,
                            ),
                          ),
                        ),
                      )
                    else
                      ...filtrados.asMap().entries.map((entry) {
                        final i = entry.key;
                        final livro = entry.value;
                        return Column(
                          children: [
                            _LivroRow(
                              livro: livro,
                              onToggle: () => setState(
                                  () => livro.selecionado = !livro.selecionado),
                            ),
                            if (i < filtrados.length - 1)
                              Divider(color: borderColor, height: 1),
                          ],
                        );
                      }),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
            child: SizedBox(
              width: double.infinity,
              height: 43,
              child: ElevatedButton(
                onPressed: _temSelecionados
                    ? () => Navigator.pop(context)
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6B8F6E),
                  foregroundColor: Colors.white,
                  disabledBackgroundColor:
                      const Color(0xFF6B8F6E).withOpacity(0.45),
                  disabledForegroundColor:
                      Colors.white.withOpacity(0.7),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(99),
                  ),
                ),
                child: const Text(
                  'Adicionar à coleção',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LivroItem {
  final String titulo;
  final String autor;
  final Color cor;
  bool selecionado;

  _LivroItem({
    required this.titulo,
    required this.autor,
    required this.cor,
    this.selecionado = false,
  });
}

class _LivroRow extends StatelessWidget {
  final _LivroItem livro;
  final VoidCallback onToggle;

  const _LivroRow({required this.livro, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onToggle,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            _BookThumb(cor: livro.cor),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    livro.titulo,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    livro.autor,
                    style: TextStyle(
                      fontSize: 11,
                      color: Theme.of(context).colorScheme.tertiary,
                    ),
                  ),
                ],
              ),
            ),
            _Checkbox(selecionado: livro.selecionado),
          ],
        ),
      ),
    );
  }
}

class _BookThumb extends StatelessWidget {
  final Color cor;

  const _BookThumb({required this.cor});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(7),
      child: SizedBox(
        width: 46,
        height: 62,
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    cor.withOpacity(0.15),
                    cor.withOpacity(0.35),
                  ],
                ),
                border: Border.all(
                  color: cor.withOpacity(0.20),
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(7),
              ),
            ),
            Positioned(
              left: 1,
              top: 0,
              bottom: 0,
              child: Container(
                width: 5,
                decoration: BoxDecoration(
                  color: cor.withOpacity(0.30),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(6),
                    bottomLeft: Radius.circular(6),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Checkbox extends StatelessWidget {
  final bool selecionado;

  const _Checkbox({required this.selecionado});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        color: selecionado
            ? const Color(0xFF6B8F6E)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(5),
        border: Border.all(
          color: selecionado
              ? const Color(0xFF6B8F6E)
              : Theme.of(context).colorScheme.tertiary.withOpacity(0.4),
          width: 1.5,
        ),
      ),
      child: selecionado
          ? const Icon(Icons.check, color: Colors.white, size: 13)
          : null,
    );
  }
}