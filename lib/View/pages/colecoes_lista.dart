import 'package:flutter/material.dart';
import 'package:projeto_mobile/View/pages/colecao_criar_page.dart';
import 'package:projeto_mobile/View/pages/colecao_home_page.dart';
import 'package:projeto_mobile/View/widgets/appbar_widget.dart';
import 'package:projeto_mobile/View/widgets/colecao_card_widget.dart';
import 'package:projeto_mobile/View/widgets/rodape_widget.dart';
import 'package:projeto_mobile/View/widgets/sidebar_widget.dart';
import 'package:projeto_mobile/config/app_colors.dart';
import 'package:projeto_mobile/models/colecao.dart';
import 'package:projeto_mobile/services/colecao_service.dart';

class ColecoesListaPage extends StatefulWidget {
  const ColecoesListaPage({super.key});

  @override
  State<ColecoesListaPage> createState() => _ColecoesListaPageState();
}

class _ColecoesListaPageState extends State<ColecoesListaPage> {
  final _service = ColecaoService();
  late Future<List<Colecao>> _futuro;

  @override
  void initState() {
    super.initState();
    _futuro = _service.buscarPorUsuario();
  }

  void _recarregar() {
    setState(() {
      _futuro = _service.buscarPorUsuario();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: SidebarWidget(),
      appBar: BooklyAppBar(
        title: 'Coleções',
        corDoTexto: AppColors.colecao,
        iconeMenu: true,
        iconeSeta: false,
        iconeCarrinho: false,
      ),
      body: FutureBuilder<List<Colecao>>(
        future: _futuro,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.colecao),
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: Color(0xFFBBBBBB)),
                  const SizedBox(height: 12),
                  Text(
                    snapshot.error.toString().replaceFirst('Exception: ', ''),
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 14, color: Color(0xFF888888)),
                  ),
                  const SizedBox(height: 12),
                  TextButton.icon(
                    onPressed: _recarregar,
                    icon: const Icon(Icons.refresh, color: AppColors.colecao),
                    label: const Text(
                      'Tentar novamente',
                      style: TextStyle(color: AppColors.colecao),
                    ),
                  ),
                ],
              ),
            );
          }

          final colecoes = snapshot.data ?? [];

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const ColecaoCriarPage(),
                          ),
                        );
                        _recarregar();
                      },
                      icon: const Icon(Icons.add, size: 16),
                      label: const Text('Nova Coleção'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.colecao,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 8,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(99),
                        ),
                        textStyle: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                if (colecoes.isEmpty)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.only(top: 40),
                      child: Text(
                        'Nenhuma coleção ainda',
                        style: TextStyle(fontSize: 14, color: Color(0xFF888888)),
                      ),
                    ),
                  )
                else
                  _buildGrid(colecoes),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: const Rodape(),
    );
  }

  Widget _buildGrid(List<Colecao> colecoes) {
    final rows = <Widget>[];
    for (var i = 0; i < colecoes.length; i += 2) {
      final a = colecoes[i];
      final b = i + 1 < colecoes.length ? colecoes[i + 1] : null;
      rows.add(
        Row(
          children: [
            Expanded(
              child: ColecaoCardWidget(
                emoji: '📚',
                emojiBackgroundColor: AppColors.colecao,
                nome: a.name,
                quantidadeLivros: a.books.length,
                corQuantidade: AppColors.colecao,
                onTap: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ColecaoHomePage(colecao: a),
                    ),
                  );
                  _recarregar();
                },
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: b != null
                  ? ColecaoCardWidget(
                      emoji: '📖',
                      emojiBackgroundColor: AppColors.catalogo,
                      nome: b.name,
                      quantidadeLivros: b.books.length,
                      corQuantidade: AppColors.catalogo,
                      onTap: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ColecaoHomePage(colecao: b),
                          ),
                        );
                        _recarregar();
                      },
                    )
                  : const SizedBox(),
            ),
          ],
        ),
      );
      if (i + 2 < colecoes.length) rows.add(const SizedBox(height: 8));
    }
    return Column(children: rows);
  }
}