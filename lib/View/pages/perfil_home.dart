import 'package:flutter/material.dart';
import 'package:projeto_mobile/View/pages/historico_compras_page.dart';
import 'package:projeto_mobile/View/pages/login.dart';
import 'package:projeto_mobile/View/pages/status_leitura_page.dart';
import 'package:projeto_mobile/View/widgets/appbar_widget.dart';
import 'package:projeto_mobile/View/widgets/perfil_button_widget.dart';
import 'package:projeto_mobile/View/widgets/perfil_card.dart';
import 'package:projeto_mobile/View/widgets/rodape_widget.dart';
import 'package:projeto_mobile/View/widgets/sidebar_widget.dart';
import 'package:projeto_mobile/config/app_colors.dart';
import 'package:projeto_mobile/config/theme_controller.dart';
import 'package:projeto_mobile/config/token_config.dart';
import 'package:projeto_mobile/services/usuario_participante_service.dart';

class PerfilHome extends StatefulWidget {
  final String livros;
  const PerfilHome({super.key, this.livros = '42'});

  @override
  State<PerfilHome> createState() => _PerfilHomeState();
}

class _PerfilHomeState extends State<PerfilHome> {
  final ParticipantUserService _participantService = ParticipantUserService();
  int _totalClubes = 0;
  bool _carregando = true;

  @override
  void initState() {
    super.initState();
    _carregarClubes();
  }

  Future<void> _carregarClubes() async {
    final userId = TokenConfig.userId;
    if (userId == null) {
      setState(() => _carregando = false);
      return;
    }

    final total = await _participantService.fetchClubCountByUser(userId);
    setState(() {
      _totalClubes = total;
      _carregando = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final usuario = TokenConfig.usuario;
    final nome = usuario?.nome.isNotEmpty == true ? usuario!.nome : 'Usuário';
    final email = usuario?.email ?? '';

    return Scaffold(
      drawer: SidebarWidget(),
      appBar: BooklyAppBar(
        title: 'Minha Conta',
        iconeMenu: true,
        iconeCarrinho: false,
        iconeSeta: false,
        corDoTexto: AppColors.perfil,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          spacing: 12,
          children: [
            PerfilCardWidget(
              nome: nome,
              email: email,
              //livros: widget.livros,
              clubes: _carregando ? '...' : _totalClubes.toString(),
              onEditarVoltar: () => setState(() {}),
            ),
            PerfilButtonWidget(
              titulo: 'Histórico de Compras',
              icone: Icon(Icons.receipt_long, color: AppColors.perfil),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const HistoricoComprasPage(),
                  ),
                );
              },
            ),
            PerfilButtonWidget(
              titulo: 'Minha Leitura',
              icone: Icon(Icons.bar_chart, color: Colors.green),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const StatusLeituraPage()),
                );
              },
            ),
            PerfilButtonWidget(
              titulo: 'Modo Escuro',
              icone: Icon(Icons.nightlight_round, color: Colors.orange),
              onTap: toggleTheme,
            ),
            PerfilButtonWidget(
              titulo: 'Sair da Conta',
              icone: Icon(Icons.logout, color: Colors.red),
              sair: true,
              onTap: () {
                TokenConfig.limpar();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginPage()),
                  (route) => false,
                );
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: Rodape(selectedTab: NavTab.conta),
    );
  }
}
