import 'package:flutter/material.dart';

class RestaurantBackgroundWave extends StatelessWidget {
  final double height;
  final String backgroundImage; // Caminho da imagem de fundo

  const RestaurantBackgroundWave({
    super.key,
    required this.height,
    required this.backgroundImage,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30), // Arredondamento aqui
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: height,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(backgroundImage), // Usando o caminho da imagem de fundo
              fit: BoxFit.cover,
            ),
            gradient: const LinearGradient(
              colors: [Color(0xFFFACCCC), Color(0xFFF6EFE9)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
    );
  }
}
