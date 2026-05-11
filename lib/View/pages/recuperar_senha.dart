import 'package:flutter/material.dart';
import '../widgets/bookly_text_field.dart';
import '../widgets/bookly_primary_button.dart';

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
                      BooklyPrimaryButton(label: 'Enviar Link', onPressed: () {}),
                      const SizedBox(height: 16),
                      Center(
                        child: TextButton.icon(
                          onPressed: () => Navigator.pop(context),
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          icon: const Icon(
                            Icons.arrow_back,
                            size: 14,
                            color: Color(0xFF5A5A50),
                          ),
                          label: const Text(
                            'Voltar ao login',
                            style: TextStyle(color: Color(0xFF5A5A50), fontSize: 13),
                          ),
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
