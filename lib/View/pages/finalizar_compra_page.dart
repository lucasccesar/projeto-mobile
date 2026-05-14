import 'package:flutter/material.dart';
import 'package:projeto_mobile/config/app_colors.dart';
import 'package:projeto_mobile/View/widgets/bookly_appbar_widget.dart';

class FinalizarCompraPage extends StatelessWidget {
  const FinalizarCompraPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F0E8),
      appBar: BooklyAppBar(
        title: 'Finalizar Compra',
        corDoTexto: AppColors.compra,
        iconeMenu: false,
        iconeSeta: true,
        iconeCarrinho: false,
      ),
      body: const Center(
        child: Text('Em breve...'),
      ),
    );
  }
}
