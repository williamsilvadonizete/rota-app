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
    {"id": "7", "title": "D", "isActive": false},
    {"id": "1","title": "S", "isActive": false},
    {"id": "2","title": "T", "isActive": false},
    {"id": "3","title": "Q", "isActive": false},
    {"id": "4","title": "Q", "isActive": false},
    {"id": "5","title": "S", "isActive": false},
    {"id": "6","title": "S", "isActive": false},
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
                width: 50,
                height: 50,
                child: SeconderyButton(
                  press: () {
                    setState(() {
                      demoCategories[index]["isActive"] = !demoCategories[index]["isActive"];
                    });
                  },
                  isActive: demoCategories[index]["isActive"],
                  child: Container(
                    width: double.infinity,
                    height: double.infinity,
                    alignment: Alignment.center,
                    child: Text(
                      demoCategories[index]["title"],
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