import 'package:flutter/material.dart';
import 'package:projeto_mobile/View/widgets/appbar_widget.dart';
import 'package:projeto_mobile/View/widgets/primary_button.dart';
import 'package:projeto_mobile/View/widgets/text_field.dart';
import 'package:projeto_mobile/View/widgets/colecao_form_widgets.dart';
import 'package:projeto_mobile/config/app_colors.dart';

class PerfilEditar extends StatefulWidget {
  const PerfilEditar({super.key});

  @override
  State<PerfilEditar> createState() => _PerfilEditarState();
}

class _PerfilEditarState extends State<PerfilEditar> {
  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();
  final _senhaAtualController = TextEditingController();
  final _novaSenhaController = TextEditingController();
  final _confirmarSenhaController = TextEditingController();

  @override
  void dispose() {
    _nomeController.dispose();
    _emailController.dispose();
    _senhaAtualController.dispose();
    _novaSenhaController.dispose();
    _confirmarSenhaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BooklyAppBar(
        title: 'Editar Conta',
        iconeMenu: false,
        iconeCarrinho: false,
        iconeSeta: true,
        corDoTexto: AppColors.perfil,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            //icone
            Center(
              child: CircleAvatar(
                radius: 40,
                backgroundColor: Theme.of(context).colorScheme.secondary,
                child: Icon(Icons.person, size: 40, color: AppColors.clube),
              ),
            ),

            SizedBox(height: 24),

            CardSection(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SectionLabel(
                    texto: 'Informações Pessoais',
                    cor: Theme.of(context).colorScheme.tertiary,
                  ),

                  SizedBox(height: 16),

                  BooklyTextField(
                    label: 'Nome completo',
                    hintText: 'Seu nome',
                    controller: _nomeController,
                    showBorder: true,
                  ),

                  SizedBox(height: 16),

                  BooklyTextField(
                    label: 'Email',
                    hintText: 'seu@email.com',
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    showBorder: true,
                  ),
                ],
              ),
            ),

            SizedBox(height: 16),

            CardSection(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SectionLabel(
                    texto: 'Alterar Senha', //TODO: validar se as senhas sao iguais
                    cor: AppColors.perfil,
                  ),

                  SizedBox(height: 16),

                  BooklyTextField(
                    label: 'Senha atual',
                    hintText: 'Senha atual',
                    controller: _senhaAtualController,
                    obscureText: true,
                    showBorder: true,
                  ),

                  SizedBox(height: 16),

                  BooklyTextField(
                    label: 'Nova senha',
                    hintText: 'Nova senha',
                    controller: _novaSenhaController,
                    obscureText: true,
                    showBorder: true,
                  ),

                  SizedBox(height: 16),

                  BooklyTextField(
                    label: 'Confirmar nova senha',
                    hintText: 'Repita a nova senha',
                    controller: _confirmarSenhaController,
                    obscureText: true,
                    showBorder: true,
                  ),
                ],
              ),
            ),

            SizedBox(height: 24),

            // Botão Salvar
            PrimaryButton(label: 'Salvar alterações',
             onPressed: () {
              //TODO: Linkar com o backend
             }),
          ],
        ),
      ),
    );
  }
}
