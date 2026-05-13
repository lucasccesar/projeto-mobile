import 'package:flutter/material.dart';
import 'package:projeto_mobile/View/widgets/bookly_appbar_widget.dart';
import 'package:projeto_mobile/View/widgets/bookly_primary_button.dart';
import 'package:projeto_mobile/View/widgets/bookly_text_field.dart';
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
                backgroundColor: Colors.grey.shade200,
                child: Icon(Icons.person, size: 40, color: AppColors.clube),
              ),
            ),

            SizedBox(height: 24),

            // Seção Informações Pessoais
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
                    'INFORMAÇÕES PESSOAIS',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.0,
                      color: Theme.of(context).colorScheme.tertiary,
                    ),
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

            // Seção Alterar Senha
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
                    //TODO: validar se as senhas sao iguais
                    'ALTERAR SENHA',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.0,
                      color: AppColors.perfil,
                    ),
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
            BooklyPrimaryButton(label: 'Salvar alterações',
             onPressed: () {
              //TODO: Linkar com o backend
             }),
          ],
        ),
      ),
    );
  }
}
