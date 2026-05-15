import 'package:flutter/material.dart';
import '../widgets/text_field.dart';
import '../widgets/primary_button.dart';
import '../widgets/link_button.dart';
import 'email_enviado.dart';

class RecuperarSenhaPage extends StatefulWidget {
  const RecuperarSenhaPage({super.key});

  @override
  State<RecuperarSenhaPage> createState() => _RecuperarSenhaPageState();
}

class _RecuperarSenhaPageState extends State<RecuperarSenhaPage> {
  final _emailController = TextEditingController();

  static const Color _fundo = Color(0xFFF5F0E8);
  static const Color _cardFundo = Color(0xFFF0EAD8);

  @override
  void dispose() {
    _emailController.dispose();
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
                Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8E2D4),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Center(
                    child: Text('🔑', style: TextStyle(fontSize: 36)),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Recuperar Senha',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4A4A40),
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Insira seu e-mail e enviaremos um link\npara redefinir sua senha.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, color: Color(0xFF7A7A6E)),
                ),
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
                      BooklyTextField(
                        label: 'EMAIL',
                        hintText: 'seu@email.com',
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 24),
                      PrimaryButton(
                        label: 'Enviar Link',
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const EmailEnviadoPage()),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Center(
                        child: LinkButton(
                          label: 'Voltar ao login',
                          icone: Icons.arrow_back,
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
