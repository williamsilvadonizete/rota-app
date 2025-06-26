import 'package:flutter/material.dart';
import 'package:rota_gourmet/screens/filter/components/activities.dart';
import 'package:rota_gourmet/screens/filter/components/days.dart';
import 'package:rota_gourmet/providers/theme_provider.dart';
import '../../constants.dart';
import 'components/hour.dart';
import 'components/query_order.dart';

class FilterScreen extends StatefulWidget {
  const FilterScreen({super.key});

  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  final GlobalKey _daysKey = GlobalKey();
  final GlobalKey _timeKey = GlobalKey();

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
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min, 
            crossAxisAlignment: CrossAxisAlignment.center, 
            children: [
              SizedBox(height: defaultPadding),
              DaysSelect(key: _daysKey),
              SizedBox(height: defaultPadding),
              TimeSelect(key: _timeKey),
              SizedBox(height: defaultPadding),
              SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      // Coletar dias e horários selecionados
                      final selectedDays = (_daysKey.currentState as dynamic)?.getSelectedDays() ?? [];
                      final selectedTimes = (_timeKey.currentState as dynamic)?.getSelectedTimes() ?? [];
                      Navigator.pop(context, {
                        'dias': selectedDays,
                        'horarios': selectedTimes,
                      });
                    },
                    child: const Text('Aplicar Filtros'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
