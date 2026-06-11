import 'package:flutter/material.dart';
import 'package:projeto_mobile/services/auth_service.dart';
import '../widgets/logo.dart';
import '../widgets/text_field.dart';
import '../widgets/primary_button.dart';
import '../widgets/link_button.dart';
import 'recuperar_senha.dart';
import 'cadastro.dart';
import 'catalogo_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();
  final _authService = AuthService();
  bool _senhaVisivel = false;
  bool _carregando = false;

  static const Color _fundo = Color(0xFFF5F0E8);
  static const Color _cardFundo = Color(0xFFF0EAD8);

  @override
  void dispose() {
    _emailController.dispose();
    _senhaController.dispose();
    super.dispose();
  }

  Future<void> _entrar() async {
    final email = _emailController.text.trim();
    final senha = _senhaController.text;

    if (email.isEmpty || senha.isEmpty) {
      _mostrarErro('Preencha email e senha');
      return;
    }

    setState(() => _carregando = true);
    try {
      await _authService.login(email, senha);
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const CatalogoPage()),
      );
    } catch (e) {
      if (!mounted) return;
      _mostrarErro(e.toString().replaceFirst('Exception: ', ''));
    } finally {
      if (mounted) setState(() => _carregando = false);
    }
  }

  void _mostrarErro(String mensagem) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(mensagem), backgroundColor: Colors.red),
    );
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
                const Logo(subtitle: 'Sua biblioteca digital favorita'),
                const SizedBox(height: 32),
                _LoginCard(
                  emailController: _emailController,
                  senhaController: _senhaController,
                  senhaVisivel: _senhaVisivel,
                  onToggleSenha: () =>
                      setState(() => _senhaVisivel = !_senhaVisivel),
                  cardFundo: _cardFundo,
                  carregando: _carregando,
                  onEntrar: _entrar,
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
  final bool carregando;
  final VoidCallback onEntrar;

  const _LoginCard({
    required this.emailController,
    required this.senhaController,
    required this.senhaVisivel,
    required this.onToggleSenha,
    required this.cardFundo,
    required this.carregando,
    required this.onEntrar,
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
            fillColor: Colors.white,
            showBorder: false,
          ),
          const SizedBox(height: 16),
          BooklyTextField(
            label: 'SENHA',
            hintText: 'Senha',
            controller: senhaController,
            obscureText: !senhaVisivel,
            fillColor: Colors.white,
            showBorder: false,
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
          PrimaryButton(
            label: carregando ? 'Entrando...' : 'Entrar',
            onPressed: carregando ? null : onEntrar,
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              LinkButton(
                label: 'Criar conta',
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const CriarContaPage()),
                ),
              ),
              LinkButton(
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
