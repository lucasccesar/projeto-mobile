import 'package:flutter/material.dart';
import '../widgets/primary_button.dart';
import '../widgets/link_button.dart';

class EmailEnviadoPage extends StatelessWidget {
  const EmailEnviadoPage({super.key});

  static const Color _fundo = Color(0xFFF5F0E8);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _fundo,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8E2D4),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(
                    Icons.mail_outline_rounded,
                    size: 40,
                    color: Color(0xFFAAAAAA),
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Email Enviado!',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4A4A40),
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Verifique sua caixa de entrada e clique no\nlink para redefinir sua senha.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, color: Color(0xFF7A7A6E)),
                ),
                const SizedBox(height: 32),
                PrimaryButton(
                  label: 'Voltar ao Login',
                  onPressed: () => Navigator.popUntil(
                    context,
                    (route) => route.isFirst,
                  ),
                ),
                const SizedBox(height: 16),
                LinkButton(
                  label: 'Reenviar Email',
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
