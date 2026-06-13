import 'package:flutter/material.dart';
import 'package:projeto_mobile/View/widgets/rodape_widget.dart';
import 'package:projeto_mobile/config/app_colors.dart';
import 'package:projeto_mobile/View/pages/clube_livro_anterior.dart';
import 'package:projeto_mobile/View/widgets/appbar_widget.dart';
import 'package:projeto_mobile/View/widgets/clube_livro_anterior_proximo.dart';
import 'package:projeto_mobile/View/widgets/clube_navegacao.dart';
import 'package:projeto_mobile/View/widgets/sidebar_widget.dart';
import 'package:projeto_mobile/models/book.dart';
import 'package:projeto_mobile/services/book_service.dart';
import 'package:projeto_mobile/services/clube_assignment.dart';

class ClubeLivroProximo extends StatefulWidget {
  final String clubeId;
  const ClubeLivroProximo({super.key, required this.clubeId});

  @override
  State<ClubeLivroProximo> createState() => _ClubeLivroProximoState();
}

class _ClubeLivroProximoState extends State<ClubeLivroProximo> {
  final BookClubAssignmentService _assignmentService = BookClubAssignmentService();
  final BookService _bookService = BookService();

  List<Map<String, dynamic>> _proximosLivros = []; // {book: Book, startDate: String}
  bool _carregando = true;

  @override
  void initState() {
    super.initState();
    _carregarProximosLivros();
  }

  Future<void> _carregarProximosLivros() async {
    try {
      final assignments = await _assignmentService.fetchAssignmentsFuturos(widget.clubeId);

      final livros = await Future.wait(assignments.map((a) async {
        final book = await _bookService.fetchLivroPorId(a['bookId']!);
        return {
          'book': book,
          'startDate': a['startDate']!,
        };
      }));

      setState(() {
        _proximosLivros = livros;
        _carregando = false;
      });
    } catch (e) {
      setState(() => _carregando = false);
    }
  }

  
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
            abaSelecionada: 2,
            onAtualTap: () => Navigator.pop(context),
            onAnteriorTap: () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => ClubeLivroAnterior(clubeId: widget.clubeId),
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
                : _proximosLivros.isEmpty
                    ? const Center(child: Text('Nenhum livro programado'))
                    : ListView(
                        children: [
                          SizedBox(height: 14),
                          Padding(
                            padding: EdgeInsets.only(left: 20),
                            child: SizedBox(
                              height: 20,
                              width: double.infinity,
                              child: Text(
                                'Próximos livros planejados para o clube',
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.tertiary,
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ),
                          ),
                          ..._proximosLivros.map((item) {
                            final book = item['book'] as Book;
                            final startDate = item['startDate'] as String;
                            return ClubeLivroAnteriorProximo(
                              anterior: false,
                              titulo: book.title,
                              autor: book.author,
                              data: _formatarData(startDate),
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