import 'package:flutter/material.dart';
import 'package:rota_gourmet/screens/filter/components/activities.dart';
import 'package:rota_gourmet/screens/filter/components/days.dart';
import 'package:rota_gourmet/providers/theme_provider.dart';
import '../../constants.dart';
import 'components/hour.dart';
import 'components/query_order.dart';

class FilterScreen extends StatelessWidget {
  const FilterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      backgroundColor: isDarkMode ? const Color(0xFF1A1D1F) : Colors.white,
      appBar: AppBar(
        backgroundColor: isDarkMode ? const Color(0xFF1A1D1F) : Colors.white,
        title: Text(
          "Filtros",
          style: TextStyle(
            color: isDarkMode ? Colors.white : ThemeProvider.primaryColor,
          ),
        ),
      ),
      body: const SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min, 
            crossAxisAlignment: CrossAxisAlignment.center, 
            children: [
              // SizedBox(height: defaultPadding),
              // QueryOrder(),
              SizedBox(height: defaultPadding),
              DaysSelect(),
              SizedBox(height: defaultPadding),
              TimeSelect(),
              SizedBox(height: defaultPadding),
              // ActivitiesSelect(),
              // SizedBox(height: defaultPadding),
            ],
          ),
        ),
      ),
    );
  }
}
