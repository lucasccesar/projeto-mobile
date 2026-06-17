import 'package:projeto_mobile/config/token_config.dart';
import 'package:flutter/material.dart';
import 'package:projeto_mobile/config/app_colors.dart';
import 'package:projeto_mobile/models/book.dart';
import 'package:projeto_mobile/models/rating.dart';
import 'package:projeto_mobile/models/reading_status.dart';
import 'package:projeto_mobile/services/rating_service.dart';
import 'package:projeto_mobile/services/reading_status_service.dart';
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
  String? _statusLeitura;
  final ReadingStatusService _readingStatusService = ReadingStatusService();
  final RatingService _ratingService = RatingService();
  ReadingStatus? _readingStatusAtual;
  bool _carregandoStatus = true;
  bool _salvandoStatus = false;
  bool _carregandoAvaliacoes = true;
  List<Rating> _avaliacoes = [];
  double _mediaAvaliacoes = 0;

  static const _statusOpcoes = ['Quero Ler', 'Lendo', 'Lido'];

  static const Color _highland = Color(0xFF7A8C63);
  static const Color _millbrook = Color(0xFF5A4631);
  static const Color _shadow = Color(0xFF8B7355);
  static const Color _ecruWhite = Color(0xFFF5EFDB);
  static const Color _fuzzyWuzzy = Color(0xFFC06248);
  static const Color _starActive = Color(0xFFD4A84B);

  @override
  void initState() {
    super.initState();
    _carregarStatusLeitura();
    _carregarAvaliacoes();
  }

  void _abrirModalColecoes() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => _ModalColecoes(tituloLivro: widget.livro.title),
    );
  }

  Future<void> _abrirEditar() async {
    final atualizado = await Navigator.push<dynamic>(
      context,
      MaterialPageRoute(builder: (_) => EditarLivroPage(livro: widget.livro)),
    );

    if (!mounted) return;

    if (atualizado == 'deleted') {
      Navigator.pop(context);
      return;
    }

    if (atualizado is Book) {
      setState(() {});
    }
  }

  Future<void> _abrirAvaliar() async {
    final enviado = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => AvaliarLivroPage(livro: widget.livro)),
    );

    if (enviado == true && mounted) {
      await _carregarAvaliacoes();
    }
  }

  Future<void> _carregarAvaliacoes() async {
    try {
      final resultados = await Future.wait([
        _ratingService.fetchRatingsByBook(widget.livro.id),
        _ratingService.fetchAverageRating(widget.livro.id),
      ]);

      if (!mounted) return;

      setState(() {
        _avaliacoes = resultados[0] as List<Rating>;
        _mediaAvaliacoes = resultados[1] as double;
        _carregandoAvaliacoes = false;
      });
    } catch (_) {
      if (!mounted) return;

      setState(() {
        _avaliacoes = [];
        _mediaAvaliacoes = 0;
        _carregandoAvaliacoes = false;
      });
    }
  }

  Future<void> _carregarStatusLeitura() async {
    final userId = TokenConfig.userId;

    if (userId == null || userId.isEmpty) {
      if (!mounted) return;
      setState(() {
        _statusLeitura = null;
        _carregandoStatus = false;
      });
      return;
    }

    try {
      final status = await _readingStatusService.fetchStatusByBookAndUser(
        widget.livro.id,
        userId,
      );

      if (!mounted) return;

      setState(() {
        _readingStatusAtual = status;
        _statusLeitura =
            status != null ? _statusLabelFromApi(status.status) : null;
        _carregandoStatus = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _statusLeitura = null;
        _carregandoStatus = false;
      });
    }
  }

  String _statusApiFromLabel(String label) {
    switch (label) {
      case 'Quero Ler':
        return 'QUERO_LER';
      case 'Lendo':
        return 'LENDO';
      case 'Lido':
        return 'LIDO';
      default:
        return 'LENDO';
    }
  }

  String _statusLabelFromApi(String status) {
    switch (status.toUpperCase()) {
      case 'QUERO_LER':
        return 'Quero Ler';
      case 'LENDO':
        return 'Lendo';
      case 'LIDO':
        return 'Lido';
      default:
        return 'Lendo';
    }
  }

  Future<void> _salvarStatusLeitura(String opcao) async {
    final userId = TokenConfig.userId;
    if (userId == null || userId.isEmpty) return;

    final statusJaSelecionado = _statusLeitura == opcao;

    setState(() {
      _salvandoStatus = true;
      if (statusJaSelecionado) {
        _statusLeitura = null;
      } else {
        _statusLeitura = opcao;
      }
    });

    try {
      ReadingStatus? statusAtual = _readingStatusAtual;

      statusAtual ??= await _readingStatusService.fetchStatusByBookAndUser(
        widget.livro.id,
        userId,
      );

      if (statusJaSelecionado) {
        if (statusAtual != null) {
          await _readingStatusService.deleteStatus(statusAtual.id);
        }

        if (!mounted) return;

        setState(() {
          _readingStatusAtual = null;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(
              'Status de leitura removido',
              style: TextStyle(fontSize: 13),
            ),
            backgroundColor: _highland,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            duration: const Duration(seconds: 2),
          ),
        );

        return;
      }

      final statusApi = _statusApiFromLabel(opcao);

      final ReadingStatus statusSalvo;
      if (statusAtual == null) {
        statusSalvo = await _readingStatusService.createStatus(
          bookId: widget.livro.id,
          userId: userId,
          status: statusApi,
        );
      } else {
        statusSalvo = await _readingStatusService.updateStatus(
          statusId: statusAtual.id,
          bookId: widget.livro.id,
          userId: userId,
          status: statusApi,
        );
      }

      if (!mounted) return;

      setState(() {
        _readingStatusAtual = statusSalvo;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Status atualizado para $opcao',
            style: const TextStyle(fontSize: 13),
          ),
          backgroundColor: _highland,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          duration: const Duration(seconds: 2),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _statusLeitura = _readingStatusAtual != null
            ? _statusLabelFromApi(_readingStatusAtual!.status)
            : null;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.toString().replaceFirst('Exception: ', ''),
            style: const TextStyle(fontSize: 13),
          ),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    } finally {
      if (!mounted) return;
      setState(() {
        _salvandoStatus = false;
      });
    }
  }

  String _textoQuantidadeAvaliacoes() {
    if (_carregandoAvaliacoes) return '(carregando...)';
    final total = _avaliacoes.length;
    return total == 1 ? '(1 avaliação)' : '($total avaliações)';
  }

  String _textoQuantidadeComentarios() {
    if (_carregandoAvaliacoes) return 'Carregando comentários...';
    final total = _avaliacoes.length;
    return total == 1 ? '1 comentário' : '$total comentários';
  }

  String _iniciaisDoUsuario(String userId) {
    final base = userId.replaceAll('-', '').toUpperCase();
    if (base.length >= 2) {
      return base.substring(0, 2);
    }
    if (base.isNotEmpty) return base;
    return 'U';
  }

  String _autorDoComentario(String userId) {
    final usuarioAtual = TokenConfig.usuario;
    if (usuarioAtual != null && usuarioAtual.id == userId) {
      return usuarioAtual.nome;
    }
    return 'Leitor';
  }

  String _dataFormatada(DateTime? data) {
    if (data == null) return 'Sem data';

    final dia = data.day.toString().padLeft(2, '0');
    final mes = data.month.toString().padLeft(2, '0');
    final ano = data.year.toString().padLeft(4, '0');

    return '$dia/$mes/$ano';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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
    final textoNota = _carregandoAvaliacoes
        ? widget.livro.rating.toString()
        : _mediaAvaliacoes.toStringAsFixed(1);

    return Row(
      children: [
        const Icon(Icons.star_rounded, size: 13, color: _highland),
        const SizedBox(width: 5),
        Text(
          textoNota,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: _millbrook,
          ),
        ),
        const SizedBox(width: 5),
        Text(
          _textoQuantidadeAvaliacoes(),
          style: const TextStyle(fontSize: 11, color: _shadow),
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
              if (_carregandoStatus || _salvandoStatus) ...[
                const SizedBox(width: 8),
                const SizedBox(
                  width: 12,
                  height: 12,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ],
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: _statusOpcoes.map((opcao) {
              final selecionado =
                  _statusLeitura != null && opcao == _statusLeitura;
              final isLast = opcao == _statusOpcoes.last;
              return Expanded(
                child: Padding(
                  padding: EdgeInsets.only(right: isLast ? 0 : 6),
                  child: GestureDetector(
                    onTap: (_carregandoStatus || _salvandoStatus)
                        ? null
                        : () => _salvarStatusLeitura(opcao),
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
          Text(
            _textoQuantidadeComentarios(),
            style: const TextStyle(fontSize: 11, color: _shadow),
          ),
          const SizedBox(height: 14),
          if (_carregandoAvaliacoes)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
          else if (_avaliacoes.isEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: _ecruWhite,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: _millbrook.withValues(alpha: 0.10),
                  width: 1,
                ),
              ),
              child: const Text(
                'Nenhuma avaliação cadastrada para este livro ainda.',
                style: TextStyle(
                  fontSize: 13,
                  color: _shadow,
                  height: 1.6,
                ),
              ),
            )
          else
            ..._avaliacoes.map((rating) => _buildCardComentario(rating)),
        ],
      ),
    );
  }

  Widget _buildCardComentario(Rating rating) {
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
                  _iniciaisDoUsuario(rating.userId),
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
                      _autorDoComentario(rating.userId),
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: _millbrook,
                      ),
                    ),
                    Text(
                      _dataFormatada(rating.ratingDate),
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
                      '${rating.ratingValue}/10',
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
          if (rating.comment.trim().isNotEmpty) ...[
            const SizedBox(height: 10),
            Text(
              rating.comment,
              style: const TextStyle(fontSize: 13, color: _shadow, height: 1.6),
            ),
          ],
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