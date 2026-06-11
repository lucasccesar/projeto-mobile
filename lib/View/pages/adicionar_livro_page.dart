import 'package:flutter/material.dart';
import 'package:projeto_mobile/config/app_colors.dart';
import 'package:projeto_mobile/models/book.dart';
import 'package:projeto_mobile/services/book_service.dart';
import 'package:projeto_mobile/View/widgets/appbar_widget.dart';
import 'package:projeto_mobile/View/widgets/text_field.dart';
import 'package:projeto_mobile/View/widgets/colecao_form_widgets.dart';

class AdicionarLivroPage extends StatefulWidget {
  const AdicionarLivroPage({super.key});

  @override
  State<AdicionarLivroPage> createState() => _AdicionarLivroPageState();
}

class _AdicionarLivroPageState extends State<AdicionarLivroPage> {
  final _bookService = BookService();

  String _titulo = '';
  String _autores = '';
  String _isbn = '';
  String _preco = '';
  String _genero = '';
  String _sinopse = '';
  String _paginas = '';
  String _ano = '';
  bool _enviando = false;

  bool get _podeSubmeter =>
      _titulo.trim().isNotEmpty &&
      _autores.trim().isNotEmpty &&
      _isbn.trim().isNotEmpty &&
      _preco.trim().isNotEmpty &&
      _genero.trim().isNotEmpty &&
      _sinopse.trim().isNotEmpty &&
      _paginas.trim().isNotEmpty &&
      _ano.trim().isNotEmpty;

  Future<void> _submeter() async {
    setState(() => _enviando = true);
    try {
      final livro = await _bookService.criarLivro(
        titulo: _titulo.trim(),
        autores: _autores.trim(),
        genero: _genero.trim(),
        preco: double.tryParse(_preco.trim().replaceAll(',', '.')) ?? 0.0,
        sinopse: _sinopse.trim(),
        isbn: _isbn.trim(),
        paginas: int.tryParse(_paginas.trim()) ?? 0,
        ano: int.tryParse(_ano.trim()) ?? 0,
      );
      if (mounted) Navigator.pop(context, livro);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString().replaceFirst('Exception: ', ''))),
        );
      }
    } finally {
      if (mounted) setState(() => _enviando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BooklyAppBar(
        title: 'Adicionar Livro',
        corDoTexto: AppColors.catalogo,
        iconeMenu: false,
        iconeSeta: true,
        iconeCarrinho: false,
      ),
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            CardSection(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SectionLabel(texto: 'Informações', cor: AppColors.catalogo),
                  const SizedBox(height: 13),
                  BooklyTextField(
                    label: 'TÍTULO DO LIVRO',
                    hintText: 'Ex: O Senhor dos Anéis',
                    onChanged: (v) => setState(() => _titulo = v),
                  ),
                  const SizedBox(height: 13),
                  BooklyTextField(
                    label: 'AUTOR(ES)',
                    hintText: 'Ex: J.R.R. Tolkien',
                    onChanged: (v) => setState(() => _autores = v),
                  ),
                  const SizedBox(height: 13),
                  BooklyTextField(
                    label: 'GÊNERO',
                    hintText: 'Ex: Fantasia, Romance, Distopia...',
                    onChanged: (v) => setState(() => _genero = v),
                  ),
                  const SizedBox(height: 13),
                  Row(
                    children: [
                      Expanded(
                        child: BooklyTextField(
                          label: 'ISBN',
                          hintText: '978-...',
                          onChanged: (v) => setState(() => _isbn = v),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: BooklyTextField(
                          label: 'PREÇO (R\$)',
                          hintText: '89,90',
                          onChanged: (v) => setState(() => _preco = v),
                          keyboardType: const TextInputType.numberWithOptions(
                              decimal: true),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 13),
                  BooklyTextField(
                    label: 'SINOPSE',
                    hintText: 'Descreva o livro...',
                    onChanged: (v) => setState(() => _sinopse = v),
                    maxLines: 4,
                  ),
                  const SizedBox(height: 13),
                  Row(
                    children: [
                      Expanded(
                        child: BooklyTextField(
                          label: 'Nº DE PÁGINAS',
                          hintText: '000',
                          onChanged: (v) => setState(() => _paginas = v),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: BooklyTextField(
                          label: 'ANO',
                          hintText: '2024',
                          onChanged: (v) => setState(() => _ano = v),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            ActionButton(
              label: _enviando ? 'Adicionando...' : 'Adicionar Livro',
              cor: AppColors.catalogo,
              onPressed: (_podeSubmeter && !_enviando) ? _submeter : null,
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: _enviando ? null : () => Navigator.pop(context),
              child: Text(
                'Cancelar',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.tertiary,
                  fontSize: 14,
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