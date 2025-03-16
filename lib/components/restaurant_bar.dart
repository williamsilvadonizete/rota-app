import 'package:flutter/material.dart';
import 'package:rota_app/components/resturant_wave_bar.dart';
import 'package:rota_app/constants.dart';
import 'package:rota_app/screens/details/components/restaurant_logo.dart';

class RestaurantBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  final Size preferredSize;

  final bool showBackButton;

  const RestaurantBar({super.key, this.showBackButton = true})
      : preferredSize = const Size.fromHeight(230);

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
      backgroundColor: Colors.transparent,
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
        ],
      ),
    );
  }
}
