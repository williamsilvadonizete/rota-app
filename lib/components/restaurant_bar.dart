import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:rota_gourmet/components/resturant_wave_bar.dart';

class RestaurantBar extends StatelessWidget implements PreferredSizeWidget {
  final bool showBackButton;
  final String title;
  final String logoUrl;
  final String backgroundImageUrl;

  const RestaurantBar({
    super.key,
    this.showBackButton = false,
    this.title = '',
    this.logoUrl = '',
    this.backgroundImageUrl = '',
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        RestaurantWaveBar(
          logoSize: 80,
          logoImage: logoUrl,
          backgroundImage: backgroundImageUrl,
        ),
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: Container(
            height: kToolbarHeight + MediaQuery.of(context).padding.top,
            padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(0.7),
                  Colors.transparent,
                ],
              ),
            ),
            child: Row(
              children: [
                if (showBackButton)
                  IconButton(
                    icon: const Icon(
                      Icons.arrow_back_ios,
                      color: Colors.white,
                      size: 20,
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                Expanded(
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: showBackButton ? TextAlign.start : TextAlign.center,
                  ),
                ),
                if (!showBackButton)
                  const SizedBox(width: 48), // Espaço para manter o título centralizado
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(300);

  // Função para lançar URLs
  Future<void> _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Não foi possível abrir o link: $url';
    }
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
