import 'package:flutter/material.dart';
import 'package:projeto_mobile/View/pages/clube_home.dart';
import 'package:projeto_mobile/View/widgets/bookly_appbar_widget.dart';
import 'package:projeto_mobile/View/widgets/bookly_livro_row_widget.dart';
import 'package:projeto_mobile/View/widgets/bookly_text_field.dart';
import 'package:projeto_mobile/View/widgets/colecao_form_widgets.dart';
import 'package:projeto_mobile/config/app_colors.dart';

class ClubeCriar extends StatefulWidget {
  const ClubeCriar({super.key});

  @override
  State<ClubeCriar> createState() => _ClubeCriarState();
}

class _ClubeCriarState extends State<ClubeCriar> {
  final _nomeController = TextEditingController();
  final _temaController = TextEditingController();
  final _descricaoController = TextEditingController();
  final _limiteMembrosController = TextEditingController();
  final _buscarLivroController = TextEditingController();

  @override
  void dispose() {
    _nomeController.dispose();
    _temaController.dispose();
    _descricaoController.dispose();
    _limiteMembrosController.dispose();
    _buscarLivroController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BooklyAppBar(
        title: 'Criar Clube',
        iconeMenu: false,
        iconeCarrinho: false,
        iconeSeta: true,
        corDoTexto: AppColors.clube,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                height: 72,
                width: 72,
                decoration: BoxDecoration(
                  color: AppColors.clube.withOpacity(0.157),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Icon(
                  Icons.book_outlined,
                  color: AppColors.clube,
                  size: 28,
                ),
              ),
            ),

            SizedBox(height: 20),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondary,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Theme.of(
                    context,
                  ).colorScheme.tertiary.withOpacity(0.2),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'SOBRE O CLUBE',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.0,
                      color: Theme.of(context).colorScheme.tertiary,
                    ),
                  ),

                  SizedBox(height: 16),

                  BooklyTextField(
                    label: 'Nome do clube *',
                    hintText: 'Ex: Leitores do Amanhã',
                    controller: _nomeController,
                    showBorder: true,
                  ),

                  SizedBox(height: 16),

                  BooklyTextField(
                    label: 'Tema / Gênero principal',
                    hintText: 'Ex: Aventura',
                    controller: _temaController,
                    showBorder: true,
                  ),

                  SizedBox(height: 16),

                  // Descrição
                  BooklyTextField(
                    label: 'Descrição',
                    hintText: 'Apresente o clube para novos membros...',
                    controller: _descricaoController,
                    maxLines: 3, //TODO: ajeitar limite no back
                    showBorder: true,
                  ),

                  SizedBox(height: 16),

                  // Limite de membros
                  BooklyTextField(
                    label: 'Limite de membros',
                    hintText: '10',
                    controller: _limiteMembrosController,
                    keyboardType: TextInputType.number,
                    showBorder: true,
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondary,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Theme.of(
                    context,
                  ).colorScheme.tertiary.withOpacity(0.2),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'ADICIONAR LIVRO',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.0,
                      color: Theme.of(context).colorScheme.tertiary,
                    ),
                  ),
                  BooklyTextField(
                    hintText: 'Buscar livro…',
                    controller: _buscarLivroController,
                  ),
                  //TODO: terminar logica
                  BooklyLivroRow(
                    titulo: 'Molodoy',
                    autor: 'Fallen',
                    cor: AppColors.clube,
                  ),
                ],
              ),
            ),

            Padding(
              padding: EdgeInsets.fromLTRB(0, 18, 0, 18),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const ClubeHome()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.clube,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: Text(
                    'Criar Clube do Livro',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
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
