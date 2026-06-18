import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:projeto_mobile/services/auth_service.dart';
import 'package:projeto_mobile/View/widgets/avatar_selector.dart';
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
  final _adminCodeController = TextEditingController();
  final _authService = AuthService();
  bool _senhaVisivel = false;
  bool _confirmarSenhaVisivel = false;
  bool _carregando = false;
  int? _avatarSelecionado;

  @override
  void dispose() {
    _nomeController.dispose();
    _emailController.dispose();
    _senhaController.dispose();
    _confirmarSenhaController.dispose();
    _nascimentoController.dispose();
    _adminCodeController.dispose();
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
    if (_avatarSelecionado == null) {
      _mostrarErro('Selecione uma foto de perfil');
      return;
    }

    setState(() => _carregando = true);
    try {
      await _authService.cadastrar(
        nome: nome,
        email: email,
        senha: senha,
        nascimento: nascimento,
        adminCode: _adminCodeController.text.trim(),
        avatarId: _avatarSelecionado,
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

  DateTime? _parseData(String texto) {
    final partes = texto.split('/');
    if (partes.length != 3) return null;
    final dia = int.tryParse(partes[0]);
    final mes = int.tryParse(partes[1]);
    final ano = int.tryParse(partes[2]);
    if (dia == null || mes == null || ano == null) return null;
    final data = DateTime(ano, mes, dia);
    if (data.year != ano || data.month != mes || data.day != dia) return null;
    if (data.isAfter(DateTime.now())) return null;
    return data;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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
                    color: Theme.of(context).colorScheme.secondary,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Text(
                          'Junte-se à nossa comunidade de leitores!',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 13,
                            color: Theme.of(context).colorScheme.onSurface
                                .withValues(alpha: 0.7),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      AvatarSelector(
                        selectedAvatarId: _avatarSelecionado,
                        onSelected: (id) =>
                            setState(() => _avatarSelecionado = id),
                      ),
                      const SizedBox(height: 16),
                      BooklyTextField(
                        label: 'NOME COMPLETO*',
                        hintText: 'Nome completo',
                        controller: _nomeController,
                      ),
                      const SizedBox(height: 16),
                      BooklyTextField(
                        label: 'EMAIL*',
                        hintText: 'seu@email.com',
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 16),
                      BooklyTextField(
                        label: 'DATA DE NASCIMENTO*',
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
                        label: 'SENHA*',
                        hintText: 'Senha',
                        controller: _senhaController,
                        obscureText: !_senhaVisivel,
                        suffixIcon: IconButton(
                          icon: Icon(
                            _senhaVisivel ? Icons.visibility_off : Icons.visibility,
                            color: const Color(0xFFAAAAAA),
                            size: 20,
                          ),
                          onPressed: () =>
                              setState(() => _senhaVisivel = !_senhaVisivel),
                        ),
                      ),
                      const SizedBox(height: 16),
                      BooklyTextField(
                        label: 'CONFIRMAR SENHA*',
                        hintText: 'Confirmar Senha',
                        controller: _confirmarSenhaController,
                        obscureText: !_confirmarSenhaVisivel,
                        suffixIcon: IconButton(
                          icon: Icon(
                            _confirmarSenhaVisivel
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: const Color(0xFFAAAAAA),
                            size: 20,
                          ),
                          onPressed: () => setState(
                              () => _confirmarSenhaVisivel = !_confirmarSenhaVisivel),
                        ),
                      ),
                      const SizedBox(height: 16),
                      BooklyTextField(
                        label: 'CÓDIGO DE ADM',
                        hintText: 'Apenas para conta de administrador',
                        controller: _adminCodeController,
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