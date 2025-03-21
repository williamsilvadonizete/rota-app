import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:rota_app/components/resturant_wave_bar.dart';
import 'package:rota_app/constants.dart';
import 'package:rota_app/screens/details/components/restaurant_logo.dart';

class RestaurantBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  final Size preferredSize;

  final bool showBackButton;

  const RestaurantBar({super.key, this.showBackButton = true})
      : preferredSize = const Size.fromHeight(230);

  // Função para lançar URLs
  Future<void> _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Não foi possível abrir o link: $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: showBackButton
          ? IconButton(
              icon: const Icon(
                Icons.arrow_back,
                color: primaryColor,
                size: 30,
              ),
              onPressed: () {
                Navigator.pop(context); 
              },
            )
          : const SizedBox(),
      backgroundColor: primaryColorDark,
      flexibleSpace: Stack(
        clipBehavior: Clip.none,
        children: [
          // Componente de fundo
          RestaurantBackgroundWave(
            height: 250, // Tamanho do fundo
            backgroundImage: "assets/images/medium_2.png", 
          ),
          RestaurantLogo(
            logoSize: 80, 
            logoImage: "assets/icons/maclogo.png",
          ),
          // Botões de localização, telefone e website na horizontal, no canto inferior esquerdo
          Positioned(
            left: 5,
            bottom:  -50,
            child: Row(
              children: [
                // Botão de localização
                _buildIconButton(
                  icon: Icons.location_on,
                  onPressed: () {
                    _launchURL("https://maps.google.com");
                  },
                ),
                const SizedBox(width: 10), // Espaço entre os botões
                // Botão de telefone
                _buildIconButton(
                  icon: Icons.phone,
                  onPressed: () {
                    _launchURL("tel:+1234567890");
                  },
                ),
                const SizedBox(width: 10), // Espaço entre os botões
                // Botão de website
                _buildIconButton(
                  icon: Icons.web,
                  onPressed: () {
                    _launchURL("https://www.example.com");
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Método para criar o botão com sombra (alto relevo)
  Widget _buildIconButton({
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return Material(
      color: Colors.transparent,
      elevation: 8, // Sombra (alto relevo)
      shape: CircleBorder(),
      child: IconButton(
        icon: Icon(icon, size: 25, color: Colors.white),
        onPressed: onPressed,
        padding: EdgeInsets.zero,
        iconSize: 30,
        splashRadius: 25,
      ),
    );
  }
}
