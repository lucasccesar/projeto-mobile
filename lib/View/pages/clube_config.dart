import 'package:flutter/material.dart';
import 'package:projeto_mobile/View/widgets/bookly_appbar_widget.dart';
import 'package:projeto_mobile/View/widgets/bookly_text_field.dart';
import 'package:projeto_mobile/View/widgets/clube_mebro.dart';
import 'package:projeto_mobile/config/app_colors.dart';

class ClubeConfig extends StatefulWidget {
  const ClubeConfig({super.key});

  @override
  State<ClubeConfig> createState() => _ClubeConfigState();
}

class _ClubeConfigState extends State<ClubeConfig> {
  final _nomeController = TextEditingController();
  final _temaController = TextEditingController();
  final _descricaoController = TextEditingController();
  final _limiteMembrosController = TextEditingController();
  final _buscarLivroController = TextEditingController();
  final _nomeOuCargoController = TextEditingController();

  @override
  void dispose() {
    _nomeController.dispose();
    _temaController.dispose();
    _descricaoController.dispose();
    _limiteMembrosController.dispose();
    _buscarLivroController.dispose();
    _nomeOuCargoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BooklyAppBar(
        title: 'Config. do Clube',
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
                    'INFORMAÇÕES DO CLUBE',
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
                spacing: 12,
                children: [

                  BooklyTextField(
                    label: 'Busque um Membro',
                    hintText: 'Digite seu nome/cargo',
                    controller: _nomeOuCargoController,
                    showBorder: true,
                  ),

                  SizedBox(height:1),

                  ClubeMembro(
                    cargo: 'membro',
                    nome: 'Pedro',
                    mostrarRemover: true,
                    //TODO: logica de remover
                    onRemover: () {},
                  ),
                  ClubeMembro(
                    cargo: 'membro',
                    nome: 'Joao',
                    mostrarRemover: true,
                    onRemover: () {},
                  ),
                  ClubeMembro(
                    cargo: 'membro',
                    nome: 'lucas',
                    mostrarRemover: true,
                    onRemover: () {},
                  ),
                  ClubeMembro(
                    cargo: 'Admin',
                    nome: 'Elisson',
                    mostrarRemover: true,
                    onRemover: () {},
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
