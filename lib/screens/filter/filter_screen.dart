import 'package:flutter/material.dart';
import 'package:rota_gourmet/screens/filter/components/activities.dart';
import 'package:rota_gourmet/screens/filter/components/days.dart';

import '../../constants.dart';
import 'components/hour.dart';
import 'components/query_order.dart';

class FilterScreen extends StatelessWidget {
  const FilterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColorDark,
      appBar: AppBar(
        backgroundColor: primaryColorDark,
        title:  const Text(
          "Filtros",
          style: TextStyle(
            color: primaryColor, // Cor do texto
          ),
        ),
      ),
      body: const SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min, 
            crossAxisAlignment: CrossAxisAlignment.center, 
            children: [
              SizedBox(height: defaultPadding),
              QueryOrder(),
              SizedBox(height: defaultPadding),
              DaysSelect(),
              SizedBox(height: defaultPadding),
              TimeSelect(),
              SizedBox(height: defaultPadding),
              ActivitiesSelect(),
              SizedBox(height: defaultPadding),
            ],
          ),
        ),
      ),
    );
  }
}
