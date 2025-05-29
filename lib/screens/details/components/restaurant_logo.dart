import 'package:flutter/material.dart';
import 'package:rota_gourmet/constants.dart';

class RestaurantLogo extends StatelessWidget {
  final String logoUrl;

  const RestaurantLogo({
    super.key,
    required this.logoUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
      ),
      child: Center(
        child: Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.white,
              width: 2,
            ),
            image: DecorationImage(
              image: NetworkImage(logoUrl),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}
