import 'package:flutter/material.dart';
import 'package:projeto_mobile/View/widgets/appbar_widget.dart';
import 'package:projeto_mobile/View/widgets/primary_button.dart';
import 'package:projeto_mobile/View/widgets/text_field.dart';
import 'package:projeto_mobile/View/widgets/colecao_form_widgets.dart';
import 'package:projeto_mobile/config/app_colors.dart';
import 'package:projeto_mobile/config/token_config.dart';
import 'package:projeto_mobile/services/usuario_service.dart';

class PerfilEditar extends StatefulWidget {
  const PerfilEditar({super.key});

  @override
  State<PerfilEditar> createState() => _PerfilEditarState();
}

class _PerfilEditarState extends State<PerfilEditar> {
  final UsuarioService _usuarioService = UsuarioService();
  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();
  final _senhaAtualController = TextEditingController();
  final _novaSenhaController = TextEditingController();
  final _confirmarSenhaController = TextEditingController();
  bool _salvando = false;

  bool get _senhasValidas {
    if (_novaSenhaController.text.isEmpty) return true; 
    return _novaSenhaController.text == _confirmarSenhaController.text;
        //_novaSenhaController.text.length >= 4;
  }

  bool get _podeSalvar =>
      _nomeController.text.trim().isNotEmpty &&
      _emailController.text.trim().isNotEmpty &&
      _senhaAtualController.text.trim().isNotEmpty &&
      _senhasValidas &&
      !_salvando;

  @override
  void initState() {
    super.initState();
    final usuario = TokenConfig.usuario;
    _nomeController.text = usuario?.nome ?? '';
    _emailController.text = usuario?.email ?? '';

    _nomeController.addListener(() => setState(() {}));
    _emailController.addListener(() => setState(() {}));
    _senhaAtualController.addListener(() => setState(() {}));
    _novaSenhaController.addListener(() => setState(() {}));
    _confirmarSenhaController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _emailController.dispose();
    _senhaAtualController.dispose();
    _novaSenhaController.dispose();
    _confirmarSenhaController.dispose();
    super.dispose();
  }

 Future<void> _salvarAlteracoes() async {
  if (!_podeSalvar) return;

  if (_novaSenhaController.text.isNotEmpty &&
      _novaSenhaController.text != _confirmarSenhaController.text) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('As senhas não coincidem')),
    );
    return;
  }

  setState(() => _salvando = true);

  try {
    final usuarioAtualizado = await _usuarioService.atualizarUsuario(
      id: TokenConfig.userId!,
      nome: _nomeController.text.trim(),
      email: _emailController.text.trim(),
      currentPassword: _senhaAtualController.text, 
      newPassword: _novaSenhaController.text.isNotEmpty
          ? _novaSenhaController.text
          : null, 
    );

    TokenConfig.usuario = usuarioAtualizado;

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Perfil atualizado com sucesso!')),
    );
    Navigator.pop(context);
  } catch (e) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(e.toString().replaceAll('Exception: ', ''))), 
    );
  } finally {
    setState(() => _salvando = false);
  }
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
                    texto: 'Senha',
                    cor: AppColors.perfil,
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Informe sua senha atual para confirmar as mudanças. Preencha os campos abaixo apenas se quiser trocá-la.',
                    style: TextStyle(
                      fontSize: 12,
                      color: Theme.of(context).colorScheme.tertiary.withOpacity(0.7),
                    ),
                  ),
                  SizedBox(height: 16),
                  BooklyTextField(
                    label: 'Senha atual *',
                    hintText: 'Senha atual',
                    controller: _senhaAtualController,
                    obscureText: true,
                    showBorder: true,
                  ),
                  SizedBox(height: 16),
                  BooklyTextField(
                    label: 'Nova senha',
                    hintText: 'Nova senha (opcional)',
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

            PrimaryButton(
              label: _salvando ? 'Salvando...' : 'Salvar alterações',
              onPressed: _podeSalvar ? _salvarAlteracoes : null,
            ),
          ],
        ),
      ),
    );
  }
}