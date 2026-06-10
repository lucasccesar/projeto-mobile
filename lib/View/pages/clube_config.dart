import 'package:flutter/material.dart';
import 'package:projeto_mobile/View/widgets/appbar_widget.dart';
import 'package:projeto_mobile/View/widgets/text_field.dart';
import 'package:projeto_mobile/View/widgets/clube_mebro.dart';
import 'package:projeto_mobile/View/widgets/colecao_form_widgets.dart';
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
  int membros = 4;


  bool get _podeConfirmar =>
      _nomeController.text.trim().isNotEmpty ||
      _temaController.text.trim().isNotEmpty ||
      _descricaoController.text.trim().isNotEmpty;

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
  void initState() {
    super.initState();
    _nomeController.addListener(() => setState(() {}));
    _temaController.addListener(() => setState(() {}));
    _descricaoController.addListener(() => setState(() {}));
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

            CardSection(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SectionLabel(
                    texto: 'Informações do Clube',
                    cor: AppColors.clube,
                  ),

                  SizedBox(height: 16),

                  BooklyTextField(
                    label: 'Nome do clube',
                    hintText: 'Ex: Leitores do Amanhã',
                    controller: _nomeController,
                    showBorder: true,
                  ),

                  SizedBox(height: 16),

                  BooklyTextField(
                    label: 'Tema / Gênero',
                    hintText: 'Ex: Aventura',
                    controller: _temaController,
                    showBorder: true,
                  ),

                  SizedBox(height: 16),

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

            CardSection(
              child: Column(
                spacing: 14,
                children: [
                  BooklyTextField(
                    label: 'MEMBROS ($membros)',
                    hintText: 'Digite seu nome/cargo',
                    controller: _nomeOuCargoController,
                    showBorder: true,
                  ),

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
            Padding(
              padding: EdgeInsets.fromLTRB(0, 18, 0, 18),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _podeConfirmar ? () {
                    //TODO: logica de config
                  } : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.clube,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: Text(
                    'Confirmar Mudanças',
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
