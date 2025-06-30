import 'package:flutter/material.dart';
import 'package:rota_gourmet/constants.dart';
import 'package:rota_gourmet/screens/details/components/restaurant_logo.dart';

class RestaurantWaveBar extends StatelessWidget {
  final double logoSize;
  final String logoImage;
  final String backgroundImage;

  const RestaurantWaveBar({
    super.key,
    required this.logoSize,
    required this.logoImage,
    required this.backgroundImage,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      width: double.infinity,
      color: Colors.black,
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (backgroundImage.isNotEmpty)
            Image.network(
              backgroundImage,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Container(
                  color: Colors.black,
                  child: const Center(
                    child: CircularProgressIndicator(color: Colors.white),
                  ),
                );
              },
              errorBuilder: (context, error, stackTrace) => Container(color: Colors.black),
            ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 100,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.7),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 20,
            right: 20,
            child: Container(
              width: logoSize,
              height: logoSize,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white,
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: ClipOval(
                child: Image.network(
                  logoImage,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey[300],
                      child: const Icon(
                        Icons.restaurant,
                        size: 40,
                        color: Colors.grey,
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 20,
            left: 20,
            child: Row(
              children: [
                _buildIconButton(
                  icon: Icons.location_on,
                  onPressed: () {
                    // Implementar ação de localização
                  },
                ),
                const SizedBox(width: 16),
                _buildIconButton(
                  icon: Icons.phone,
                  onPressed: () {
                    // Implementar ação de telefone
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIconButton({
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return Material(
      color: Colors.transparent,
      elevation: 8,
      shape: const CircleBorder(),
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
