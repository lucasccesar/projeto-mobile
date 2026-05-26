import 'package:flutter/material.dart';
import 'package:projeto_mobile/config/app_colors.dart';
import 'package:projeto_mobile/View/widgets/appbar_widget.dart';
import 'package:projeto_mobile/View/widgets/clube_mensagem.dart';
import 'package:projeto_mobile/View/widgets/sidebar_widget.dart';
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
  final ScrollController _scrollController = ScrollController();
  late Future<List<ClubeMensagemModel>> _future;

  @override
  void initState() {
    super.initState();
    _future = _service.fetchMensagens(widget.clubeId);
  }


  String _formatarHora(DateTime data) {
    final local = data.toLocal(); 
    return '${local.hour.toString().padLeft(2, '0')}:${local.minute.toString().padLeft(2, '0')}';
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
            child: FutureBuilder<List<ClubeMensagemModel>>(
              future: _future,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      'Erro ao carregar mensagens',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                  );
                }

                final mensagens = snapshot.data ?? [];

                if (mensagens.isEmpty) {
                  return Center(
                    child: Text('Nenhuma mensagem ainda. Seja o primeiro!', style:TextStyle(color: Theme.of(context).colorScheme.error)),
                  );
                }

                return ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(8),
                  itemCount: mensagens.length,
                  itemBuilder: (context, index) {
                    final mensagem = mensagens[index];
                    // TODO: substituir pelo id do usuário logado
                    const String meuUserId = 'de47c4dd-52ad-42c1-b894-c9ed11263885';
                    final bool isMe = mensagem.userId == meuUserId;

                    return ClubeMensagemWidget(
                      autor: isMe ? 'Eu' : mensagem.userId,
                      texto: mensagem.message,
                      hora: _formatarHora(mensagem.messageDate),
                      isMe: isMe,
                    );
                  },
                );
              },
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

          Container(
            width: double.infinity,
            height: 80,
            child: Row(
              children: [
                SizedBox(width: 14),
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Escrever mensagem...',
                      hintStyle: TextStyle(
                        color: AppColors.clube,
                        fontSize: 17,
                      ),
                      fillColor: Theme.of(context).colorScheme.secondary,
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(99),
                        borderSide: BorderSide(
                          color: Color.lerp(
                            Theme.of(context).colorScheme.tertiary,
                            Colors.white,
                            0.8,
                          )!,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(99),
                        borderSide: BorderSide(
                          color: Color.lerp(
                            Theme.of(context).colorScheme.tertiary,
                            Colors.white,
                            0.8,
                          )!,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(99),
                        borderSide: BorderSide(
                          color: Color.lerp(
                            Theme.of(context).colorScheme.tertiary,
                            Colors.white,
                            0.8,
                          )!,
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
                  child: IconButton(
                    onPressed: () {
                      // TODO: implementar envio de mensagem
                    },
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