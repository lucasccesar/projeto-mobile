import 'package:flutter/material.dart';
import '../widgets/bookly_logo.dart';
import '../widgets/bookly_text_field.dart';
import '../widgets/bookly_primary_button.dart';
import 'recuperar_senha.dart';
import 'cadastro.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();
  bool _senhaVisivel = false;

  static const Color _fundo = Color(0xFFF5F0E8);
  static const Color _cardFundo = Color(0xFFF0EAD8);

  @override
  void dispose() {
    _emailController.dispose();
    _senhaController.dispose();
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
                const BooklyLogo(subtitle: 'Sua biblioteca digital favorita'),
                const SizedBox(height: 32),
                _LoginCard(
                  emailController: _emailController,
                  senhaController: _senhaController,
                  senhaVisivel: _senhaVisivel,
                  onToggleSenha: () =>
                      setState(() => _senhaVisivel = !_senhaVisivel),
                  cardFundo: _cardFundo,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _LoginCard extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController senhaController;
  final bool senhaVisivel;
  final VoidCallback onToggleSenha;
  final Color cardFundo;

  const _LoginCard({
    required this.emailController,
    required this.senhaController,
    required this.senhaVisivel,
    required this.onToggleSenha,
    required this.cardFundo,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: cardFundo,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Center(
            child: Text(
              'Entre com sua conta para continuar',
              style: TextStyle(fontSize: 13, color: Color(0xFF5A5A50)),
            ),
          ),
          const SizedBox(height: 20),
          BooklyTextField(
            label: 'EMAIL',
            hintText: 'seu@email.com',
            controller: emailController,
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 16),
          BooklyTextField(
            label: 'SENHA',
            hintText: 'Senha',
            controller: senhaController,
            obscureText: !senhaVisivel,
            suffixIcon: IconButton(
              icon: Icon(
                senhaVisivel ? Icons.visibility_off : Icons.visibility,
                color: const Color(0xFFAAAAAA),
                size: 20,
              ),
              onPressed: onToggleSenha,
            ),
          ),
          const SizedBox(height: 24),
          BooklyPrimaryButton(label: 'Entrar', onPressed: () {}),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _LinkButton(
                label: 'Criar conta',
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const CriarContaPage()),
                ),
              ),
              _LinkButton(
                label: 'Esqueci a senha',
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const RecuperarSenhaPage()),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _LinkButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const _LinkButton({required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        padding: EdgeInsets.zero,
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      child: Text(
        label,
        style: const TextStyle(color: Color(0xFF5A5A50), fontSize: 13),
      ),
    );
  }
}
