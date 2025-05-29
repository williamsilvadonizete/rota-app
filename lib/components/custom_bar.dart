import 'package:flutter/material.dart';
import 'package:rota_gourmet/components/wave_bar.dart';
import 'package:rota_gourmet/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:rota_gourmet/services/auth_service.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  @override
  final Size preferredSize;
  
  final bool showBackButton; // Novo parâmetro para ativar/desativar o botão de voltar

  // Atualize o construtor para aceitar o parâmetro showBackButton
  const CustomAppBar({super.key, this.showBackButton = true}) : preferredSize = const Size.fromHeight(250);

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> {
  final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();
    _validateToken();
  }

  Future<void> _validateToken() async {
    final prefs = await SharedPreferences.getInstance();
    final storedToken = prefs.getString('auth_token');
    if (storedToken != null) {
      final result = await _authService.validateStoredToken();
      if (result != null && result['access_token'] != null) {
        await _saveToken(result['access_token']);
      }
    }
  }

  Future<void> _saveToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
     leading: widget.showBackButton
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
