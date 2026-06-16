import 'package:flutter/material.dart';
import 'package:projeto_mobile/config/app_colors.dart';
import 'package:projeto_mobile/services/colecao_service.dart';
import 'package:projeto_mobile/View/widgets/appbar_widget.dart';

class ColecaoCriarPage extends StatefulWidget {
  const ColecaoCriarPage({super.key});

  @override
  State<ColecaoCriarPage> createState() => _ColecaoCriarPageState();
}

class _ColecaoCriarPageState extends State<ColecaoCriarPage> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _descricaoController = TextEditingController();
  final _service = ColecaoService();
  bool _carregando = false;

  @override
  void dispose() {
    _nomeController.dispose();
    _descricaoController.dispose();
    super.dispose();
  }

  Future<void> _salvar() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _carregando = true);
    try {
      await _service.criar(
        nome: _nomeController.text.trim(),
        descricao: _descricaoController.text.trim(),
      );
      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString().replaceFirst('Exception: ', '')),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _carregando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: BooklyAppBar(
        title: 'Nova Coleção',
        corDoTexto: AppColors.colecao,
        iconeMenu: false,
        iconeSeta: true,
        iconeCarrinho: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Nome',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 6),
              TextFormField(
                controller: _nomeController,
                decoration: InputDecoration(
                  hintText: 'Ex: Favoritos',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                ),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Informe o nome' : null,
              ),
              const SizedBox(height: 16),
              const Text(
                'Descrição',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 6),
              TextFormField(
                controller: _descricaoController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: 'Ex: Livros que mais gostei',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                ),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Informe a descrição' : null,
              ),
              const SizedBox(height: 28),
              SizedBox(
                width: double.infinity,
                height: 46,
                child: ElevatedButton(
                  onPressed: _carregando ? null : _salvar,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.colecao,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(99),
                    ),
                  ),
                  child: _carregando
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text(
                          'Criar Coleção',
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}