import 'package:flutter/material.dart';
import 'package:projeto_mobile/config/app_colors.dart';
import 'package:projeto_mobile/View/widgets/appbar_widget.dart';
import 'package:projeto_mobile/View/widgets/clube_mensagem.dart';
import 'package:projeto_mobile/View/widgets/sidebar_widget.dart';
import 'package:projeto_mobile/config/token_config.dart';
import 'package:projeto_mobile/models/clube_mensagem.dart';
import 'package:projeto_mobile/services/clube_mensagem_service.dart';

class ClubeMensagem extends StatefulWidget {
  final String clubeId;
  const ClubeMensagem({super.key, required this.clubeId});

  @override
  State<ClubeMensagem> createState() => _ClubeMensagemState();
}

class _ClubeMensagemState extends State<ClubeMensagem> {
  final ClubeMensagemService _service = ClubeMensagemService();
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();   
  List<ClubeMensagemModel> _mensagens = [];                      
  bool _enviando = false;                                           

  String get userId => TokenConfig.userId!;

  @override
  void initState() {
    super.initState();
    _carregarMensagens();
  }

  Future<void> _carregarMensagens() async {
    final mensagens = await _service.fetchMensagens(widget.clubeId);
    setState(() => _mensagens = mensagens);
    _scrollParaBaixo();
  }

  Future<void> _enviarMensagem() async {
    final texto = _controller.text.trim();
    if (texto.isEmpty || _enviando) return;

    setState(() => _enviando = true);

    try {
      final novaMensagem = await _service.enviarMensagem(
        clubId: widget.clubeId,
        userId: userId,
        message: texto,
      );

      _controller.clear();
      setState(() => _mensagens.add(novaMensagem));
      _scrollParaBaixo();
    } catch (e) {
      print('Erro ao enviar mensagem: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro ao enviar mensagem')),
      );
    } finally {
      setState(() => _enviando = false);
    }
  }

  void _scrollParaBaixo() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  String _formatarHora(DateTime data) {
    final local = data.toLocal();
    return '${local.hour.toString().padLeft(2, '0')}:${local.minute.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: SidebarWidget(),
      appBar: BooklyAppBar(
        title: 'Chat do Clube',
        corDoTexto: AppColors.clube,
        iconeMenu: false,
        iconeSeta: true,
        iconeCarrinho: false,
      ),
      body: Column(
        children: [
          Expanded(
            child: _mensagens.isEmpty
                ? const Center(child: Text('Nenhuma mensagem ainda. Seja o primeiro!'))
                : ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(8),
                    itemCount: _mensagens.length,
                    itemBuilder: (context, index) {
                      final mensagem = _mensagens[index];
                      final bool isMe = mensagem.userId == userId;
                      return ClubeMensagemWidget(
                        autor: isMe ? 'Eu' : mensagem.userId,
                        texto: mensagem.message,
                        hora: _formatarHora(mensagem.messageDate),
                        isMe: isMe,
                      );
                    },
                  ),
          ),

          Divider(
            height: 1,
            color: Color.lerp(Theme.of(context).colorScheme.tertiary, Colors.white, 0.8),
          ),

          Container(
            width: double.infinity,
            height: 80,
            child: Row(
              children: [
                SizedBox(width: 14),
                Expanded(
                  child: TextField(
                    controller: _controller,        
                    onSubmitted: (_) => _enviarMensagem(), 
                    decoration: InputDecoration(
                      hintText: 'Escrever mensagem...',
                      hintStyle: TextStyle(color: AppColors.clube, fontSize: 17),
                      fillColor: Theme.of(context).colorScheme.secondary,
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(99),
                        borderSide: BorderSide(
                          color: Color.lerp(Theme.of(context).colorScheme.tertiary, Colors.white, 0.8)!,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(99),
                        borderSide: BorderSide(
                          color: Color.lerp(Theme.of(context).colorScheme.tertiary, Colors.white, 0.8)!,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(99),
                        borderSide: BorderSide(
                          color: Color.lerp(Theme.of(context).colorScheme.tertiary, Colors.white, 0.8)!,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.clube,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: _enviando
                      ? const Padding(
                          padding: EdgeInsets.all(10),
                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                        )
                      : IconButton(
                          onPressed: _enviarMensagem,
                          icon: Icon(Icons.send),
                          color: Theme.of(context).colorScheme.primary,
                        ),
                ),
                SizedBox(width: 14),
              ],
            ),
          ),
        ],
      ),
    );
  }
}