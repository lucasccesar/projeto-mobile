import 'package:flutter/material.dart';
import 'package:projeto_mobile/config/app_colors.dart';
import 'package:projeto_mobile/View/widgets/bookly_appbar_widget.dart';
import 'package:projeto_mobile/View/widgets/clube_mensagem.dart';
import 'package:projeto_mobile/View/widgets/sidebar_widget.dart';

class ClubeMensagem extends StatelessWidget {
  const ClubeMensagem({super.key});

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
          //TODO: deixar container resposivo
          //TODO: lista de mensagens rolavel
        Expanded(
          child: ListView(
            padding:  EdgeInsets.all(8),
            children: [
              ClubeMensagemWidget(autor: 'Molodas', texto: 'Alguém já começou a ler o livro deste mês?', hora: '10:00', isMe: false),
              ClubeMensagemWidget(autor: 'Eu', texto: 'Sim! Já estou no capítulo 5, adorando até agora.', hora: '10:01', isMe: true),
              ClubeMensagemWidget(autor: 'Molodas', texto: 'Que bom! Eu também, a escrita é incrível.', hora: '10:02', isMe: false),
              ClubeMensagemWidget(autor: 'Ana', texto: 'Li a versão em inglês e é ainda melhor no original.', hora: '10:05', isMe: false),
              ClubeMensagemWidget(autor: 'Eu', texto: 'Preciso tentar a versão original então!', hora: '10:06', isMe: true),
              ClubeMensagemWidget(autor: 'Carlos', texto: 'Alguém quer marcar um encontro para discutir?', hora: '10:10', isMe: false),
              ClubeMensagemWidget(autor: 'Ana', texto: 'Boa ideia! Que tal no próximo sábado?', hora: '10:11', isMe: false),
              ClubeMensagemWidget(autor: 'Molodas', texto: 'Sábado perfeito para mim!', hora: '10:12', isMe: false),
              ClubeMensagemWidget(autor: 'Eu', texto: 'Combinado, sábado às 15h então?', hora: '10:13', isMe: true),
              ClubeMensagemWidget(autor: 'Carlos', texto: 'Perfeito, estarei lá!', hora: '10:14', isMe: false),
            ],
          ),
        ),

          //Spacer(), 
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
                //enviar mensagem
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
                      hintMaxLines: null,

                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(99),
                        borderSide: BorderSide(
                          color: Color.lerp(
                            Theme.of(context).colorScheme.tertiary,
                            Colors.white,
                            0.8,
                          )!,
                          width: 1.0,
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
                          width: 1.0,
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
                          width: 1.0,
                        ),
                      ),
                    ),
                  ),
                ),

                SizedBox(width: 10),

                //botao de enviar msgm
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.clube,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: IconButton(
                    onPressed: () {
                      print('teste');
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
