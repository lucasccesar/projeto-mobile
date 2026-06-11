import 'package:projeto_mobile/config/token_config.dart';
import 'package:flutter/material.dart';
import 'package:projeto_mobile/config/app_colors.dart';
import 'package:projeto_mobile/models/book.dart';
import 'package:projeto_mobile/View/widgets/appbar_widget.dart';
import 'package:projeto_mobile/View/pages/editar_livro_page.dart';
import 'package:projeto_mobile/View/widgets/capa_widget.dart';
import 'package:projeto_mobile/View/pages/avaliar_livro_page.dart';

class BookPage extends StatefulWidget {
  final Book livro;
  final void Function(Book)? onAdicionarAoCarrinho;

  const BookPage({super.key, required this.livro, this.onAdicionarAoCarrinho});

  @override
  State<BookPage> createState() => _BookPageState();
}

class _BookPageState extends State<BookPage> {
  bool _favoritado = false;
  String _statusLeitura = 'Lendo';

  static const _statusOpcoes = ['Quero Ler', 'Lendo', 'Lido', 'Abandonado'];

  static const Color _highland = Color(0xFF7A8C63);
  static const Color _millbrook = Color(0xFF5A4631);
  static const Color _shadow = Color(0xFF8B7355);
  static const Color _ecruWhite = Color(0xFFF5EFDB);
  static const Color _fuzzyWuzzy = Color(0xFFC06248);
  static const Color _starActive = Color(0xFFD4A84B);

  static const List<_Comentario> _comentarios = [
    _Comentario(
      autor: 'Ana Lima',
      nota: 10,
      texto:
          'Uma obra-prima absoluta! A construção do mundo e dos personagens é simplesmente inigualável. Li três vezes e sempre descubro algo novo.',
      data: 'há 2 dias',
      iniciais: 'AL',
    ),
    _Comentario(
      autor: 'Carlos Mendes',
      nota: 9,
      texto:
          'Tolkien criou um universo inteiro com linguagens, histórias e culturas próprias. O ritmo pode ser lento no início, mas vale cada página.',
      data: 'há 1 semana',
      iniciais: 'CM',
    ),
    _Comentario(
      autor: 'Beatriz Souza',
      nota: 10,
      texto:
          'Impossível não se apaixonar pela Terra-Média. A jornada de Frodo é emocionante do início ao fim. Um dos melhores livros que já li.',
      data: 'há 2 semanas',
      iniciais: 'BS',
    ),
    _Comentario(
      autor: 'Rafael Torres',
      nota: 8,
      texto:
          'Leitura densa, mas recompensadora. As batalhas e os momentos de amizade entre os personagens são memoráveis.',
      data: 'há 1 mês',
      iniciais: 'RT',
    ),
  ];

  void _abrirModalColecoes() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFFF5F0E8),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => _ModalColecoes(tituloLivro: widget.livro.title),
    );
  }

  Future<void> _abrirEditar() async {
    final atualizado = await Navigator.push<Book>(
      context,
      MaterialPageRoute(builder: (_) => EditarLivroPage(livro: widget.livro)),
    );

    if (atualizado != null && mounted) {
      setState(() {});
    }
  }

  void _abrirAvaliar() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => AvaliarLivroPage(livro: widget.livro)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F0E8),
      appBar: BooklyAppBar(
        title: widget.livro.title,
        corDoTexto: AppColors.catalogo,
        iconeMenu: false,
        iconeSeta: true,
        iconeCarrinho: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(top: 10, bottom: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 16),
            _buildSinopse(),
            const SizedBox(height: 16),
            _buildSeletorStatus(),
            const SizedBox(height: 12),
            _buildAcoesCarrinho(),
            const SizedBox(height: 20),
            _buildComentarios(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCapa(),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 2),
                Text(
                  widget.livro.title,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: _millbrook,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  widget.livro.author,
                  style: const TextStyle(fontSize: 13, color: _shadow),
                ),
                const SizedBox(height: 6),
                _buildBadgeGenero(),
                const SizedBox(height: 6),
                _buildRating(),
                const SizedBox(height: 6),
                Text(
                  'R\$${widget.livro.price.toStringAsFixed(2).replaceAll('.', ',')}',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: _highland,
                  ),
                ),
              ],
            ),
          ),
          if (TokenConfig.isAdmin) ...[
            const SizedBox(width: 4),
            _buildBotaoEditar(),
          ],
        ],
      ),
    );
  }

  Widget _buildCapa() {
    return const CapaWidget(cor: AppColors.catalogo, largura: 90, altura: 128);
  }

  Widget _buildBotaoEditar() {
    return GestureDetector(
      onTap: _abrirEditar,
      child: Container(
        height: 30,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: const Color(0xFFFFFEF8),
          borderRadius: BorderRadius.circular(99),
          border: Border.all(
            color: _millbrook.withValues(alpha: 0.15),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.edit_outlined, size: 13, color: _highland),
            const SizedBox(width: 4),
            const Text(
              'Editar',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: _millbrook,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBadgeGenero() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(
        color: _highland.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(99),
      ),
      child: Text(
        widget.livro.genre,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: _highland,
        ),
      ),
    );
  }

  Widget _buildRating() {
    return Row(
      children: [
        const Icon(Icons.star_rounded, size: 13, color: _highland),
        const SizedBox(width: 5),
        Text(
          widget.livro.rating.toString(),
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: _millbrook,
          ),
        ),
        const SizedBox(width: 5),
        const Text(
          '(128 avaliações)',
          style: TextStyle(fontSize: 11, color: _shadow),
        ),
        const Spacer(),
        GestureDetector(
          onTap: _abrirAvaliar,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
            decoration: BoxDecoration(
              color: _starActive.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(99),
              border: Border.all(
                color: _starActive.withValues(alpha: 0.28),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.star_outline_rounded, size: 12, color: _starActive),
                const SizedBox(width: 4),
                Text(
                  'Avaliar',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: _starActive.withValues(alpha: 0.85),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSinopse() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: _ecruWhite,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _millbrook.withValues(alpha: 0.15), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'SINOPSE',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: _millbrook,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            _sinopsePara(widget.livro.title),
            style: const TextStyle(fontSize: 13, color: _shadow, height: 1.7),
          ),
        ],
      ),
    );
  }

  Widget _buildSeletorStatus() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.sync_rounded, size: 14, color: _highland),
              const SizedBox(width: 6),
              const Text(
                'Status de Leitura',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF3D9080),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: _statusOpcoes.map((opcao) {
              final selecionado = opcao == _statusLeitura;
              final isLast = opcao == _statusOpcoes.last;
              return Expanded(
                child: Padding(
                  padding: EdgeInsets.only(right: isLast ? 0 : 6),
                  child: GestureDetector(
                    onTap: () => setState(() => _statusLeitura = opcao),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      height: 34,
                      decoration: BoxDecoration(
                        color: selecionado ? _highland : _ecruWhite,
                        borderRadius: BorderRadius.circular(99),
                        border: Border.all(
                          color: selecionado
                              ? _highland
                              : _millbrook.withValues(alpha: 0.18),
                          width: 1,
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        opcao,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: selecionado ? Colors.white : _shadow,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildAcoesCarrinho() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                widget.onAdicionarAoCarrinho?.call(widget.livro);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      '${widget.livro.title} adicionado ao carrinho',
                      style: const TextStyle(fontSize: 13),
                    ),
                    backgroundColor: AppColors.compra,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    duration: const Duration(seconds: 2),
                  ),
                );
              },
              child: Container(
                height: 44,
                decoration: BoxDecoration(
                  color: _highland,
                  borderRadius: BorderRadius.circular(99),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.shopping_cart_outlined,
                      size: 16,
                      color: Colors.white,
                    ),
                    SizedBox(width: 7),
                    Text(
                      'Adicionar ao Carrinho',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          _buildBotaoIcone(
            onTap: () => setState(() => _favoritado = !_favoritado),
            icon: _favoritado
                ? Icons.favorite_rounded
                : Icons.favorite_border_rounded,
            iconColor: _fuzzyWuzzy,
          ),
          const SizedBox(width: 8),
          _buildBotaoIcone(
            onTap: _abrirModalColecoes,
            icon: Icons.bookmark_border_rounded,
            iconColor: _highland,
          ),
        ],
      ),
    );
  }

  Widget _buildComentarios() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'COMENTÁRIOS',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: _millbrook,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 2),
          const Text(
            '4 comentários',
            style: TextStyle(fontSize: 11, color: _shadow),
          ),
          const SizedBox(height: 14),
          ..._comentarios.map((c) => _buildCardComentario(c)),
        ],
      ),
    );
  }

  Widget _buildCardComentario(_Comentario comentario) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: _ecruWhite,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _millbrook.withValues(alpha: 0.10), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: _highland.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(99),
                  border: Border.all(
                    color: _highland.withValues(alpha: 0.2),
                    width: 1,
                  ),
                ),
                alignment: Alignment.center,
                child: Text(
                  comentario.iniciais,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: _highland,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      comentario.autor,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: _millbrook,
                      ),
                    ),
                    Text(
                      comentario.data,
                      style: const TextStyle(fontSize: 11, color: _shadow),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: _starActive.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(99),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.star_rounded, size: 11, color: _starActive),
                    const SizedBox(width: 3),
                    Text(
                      '${comentario.nota}/10',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: _starActive.withValues(alpha: 0.85),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            comentario.texto,
            style: const TextStyle(fontSize: 13, color: _shadow, height: 1.6),
          ),
        ],
      ),
    );
  }

  Widget _buildBotaoIcone({
    required VoidCallback onTap,
    required IconData icon,
    required Color iconColor,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: _ecruWhite,
          borderRadius: BorderRadius.circular(99),
          border: Border.all(
            color: _millbrook.withValues(alpha: 0.15),
            width: 1,
          ),
        ),
        child: Icon(icon, size: 18, color: iconColor),
      ),
    );
  }

  String _sinopsePara(String titulo) {
    const mapa = {
      'O Senhor dos Anéis':
          'Uma épica aventura de fantasia que narra a jornada de Frodo Bolseiro para destruir o Um Anel e salvar a Terra-média das trevas de Sauron. Considerada a maior obra de fantasia do século XX.',
    };
    return mapa[titulo] ??
        'Uma obra literária de destaque, aclamada por críticos e leitores ao redor do mundo. Um mergulho profundo em narrativas que marcaram gerações e continuam relevantes nos dias de hoje.';
  }
}

class _Comentario {
  final String autor;
  final int nota;
  final String texto;
  final String data;
  final String iniciais;

  const _Comentario({
    required this.autor,
    required this.nota,
    required this.texto,
    required this.data,
    required this.iniciais,
  });
}

class _ModalColecoes extends StatefulWidget {
  final String tituloLivro;

  const _ModalColecoes({required this.tituloLivro});

  @override
  State<_ModalColecoes> createState() => _ModalColecoesState();
}

class _ModalColecoesState extends State<_ModalColecoes> {
  static const Color _highland = Color(0xFF7A8C63);
  static const Color _millbrook = Color(0xFF5A4631);
  static const Color _shadow = Color(0xFF8B7355);
  static const Color _ecruWhite = Color(0xFFF5EFDB);

  final List<_Colecao> _colecoes = [
    _Colecao(nome: 'Favoritos', icone: Icons.favorite_outline_rounded, qtd: 4),
    _Colecao(nome: 'Para o Verão', icone: Icons.wb_sunny_outlined, qtd: 7),
    _Colecao(nome: 'Clássicos', icone: Icons.auto_stories_outlined, qtd: 12),
    _Colecao(nome: 'Recomendados', icone: Icons.thumb_up_outlined, qtd: 3),
  ];

  final Set<int> _selecionados = {};

  @override
  Widget build(BuildContext context) {
    final bottomPadding =
        MediaQuery.of(context).viewInsets.bottom +
        MediaQuery.of(context).padding.bottom;

    return SafeArea(
      top: false,
      child: Padding(
        padding: EdgeInsets.only(bottom: bottomPadding),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: _millbrook.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(99),
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Adicionar à Coleção',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: _millbrook,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(
                      Icons.close_rounded,
                      size: 20,
                      color: _shadow,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 4),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  const Icon(Icons.menu_book_rounded, size: 13, color: _shadow),
                  const SizedBox(width: 5),
                  Expanded(
                    child: Text(
                      widget.tituloLivro,
                      style: const TextStyle(fontSize: 12, color: _shadow),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            ...List.generate(_colecoes.length, (i) {
              final colecao = _colecoes[i];
              final selecionado = _selecionados.contains(i);
              return Column(
                children: [
                  if (i > 0)
                    Divider(
                      height: 1,
                      indent: 20,
                      endIndent: 20,
                      color: _millbrook.withValues(alpha: 0.08),
                    ),
                  InkWell(
                    onTap: () => setState(() {
                      if (selecionado) {
                        _selecionados.remove(i);
                      } else {
                        _selecionados.add(i);
                      }
                    }),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 38,
                            height: 38,
                            decoration: BoxDecoration(
                              color: selecionado
                                  ? _highland.withValues(alpha: 0.12)
                                  : _ecruWhite,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: selecionado
                                    ? _highland.withValues(alpha: 0.3)
                                    : _millbrook.withValues(alpha: 0.1),
                                width: 1,
                              ),
                            ),
                            child: Icon(
                              colecao.icone,
                              size: 18,
                              color: selecionado ? _highland : _shadow,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  colecao.nome,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: selecionado ? _highland : _millbrook,
                                  ),
                                ),
                                Text(
                                  '${colecao.qtd} livros',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: _shadow,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 150),
                            width: 22,
                            height: 22,
                            decoration: BoxDecoration(
                              color: selecionado
                                  ? _highland
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(99),
                              border: Border.all(
                                color: selecionado
                                    ? _highland
                                    : _millbrook.withValues(alpha: 0.2),
                                width: 1.5,
                              ),
                            ),
                            child: selecionado
                                ? const Icon(
                                    Icons.check_rounded,
                                    size: 13,
                                    color: Colors.white,
                                  )
                                : null,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            }),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  height: 44,
                  decoration: BoxDecoration(
                    color: _highland,
                    borderRadius: BorderRadius.circular(99),
                  ),
                  alignment: Alignment.center,
                  child: const Text(
                    'Confirmar',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Colecao {
  final String nome;
  final IconData icone;
  final int qtd;

  const _Colecao({required this.nome, required this.icone, required this.qtd});
}
