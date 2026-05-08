import 'package:flutter/material.dart';
import 'package:projeto_mobile/view/widgets/clube_appbar_widget.dart';
import 'package:projeto_mobile/view/widgets/rodape_navegacao_clube_widget.dart';
import '../widgets/clube_pesquisa_widget.dart';

class ClubesPage extends StatelessWidget {
  const ClubesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      //TODO: criar um widget para o AppBar - ok
        appBar: const ClubeAppBar(title: 'Clubes do Livro'),
      //TODO: criar um widget para o Drawer
        drawer: Drawer(),
      body: Padding(
        //Ajeitando as bordas dos clubes
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Busca + botão
            Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Nome ou Tema',
                      prefixIcon: const Icon(Icons.search),
                      filled: true,
                      fillColor: const Color(0xFFF5F1EB),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide(color: Color(0xFF8B7355), width: 1.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide(color: Color(0xFF8B7355), width: 1.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide(color: Color(0xFF8B7355), width: 1.0),
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 10),

                ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.add),
                  label: const Text("Criar Clube"),
                  
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4A7FA5),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                )
              ],
            ),

            const SizedBox(height: 20),

            // Lista de clubes
            Expanded(
              child: ListView(
                children: const [
                  ClubPesquisa(
                    title: "Fallen",
                    category: "Professor",
                    participants: 12,
                    date: "14/04 - 29/04",
                    //status: "Ativo",
                  ),
                  ClubPesquisa(
                    title: "Molodoy",
                    category: "Furioso",
                    participants: 8,
                    date: "01/05 - 20/05",
                    //status: "Ativo",
                  ),
                  ClubPesquisa(
                    title: "Yekindar",
                    category: "Fraco?",
                    participants: 23,
                    date: "",
                    //status: "Encerrado",
                  ),
                                    ClubPesquisa(
                    title: "Kscerato",
                    category: "Mira quente",
                    participants: 23,
                    date: "",
                    //status: "Encerrado",
                  ),
                                    ClubPesquisa(
                    title: "Yuri",
                    category: "Enterna Promessa",
                    participants: 23,
                    date: "",
                    //status: "Encerrado",
                  ),
                                    ClubPesquisa(
                    title: "Sidde",
                    category: "cabecao",
                    participants: 23,
                    date: "",
                    //status: "Encerrado",
                  ),
                ],
              ),
            )
          ],
        ),
      ),

      //bottomNavigationBar: const ClubeRodape(),

    );
  }
}