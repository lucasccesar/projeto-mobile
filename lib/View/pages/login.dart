import 'package:flutter/material.dart';
import 'package:projeto_mobile/View/pages/splash_page.dart';
import 'package:projeto_mobile/services/auth_service.dart';
import 'package:projeto_mobile/View/widgets/theme_toggle_button.dart';
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
    final cardFundo = Theme.of(context).colorScheme.secondary;
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Stack(
          children: [
            Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 28,
                  vertical: 24,
                ),
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
                      cardFundo: cardFundo,
                      carregando: _carregando,
                      onEntrar: _entrar,
                    ),
                  ],
                ),
              ),
            ),
            const Positioned(top: 4, right: 4, child: ThemeToggleButton()),
          ],
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
          Center(
            child: Text(
              'Entre com sua conta para continuar',
              style: TextStyle(
                fontSize: 13,
                color: Theme.of(
                  context,
                ).colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
          ),
          const SizedBox(height: 20),
          BooklyTextField(
            label: 'EMAIL',
            hintText: 'seu@email.com',
            controller: emailController,
            keyboardType: TextInputType.emailAddress,
            fillColor: Theme.of(context).colorScheme.surface,
            showBorder: false,
          ),
          const SizedBox(height: 16),
          BooklyTextField(
            label: 'SENHA',
            hintText: 'Senha',
            controller: senhaController,
            obscureText: !senhaVisivel,
            fillColor: Theme.of(context).colorScheme.surface,
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
          // const SizedBox(height: 16), 
          // LinkButton(
          //   label: 'animação de entrada',
          //   onPressed: () => Navigator.pushReplacement(
          //     context,
          //     MaterialPageRoute(builder: (_) => const SplashPage()),
          //   ),
          // ),
        ],
      ),
    );
  }
}
