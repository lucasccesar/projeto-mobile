import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:projeto_mobile/services/auth_service.dart';
import '../widgets/logo.dart';
import '../widgets/text_field.dart';
import '../widgets/primary_button.dart';
import '../widgets/link_button.dart';
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
  final _nascimentoController = TextEditingController();
  final _authService = AuthService();
  bool _senhaVisivel = false;
  bool _confirmarSenhaVisivel = false;
  bool _carregando = false;

  static const Color _fundo = Color(0xFFF5F0E8);
  static const Color _cardFundo = Color(0xFFF0EAD8);

  @override
  void dispose() {
    _nomeController.dispose();
    _emailController.dispose();
    _senhaController.dispose();
    _confirmarSenhaController.dispose();
    _nascimentoController.dispose();
    super.dispose();
  }

  Future<void> _selecionarNascimento() async {
    final agora = DateTime.now();
    final data = await showDatePicker(
      context: context,
      initialDate: _parseData(_nascimentoController.text) ??
          DateTime(agora.year - 18, agora.month, agora.day),
      firstDate: DateTime(1900),
      lastDate: agora,
      helpText: 'Data de nascimento',
      cancelText: 'Cancelar',
      confirmText: 'Confirmar',
    );
    if (data != null) {
      _nascimentoController.text =
          '${data.day.toString().padLeft(2, '0')}/'
          '${data.month.toString().padLeft(2, '0')}/${data.year}';
    }
  }

  Future<void> _criarConta() async {
    final nome = _nomeController.text.trim();
    final email = _emailController.text.trim();
    final senha = _senhaController.text;
    final confirmar = _confirmarSenhaController.text;

    if (nome.isEmpty || email.isEmpty || senha.isEmpty) {
      _mostrarErro('Preencha todos os campos');
      return;
    }
    final nascimento = _parseData(_nascimentoController.text);
    if (nascimento == null) {
      _mostrarErro('Data de nascimento inválida (use dd/mm/aaaa)');
      return;
    }
    if (senha != confirmar) {
      _mostrarErro('As senhas não coincidem');
      return;
    }

    setState(() => _carregando = true);
    try {
      await _authService.cadastrar(
        nome: nome,
        email: email,
        senha: senha,
        nascimento: nascimento,
      );
      if (!mounted) return;
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const CatalogoPage()),
        (route) => false,
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

  /// Converte "dd/mm/aaaa" em DateTime; retorna null se a data for inválida.
  DateTime? _parseData(String texto) {
    final partes = texto.split('/');
    if (partes.length != 3) return null;
    final dia = int.tryParse(partes[0]);
    final mes = int.tryParse(partes[1]);
    final ano = int.tryParse(partes[2]);
    if (dia == null || mes == null || ano == null) return null;
    final data = DateTime(ano, mes, dia);
    // rejeita datas impossíveis (ex.: 31/02) e datas futuras
    if (data.year != ano || data.month != mes || data.day != dia) return null;
    if (data.isAfter(DateTime.now())) return null;
    return data;
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
                const Logo(),
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
                        label: 'DATA DE NASCIMENTO',
                        hintText: 'dd/mm/aaaa',
                        controller: _nascimentoController,
                        keyboardType: TextInputType.number,
                        inputFormatters: [_DataInputFormatter()],
                        suffixIcon: IconButton(
                          icon: const Icon(
                            Icons.calendar_today,
                            color: Color(0xFFAAAAAA),
                            size: 20,
                          ),
                          onPressed: _selecionarNascimento,
                        ),
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
                      PrimaryButton(
                        label: _carregando ? 'Criando...' : 'Criar Conta',
                        onPressed: _carregando ? null : _criarConta,
                      ),
                      const SizedBox(height: 16),
                      Center(
                        child: LinkButton(
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

/// Formata a digitação como dd/mm/aaaa, inserindo as barras automaticamente.
class _DataInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digitos = newValue.text.replaceAll(RegExp(r'\D'), '');
    final buffer = StringBuffer();
    for (var i = 0; i < digitos.length && i < 8; i++) {
      if (i == 2 || i == 4) buffer.write('/');
      buffer.write(digitos[i]);
    }
    final texto = buffer.toString();
    return TextEditingValue(
      text: texto,
      selection: TextSelection.collapsed(offset: texto.length),
    );
  }
}
