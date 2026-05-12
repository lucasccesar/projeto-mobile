import 'package:flutter/material.dart';
import 'package:projeto_mobile/config/app_colors.dart';
import 'package:projeto_mobile/View/widgets/bookly_appbar_widget.dart';

class ColecaoCriarPage extends StatefulWidget {
  const ColecaoCriarPage({super.key});

  @override
  State<ColecaoCriarPage> createState() => _ColecaoCriarPageState();
}

class _ColecaoCriarPageState extends State<ColecaoCriarPage> {
  final _nomeController = TextEditingController();
  final _descricaoController = TextEditingController();
  final _buscaController = TextEditingController();

  final List<_LivroItem> _livros = [
    _LivroItem(titulo: 'O Senhor dos Anéis', autor: 'J.R.R. Tolkien', cor: Color(0xFF7A5C3A)),
    _LivroItem(titulo: 'Harry Potter', autor: 'J.K. Rowling', cor: Color(0xFF4A7FA5)),
    _LivroItem(titulo: 'Duna', autor: 'Frank Herbert', cor: Color(0xFF7A8C63)),
  ];

  bool get _podeSubmeter => _nomeController.text.trim().isNotEmpty;

  @override
  void initState() {
    super.initState();
    _nomeController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _descricaoController.dispose();
    _buscaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bg = Theme.of(context).colorScheme.primary;
    final card = Theme.of(context).colorScheme.secondary;
    final input = Theme.of(context).colorScheme.surface;
    final borderColor = Theme.of(context).colorScheme.tertiary.withOpacity(0.15);
    final labelColor = Theme.of(context).colorScheme.tertiary;
    final sectionLabelColor = AppColors.colecao;
    final hintColor = const Color(0xFF6B7280);

    return Scaffold(
      appBar: BooklyAppBar(
        title: 'Criar Coleção',
        corDoTexto: AppColors.colecao,
        iconeMenu: false,
        iconeSeta: true,
        iconeCarrinho: false,
      ),
      backgroundColor: bg,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _CardSection(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _SectionLabel(texto: 'Detalhes', cor: sectionLabelColor),
                  const SizedBox(height: 13),
                  _FormGroup(
                    label: 'Nome da coleção *',
                    labelColor: labelColor,
                    child: _FormInput(
                      controller: _nomeController,
                      hintText: 'Ex: Minha estante de fantasia',
                      hintColor: hintColor,
                      fillColor: input,
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
                      fillColor: input,
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
                  Row(
                    children: [
                      _SectionLabel(texto: 'Adicionar livros', cor: sectionLabelColor),
                    ],
                  ),
                  const SizedBox(height: 10),
                  _FormInput(
                    controller: _buscaController,
                    hintText: '🔍 Buscar livro…',
                    hintColor: hintColor,
                    fillColor: input,
                    borderColor: borderColor,
                    onChanged: (_) => setState(() {}),
                  ),
                  const SizedBox(height: 12),
                  ..._livros.asMap().entries.map((entry) {
                    final i = entry.key;
                    final livro = entry.value;
                    return Column(
                      children: [
                        _LivroRow(
                          livro: livro,
                          onToggle: () => setState(() => livro.selecionado = !livro.selecionado),
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
                onPressed: _podeSubmeter ? () => Navigator.pop(context) : null,
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
                  'Criar coleção',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
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
  final ValueChanged<String>? onChanged;

  const _FormInput({
    required this.controller,
    required this.hintText,
    required this.hintColor,
    required this.fillColor,
    required this.borderColor,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
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
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 46,
              height: 62,
              child: _BookThumb(cor: livro.cor),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    livro.titulo,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    livro.autor,
                    style: TextStyle(
                      fontSize: 11,
                      color: Theme.of(context).colorScheme.tertiary,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
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
    return SizedBox(
      width: 46,
      height: 62,
      child: Row(
        children: [
          Container(
            width: 5,
            decoration: BoxDecoration(
              color: cor.withOpacity(0.7),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(4),
                bottomLeft: Radius.circular(4),
              ),
            ),
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: cor.withOpacity(0.25),
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(4),
                  bottomRight: Radius.circular(4),
                ),
              ),
              child: Center(
                child: Icon(Icons.book, color: cor, size: 20),
              ),
            ),
          ),
        ],
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
        color: selecionado ? const Color(0xFF6B8F6E) : Colors.transparent,
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