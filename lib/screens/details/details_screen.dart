import 'package:flutter/material.dart';
import 'package:rota_app/components/restaurant_bar.dart';

import '../../constants.dart';
import 'components/iteams.dart';
import 'components/restaurrant_info.dart';

class DetailsScreen extends StatelessWidget {
  const DetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColorDark,
      appBar: RestaurantBar(showBackButton: true),
      body: const SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: defaultPadding / 2),
              RestaurantInfo(),
              SizedBox(height: defaultPadding),
              Items(),
            ],
          ),
        ),
      ),
    );
  }
}
