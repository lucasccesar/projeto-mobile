import 'package:flutter/material.dart';
import '../widgets/bookly_logo.dart';
import '../widgets/bookly_text_field.dart';
import '../widgets/bookly_primary_button.dart';
import '../widgets/bookly_link_button.dart';
import 'catalogo_page.dart';

class CriarContaPage extends StatefulWidget {
  const CriarContaPage({super.key});

  @override
  State<CriarContaPage> createState() => _CriarContaPageState();
}

class _CriarContaPageState extends State<CriarContaPage> {
  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();
  final _confirmarSenhaController = TextEditingController();
  bool _senhaVisivel = false;
  bool _confirmarSenhaVisivel = false;

  static const Color _fundo = Color(0xFFF5F0E8);
  static const Color _cardFundo = Color(0xFFF0EAD8);

  @override
  void dispose() {
    _nomeController.dispose();
    _emailController.dispose();
    _senhaController.dispose();
    _confirmarSenhaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _fundo,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const BooklyLogo(),
                const SizedBox(height: 32),
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: _cardFundo,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Center(
                        child: Text(
                          'Junte-se à nossa comunidade de leitores!',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 13, color: Color(0xFF5A5A50)),
                        ),
                      ),
                      const SizedBox(height: 20),
                      BooklyTextField(
                        label: 'NOME COMPLETO',
                        hintText: 'Nome completo',
                        controller: _nomeController,
                      ),
                      const SizedBox(height: 16),
                      BooklyTextField(
                        label: 'EMAIL',
                        hintText: 'seu@email.com',
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 16),
                      BooklyTextField(
                        label: 'SENHA',
                        hintText: 'Senha',
                        controller: _senhaController,
                        obscureText: !_senhaVisivel,
                        suffixIcon: IconButton(
                          icon: Icon(
                            _senhaVisivel ? Icons.visibility_off : Icons.visibility,
                            color: const Color(0xFFAAAAAA),
                            size: 20,
                          ),
                          onPressed: () => setState(() => _senhaVisivel = !_senhaVisivel),
                        ),
                      ),
                      const SizedBox(height: 16),
                      BooklyTextField(
                        label: 'CONFIRMAR SENHA',
                        hintText: 'Confirmar Senha',
                        controller: _confirmarSenhaController,
                        obscureText: !_confirmarSenhaVisivel,
                        suffixIcon: IconButton(
                          icon: Icon(
                            _confirmarSenhaVisivel ? Icons.visibility_off : Icons.visibility,
                            color: const Color(0xFFAAAAAA),
                            size: 20,
                          ),
                          onPressed: () => setState(() => _confirmarSenhaVisivel = !_confirmarSenhaVisivel),
                        ),
                      ),
                      const SizedBox(height: 24),
                      BooklyPrimaryButton(
                        label: 'Criar Conta',
                        onPressed: () => Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (_) => const CatalogoPage()),
                          (route) => false,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Center(
                        child: BooklyLinkButton(
                          label: 'Já tenho uma conta',
                          onPressed: () => Navigator.pop(context),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
