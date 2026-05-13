import 'package:flutter/material.dart';
import 'package:projeto_mobile/config/app_colors.dart';
import 'package:projeto_mobile/models/book.dart';
import 'package:projeto_mobile/View/widgets/bookly_appbar_widget.dart';
import 'package:projeto_mobile/View/widgets/bookly_text_field.dart';
import 'package:projeto_mobile/View/widgets/colecao_form_widgets.dart';

class EditarLivroPage extends StatefulWidget {
  final Book livro;

  const EditarLivroPage({super.key, required this.livro});

  @override
  State<EditarLivroPage> createState() => _EditarLivroPageState();
}

class _EditarLivroPageState extends State<EditarLivroPage> {
  late final TextEditingController _tituloController;
  late final TextEditingController _autorController;
  late final TextEditingController _sinopseController;
  late final TextEditingController _generoController;
  late final TextEditingController _precoController;

  static const List<String> _generosSugeridos = [
    'Fantasia',
    'Ficção Científica',
    'Romance',
    'Distopia',
    'Aventura',
    'Terror',
    'Policial',
    'Biografia',
    'História',
    'Autoajuda',
  ];

  bool get _podeSubmeter =>
      _tituloController.text.trim().isNotEmpty &&
      _autorController.text.trim().isNotEmpty;

  @override
  void initState() {
    super.initState();
    _tituloController = TextEditingController(text: widget.livro.title);
    _autorController = TextEditingController(text: widget.livro.author);
    _sinopseController = TextEditingController();
    _generoController = TextEditingController(text: widget.livro.genre);
    _precoController = TextEditingController(
      text: widget.livro.price.toStringAsFixed(2).replaceAll('.', ','),
    );

    _tituloController.addListener(() => setState(() {}));
    _autorController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _tituloController.dispose();
    _autorController.dispose();
    _sinopseController.dispose();
    _generoController.dispose();
    _precoController.dispose();
    super.dispose();
  }

  void _salvar() {
    Navigator.pop(context);
  }

  void _excluir() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Excluir livro',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Color(0xFF5A4631),
          ),
        ),
        content: const Text(
          'Tem certeza que deseja excluir este livro? Esta ação não pode ser desfeita.',
          style: TextStyle(fontSize: 14, color: Color(0xFF8B7355)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancelar',
              style: TextStyle(color: Color(0xFF8B7355)),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: Text(
              'Excluir',
              style: TextStyle(
                color: AppColors.danger,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      appBar: BooklyAppBar(
        title: 'Editar Livro',
        corDoTexto: AppColors.catalogo,
        iconeMenu: false,
        iconeSeta: true,
        iconeCarrinho: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            BooklyCardSection(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BooklySectionLabel(
                    texto: 'Informações do Livro',
                    cor: AppColors.catalogo,
                  ),
                  const SizedBox(height: 14),
                  BooklyTextField(
                    label: 'Título *',
                    hintText: 'Ex: O Senhor dos Anéis',
                    controller: _tituloController,
                  ),
                  const SizedBox(height: 12),
                  BooklyTextField(
                    label: 'Autor *',
                    hintText: 'Ex: J.R.R. Tolkien',
                    controller: _autorController,
                  ),
                  const SizedBox(height: 12),
                  BooklyTextField(
                    label: 'Sinopse (opcional)',
                    hintText: 'Escreva uma breve descrição do livro…',
                    controller: _sinopseController,
                    maxLines: 4,
                  ),
                  const SizedBox(height: 12),
                  _buildGeneroField(),
                ],
              ),
            ),
            const SizedBox(height: 12),
            BooklyCardSection(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BooklySectionLabel(
                    texto: 'Preço',
                    cor: AppColors.catalogo,
                  ),
                  const SizedBox(height: 14),
                  BooklyTextField(
                    label: 'Preço (R\$)',
                    hintText: '0,00',
                    controller: _precoController,
                    keyboardType: TextInputType.number,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            BooklyActionButton(
              label: 'Salvar alterações',
              onPressed: _podeSubmeter ? _salvar : null,
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              height: 43,
              child: OutlinedButton.icon(
                onPressed: _excluir,
                icon: Icon(
                  Icons.delete_outline,
                  size: 16,
                  color: AppColors.danger,
                ),
                label: Text(
                  'Excluir livro',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColors.danger,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: AppColors.danger, width: 1.5),
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

  Widget _buildGeneroField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BooklyTextField(
          label: 'Gênero',
          hintText: 'Ex: Fantasia',
          controller: _generoController,
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 6,
          runSpacing: 6,
          children: _generosSugeridos.map((g) {
            final selecionado =
                _generoController.text.trim().toLowerCase() ==
                    g.toLowerCase();
            return GestureDetector(
              onTap: () => setState(() => _generoController.text = g),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: selecionado
                      ? AppColors.catalogo
                      : AppColors.catalogo.withValues(alpha: 0.07),
                  borderRadius: BorderRadius.circular(99),
                  border: Border.all(
                    color: selecionado
                        ? AppColors.catalogo
                        : AppColors.catalogo.withValues(alpha: 0.2),
                    width: 1,
                  ),
                ),
                child: Text(
                  g,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: selecionado ? Colors.white : AppColors.catalogo,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}