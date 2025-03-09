import 'package:flutter/material.dart';
import 'package:rota_app/components/wave_bar.dart';
import 'package:rota_app/constants.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  final Size preferredSize;
  
  final bool showBackButton; // Novo parâmetro para ativar/desativar o botão de voltar

  // Atualize o construtor para aceitar o parâmetro showBackButton
  const CustomAppBar({super.key, this.showBackButton = true}) : preferredSize = const Size.fromHeight(250);

  @override
  Widget build(BuildContext context) {
    return AppBar(
     leading: showBackButton
          ? IconButton(
              icon: const Icon(
                Icons.arrow_back,  // Ícone de voltar
                color: primaryColor,  // Cor personalizada
                size: 30,           // Tamanho do ícone
              ),
              onPressed: () {
                Navigator.pop(context); // Volta para a tela anterior
              },
            )
          : const SizedBox(), // Se showBackButton for false, não exibe o botão de voltar
      backgroundColor: primaryColorDark,
      flexibleSpace: BackgroundWave(height: 400),
    );
  }
}
