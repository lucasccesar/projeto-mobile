import 'package:flutter/material.dart';
import 'package:projeto_mobile/View/widgets/rodape_widget.dart';
import 'package:projeto_mobile/config/app_colors.dart';
import 'package:projeto_mobile/View/pages/clube_livro_proximo.dart';
import 'package:projeto_mobile/View/widgets/appbar_widget.dart';
import 'package:projeto_mobile/View/widgets/clube_livro_anterior_proximo.dart';
import 'package:projeto_mobile/View/widgets/clube_navegacao.dart';
import 'package:projeto_mobile/View/widgets/sidebar_widget.dart';
import 'package:projeto_mobile/models/book.dart';
import 'package:projeto_mobile/services/book_service.dart';
import 'package:projeto_mobile/services/clube_assignment.dart';

class ClubeLivroAnterior extends StatefulWidget {
  final String clubeId;
  const ClubeLivroAnterior({super.key, required this.clubeId});

  @override
  State<ClubeLivroAnterior> createState() => _ClubeLivroAnteriorState();
}

class _ClubeLivroAnteriorState extends State<ClubeLivroAnterior> {
  final BookClubAssignmentService _assignmentService = BookClubAssignmentService();
  final BookService _bookService = BookService();

  List<Map<String, dynamic>> _livrosAnteriores = []; // {book: Book, finishDate: String}
  bool _carregando = true;

  @override
  void initState() {
    super.initState();
    _carregarLivrosAnteriores();
  }

  Future<void> _carregarLivrosAnteriores() async {
    try {
      final assignments = await _assignmentService.fetchAssignmentsAnteriores(widget.clubeId);

      final livros = await Future.wait(assignments.map((a) async {
        final book = await _bookService.fetchLivroPorId(a['bookId']!);
        return {
          'book': book,
          'finishDate': a['finishDate']!,
        };
      }));

      setState(() {
        _livrosAnteriores = livros;
        _carregando = false;
      });
    } catch (e) {
      setState(() => _carregando = false);
    }
  }

  // formata "2026-06-18" → "18/06/2026"
  String _formatarData(String data) {
    final partes = data.split('-');
    return '${partes[2]}/${partes[1]}/${partes[0]}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: SidebarWidget(),
      appBar: BooklyAppBar(
        title: 'Clube do Livro',
        iconeMenu: false,
        iconeCarrinho: false,
        iconeSeta: true,
        corDoTexto: AppColors.clube,
      ),
      body: Column(
        children: [
          ClubeNavegacao(
            abaSelecionada: 1,
            onAtualTap: () => Navigator.pop(context),
            onProximoTap: () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => ClubeLivroProximo(clubeId: widget.clubeId),
              ),
            ),
          ),
          Divider(
            height: 1,
            color: Color.lerp(
              Theme.of(context).colorScheme.tertiary,
              Colors.white,
              0.8,
            ),
          ),
          Expanded(
            child: _carregando
                ? const Center(child: CircularProgressIndicator())
                : _livrosAnteriores.isEmpty
                    ? const Center(child: Text('Nenhum livro lido ainda'))
                    : ListView(
                        children: [
                          SizedBox(height: 14),
                          Padding(
                            padding: EdgeInsets.only(left: 20),
                            child: SizedBox(
                              height: 20,
                              width: double.infinity,
                              child: Text(
                                'Livros já lidos pelo clube',
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.tertiary,
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ),
                          ),
                          ..._livrosAnteriores.map((item) {
                            final book = item['book'] as Book;
                            final finishDate = item['finishDate'] as String;
                            return ClubeLivroAnteriorProximo(
                              anterior: true,
                              titulo: book.title,
                              autor: book.author,
                              data: _formatarData(finishDate),
                              nota: book.rating,
                            );
                          }),
                        ],
                      ),
          ),
        ],
      ),
      bottomNavigationBar: const Rodape(selectedTab: NavTab.clubes),
    );
  }
}