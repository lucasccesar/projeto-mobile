import 'package:flutter/material.dart';
import 'package:projeto_mobile/config/token_config.dart';
import 'package:projeto_mobile/models/reading_status.dart';
import 'package:projeto_mobile/View/widgets/appbar_widget.dart';
import 'package:projeto_mobile/View/widgets/livro_card_widget.dart';
import 'package:projeto_mobile/View/widgets/rodape_widget.dart';
import 'package:projeto_mobile/View/widgets/sidebar_widget.dart';
import 'package:projeto_mobile/services/reading_status_service.dart';

class StatusLeituraPage extends StatefulWidget {
  const StatusLeituraPage({super.key});

  @override
  State<StatusLeituraPage> createState() => _StatusLeituraPageState();
}

class _StatusLeituraPageState extends State<StatusLeituraPage> {
  final ReadingStatusService _readingStatusService = ReadingStatusService();
  late Future<List<ReadingStatus>> _futureStatuses;

  @override
  void initState() {
    super.initState();
    _futureStatuses = _carregarStatuses();
  }

  Future<List<ReadingStatus>> _carregarStatuses() async {
    final userId = TokenConfig.userId;
    if (userId == null || userId.isEmpty) {
      return [];
    }

    return _readingStatusService.fetchStatusesByUser(userId);
  }

  List<ReadingStatus> _filtrarPorStatus(
    List<ReadingStatus> statuses,
    List<String> statusDesejados,
  ) {
    return statuses
        .where((item) => statusDesejados.contains(item.status.toUpperCase()))
        .toList();
  }

  Future<void> _recarregar() async {
    final future = _carregarStatuses();
    setState(() {
      _futureStatuses = future;
    });
    await future;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      drawer: const SidebarWidget(),
      appBar: BooklyAppBar(
        title: 'Leitura',
        corDoTexto: const Color(0xFF3D9080),
        iconeMenu: true,
        iconeSeta: false,
        iconeCarrinho: false,
      ),
      body: FutureBuilder<List<ReadingStatus>>(
        future: _futureStatuses,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline_rounded,
                      size: 38,
                      color: Colors.redAccent,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      snapshot.error.toString().replaceFirst('Exception: ', ''),
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 14),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _recarregar,
                      child: const Text('Tentar novamente'),
                    ),
                  ],
                ),
              ),
            );
          }

          final statuses = snapshot.data ?? [];
          final lendoAgora = _filtrarPorStatus(statuses, ['LENDO']);
          final queroLer = _filtrarPorStatus(statuses, ['QUERO_LER']);
          final jaLi = _filtrarPorStatus(statuses, ['LIDO']);

          if (statuses.isEmpty) {
            return RefreshIndicator(
              onRefresh: _recarregar,
              child: ListView(
                children: const [
                  SizedBox(height: 180),
                  Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24),
                      child: Text(
                        'Você ainda não possui livros com status de leitura.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF777777),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: _recarregar,
            child: ListView(
              padding: const EdgeInsets.only(top: 16, bottom: 12),
              children: [
                _CabecalhoSecao(
                  titulo: 'Lendo agora',
                  icone: Icons.auto_stories_outlined,
                  corAccent: const Color(0xFF3D9080),
                ),
                if (lendoAgora.isEmpty)
                  const _SecaoVazia(texto: 'Nenhum livro em leitura no momento.')
                else
                  ...lendoAgora.map(
                    (item) => _CardComBorda(
                      livro: item.book,
                      corAccent: const Color(0xFF3D9080),
                    ),
                  ),
                const SizedBox(height: 8),
                _CabecalhoSecao(
                  titulo: 'Quero ler',
                  icone: Icons.bookmark_border_rounded,
                  corAccent: const Color(0xFF4A7FA5),
                ),
                if (queroLer.isEmpty)
                  const _SecaoVazia(texto: 'Nenhum livro marcado como quero ler.')
                else
                  ...queroLer.map(
                    (item) => _CardComBorda(
                      livro: item.book,
                      corAccent: const Color(0xFF4A7FA5),
                    ),
                  ),
                const SizedBox(height: 8),
                _CabecalhoSecao(
                  titulo: 'Já li',
                  icone: Icons.check_circle_outline_rounded,
                  corAccent: const Color(0xFF7A8C63),
                ),
                if (jaLi.isEmpty)
                  const _SecaoVazia(texto: 'Nenhum livro concluído ainda.')
                else
                  ...jaLi.map(
                    (item) => _CardComBorda(
                      livro: item.book,
                      corAccent: const Color(0xFF7A8C63),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: const Rodape(
        selectedTab: NavTab.leitura,
      ),
    );
  }
}

class _CabecalhoSecao extends StatelessWidget {
  final String titulo;
  final IconData icone;
  final Color corAccent;

  const _CabecalhoSecao({
    required this.titulo,
    required this.icone,
    required this.corAccent,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
      child: Row(
        children: [
          Icon(icone, size: 17, color: corAccent),
          const SizedBox(width: 7),
          Text(
            titulo,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: corAccent,
            ),
          ),
        ],
      ),
    );
  }
}

class _CardComBorda extends StatelessWidget {
  final dynamic livro;
  final Color corAccent;

  const _CardComBorda({required this.livro, required this.corAccent});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        LivroCardWidget(livro: livro),
        Positioned(
          left: 16,
          top: 6,
          bottom: 6,
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(12),
              bottomLeft: Radius.circular(12),
            ),
            child: Container(
              width: 3,
              color: corAccent,
            ),
          ),
        ),
      ],
    );
  }
}

class _SecaoVazia extends StatelessWidget {
  final String texto;

  const _SecaoVazia({required this.texto});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 6, 16, 10),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          texto,
          style: const TextStyle(
            fontSize: 13,
            color: Color(0xFF777777),
          ),
        ),
      ),
    );
  }
}