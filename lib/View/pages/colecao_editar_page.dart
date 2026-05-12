import 'package:flutter/material.dart';
import 'package:projeto_mobile/config/app_colors.dart';
import 'package:projeto_mobile/View/widgets/bookly_appbar_widget.dart';
import 'package:projeto_mobile/View/pages/colecao_home_page.dart';

class ColecaoEditarPage extends StatefulWidget {
  final String nomeInicial;
  final String descricaoInicial;

  const ColecaoEditarPage({
    super.key,
    this.nomeInicial = '',
    this.descricaoInicial = '',
  });

  @override
  State<ColecaoEditarPage> createState() => _ColecaoEditarPageState();
}

class _ColecaoEditarPageState extends State<ColecaoEditarPage> {
  late final TextEditingController _nomeController;
  late final TextEditingController _descricaoController;

  final List<_LivroColecao> _livros = [
    _LivroColecao(titulo: 'O Senhor dos Anéis', autor: 'J.R.R. Tolkien', cor: Color(0xFF7A5C3A)),
    _LivroColecao(titulo: 'Cem Anos de Solidão', autor: 'Gabriel García Márquez', cor: Color(0xFF4A7FA5)),
    _LivroColecao(titulo: '1984', autor: 'George Orwell', cor: Color(0xFF7A8C63)),
  ];

  bool get _podeSubmeter => _nomeController.text.trim().isNotEmpty;

  @override
  void initState() {
    super.initState();
    _nomeController = TextEditingController(text: widget.nomeInicial);
    _descricaoController = TextEditingController(text: widget.descricaoInicial);
    _nomeController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _descricaoController.dispose();
    super.dispose();
  }

  void _salvar() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const ColecaoHomePage()),
      (route) => route.isFirst,
    );
  }

  @override
  Widget build(BuildContext context) {
    final borderColor = Theme.of(context).colorScheme.tertiary.withOpacity(0.15);
    final labelColor = Theme.of(context).colorScheme.tertiary;
    final hintColor = const Color(0xFF6B7280);
    final fillColor = Theme.of(context).colorScheme.surface;

    return Scaffold(
      appBar: BooklyAppBar(
        title: 'Editar Coleção',
        corDoTexto: AppColors.colecao,
        iconeMenu: false,
        iconeSeta: true,
        iconeCarrinho: false,
      ),
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _CardSection(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _SectionLabel(texto: 'Detalhes da Coleção', cor: AppColors.colecao),
                  const SizedBox(height: 13),
                  _FormGroup(
                    label: 'Nome da coleção *',
                    labelColor: labelColor,
                    child: _FormInput(
                      controller: _nomeController,
                      hintText: 'Ex: Minha estante de fantasia',
                      hintColor: hintColor,
                      fillColor: fillColor,
                      borderColor: borderColor,
                    ),
                  ),
                  const SizedBox(height: 13),
                  _FormGroup(
                    label: 'Descrição (opcional)',
                    labelColor: labelColor,
                    child: _FormTextArea(
                      controller: _descricaoController,
                      hintText: 'Fale um pouco sobre essa coleção…',
                      hintColor: hintColor,
                      fillColor: fillColor,
                      borderColor: borderColor,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            _CardSection(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _SectionLabel(texto: 'Livros da Coleção', cor: AppColors.colecao),
                  const SizedBox(height: 12),
                  if (_livros.isEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Center(
                        child: Text(
                          'Nenhum livro nesta coleção',
                          style: TextStyle(fontSize: 13, color: labelColor),
                        ),
                      ),
                    )
                  else
                    ..._livros.asMap().entries.map((entry) {
                      final i = entry.key;
                      final livro = entry.value;
                      return Column(
                        children: [
                          _LivroRow(
                            livro: livro,
                            onRemover: () => setState(() => _livros.removeAt(i)),
                          ),
                          if (i < _livros.length - 1)
                            Divider(color: borderColor, height: 1),
                        ],
                      );
                    }),
                ],
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 43,
              child: ElevatedButton(
                onPressed: _podeSubmeter ? _salvar : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6B8F6E),
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: const Color(0xFF6B8F6E).withOpacity(0.45),
                  disabledForegroundColor: Colors.white.withOpacity(0.7),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(99),
                  ),
                ),
                child: const Text(
                  'Salvar alterações',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              height: 43,
              child: OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.delete_outline, size: 16, color: Color(0xFFB94040)),
                label: const Text(
                  'Excluir coleção',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFB94040),
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Color(0xFFB94040), width: 1.5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(99),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class _LivroColecao {
  final String titulo;
  final String autor;
  final Color cor;

  _LivroColecao({required this.titulo, required this.autor, required this.cor});
}

class _CardSection extends StatelessWidget {
  final Widget child;

  const _CardSection({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 31),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).colorScheme.tertiary.withOpacity(0.15),
          width: 1,
        ),
      ),
      child: child,
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String texto;
  final Color cor;

  const _SectionLabel({required this.texto, required this.cor});

  @override
  Widget build(BuildContext context) {
    return Text(
      texto.toUpperCase(),
      style: TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.bold,
        letterSpacing: 0.5,
        color: cor,
      ),
    );
  }
}

class _FormGroup extends StatelessWidget {
  final String label;
  final Color labelColor;
  final Widget child;

  const _FormGroup({
    required this.label,
    required this.labelColor,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.4,
            color: labelColor,
          ),
        ),
        const SizedBox(height: 5),
        child,
      ],
    );
  }
}

class _FormInput extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final Color hintColor;
  final Color fillColor;
  final Color borderColor;

  const _FormInput({
    required this.controller,
    required this.hintText,
    required this.hintColor,
    required this.fillColor,
    required this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      style: const TextStyle(fontSize: 14),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: hintColor, fontSize: 14),
        filled: true,
        fillColor: fillColor,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
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
    );
  }
}

class _FormTextArea extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final Color hintColor;
  final Color fillColor;
  final Color borderColor;

  const _FormTextArea({
    required this.controller,
    required this.hintText,
    required this.hintColor,
    required this.fillColor,
    required this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      maxLines: 3,
      style: const TextStyle(fontSize: 14),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: hintColor, fontSize: 14),
        filled: true,
        fillColor: fillColor,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
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
    );
  }
}

class _LivroRow extends StatelessWidget {
  final _LivroColecao livro;
  final VoidCallback onRemover;

  const _LivroRow({required this.livro, required this.onRemover});

  @override
  Widget build(BuildContext context) {
    return Padding(
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
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
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
          GestureDetector(
            onTap: onRemover,
            child: Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: const Color(0xFFE57373).withOpacity(0.12),
                borderRadius: BorderRadius.circular(99),
              ),
              child: const Icon(Icons.close, size: 15, color: Color(0xFFE57373)),
            ),
          ),
        ],
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
      borderRadius: BorderRadius.circular(4),
      child: SizedBox(
        width: 46,
        height: 62,
        child: Stack(
          children: [
            Container(
              width: 46,
              height: 62,
              color: cor.withOpacity(0.25),
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
                color: cor.withOpacity(0.75),
              ),
            ),
          ],
        ),
      ),
    );
  }
}