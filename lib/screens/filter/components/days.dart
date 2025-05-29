import 'package:flutter/material.dart';
import 'package:rota_gourmet/components/buttons/secondery_button.dart';
import 'package:rota_gourmet/providers/theme_provider.dart';

import '../../../components/section_title.dart';
import '../../../constants.dart';

class DaysSelect extends StatefulWidget {
  const DaysSelect({super.key});

  @override
  State<DaysSelect> createState() => _DaysSelectState();
}

class _DaysSelectState extends State<DaysSelect> {
  List<Map<String, dynamic>> demoCategories = [
    {"title": "D", "isActive": false},
    {"title": "S", "isActive": false},
    {"title": "T", "isActive": false},
    {"title": "Q", "isActive": false},
    {"title": "Q", "isActive": false},
    {"title": "S", "isActive": false},
    {"title": "S", "isActive": false},
  ];

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionTitle(
          title: "Dias de Uso",
          press: () {},
          isMainSection: false,
        ),
        const SizedBox(height: defaultPadding),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(
              demoCategories.length,
              (index) => SizedBox(
                width: 40,
                height: 40,
                child: SeconderyButton(
                  press: () {
                    setState(() {
                      demoCategories[index]["isActive"] = !demoCategories[index]["isActive"];
                    });
                  },
                  backgroundColor: demoCategories[index]["isActive"] 
                    ? ThemeProvider.primaryColor 
                    : isDarkMode 
                      ? const Color(0xFF2A2D2F) 
                      : const Color(0xFFF7F7F7),
                  child: Container(
                    width: double.infinity,
                    height: double.infinity,
                    alignment: Alignment.center,
                    child: Text(
                      demoCategories[index]["title"],
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            color: demoCategories[index]["isActive"] 
                              ? Colors.white 
                              : isDarkMode 
                                ? Colors.white70 
                                : const Color(0xFF6C757D),
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            height: 1,
                          ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}