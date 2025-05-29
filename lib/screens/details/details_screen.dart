import 'package:flutter/material.dart';
import 'package:rota_gourmet/components/restaurant_bar.dart';
import 'package:rota_gourmet/constants.dart';
import 'components/iteams.dart';
import 'components/restaurrant_info.dart';

class DetailsScreen extends StatelessWidget {
  final Map<String, dynamic> restaurant;

  const DetailsScreen({
    super.key,
    required this.restaurant,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      extendBodyBehindAppBar: true,
      appBar: RestaurantBar(
        showBackButton: true,
        title: restaurant['restaurantName'] ?? '',
        logoUrl: restaurant['logoUrl'] ?? '',
        backgroundImageUrl: restaurant['backgroundImageUrl'] ?? '',
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 300),
            RestaurantInfo(restaurant: restaurant),
            const SizedBox(height: defaultPadding),
            const Items(),
          ],
        ),
      ),
    );
  }
}
