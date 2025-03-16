import 'package:flutter/material.dart';

class RestaurantLogo extends StatelessWidget {
  final double logoSize;
  final String logoImage; // Caminho da logo

  const RestaurantLogo({
    super.key,
    required this.logoSize,
    required this.logoImage,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: -(logoSize / 2),  // Logo sobrepondo 50% para fora da imagem
      right: 20,  // Distância da borda direita
      child: ClipOval(
        child: Image.asset(
          logoImage, // Caminho da logo
          height: logoSize, // Tamanho da logo
          width: logoSize, // Tamanho da logo
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
