import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:rota_gourmet/components/buttons/secondery_button.dart';
import 'package:rota_gourmet/providers/theme_provider.dart';

import '../../../components/section_title.dart';
import '../../../constants.dart';

class TimeSelect extends StatefulWidget {
  const TimeSelect({super.key});

  @override
  State<TimeSelect> createState() => _TimeSelectState();
}

class _TimeSelectState extends State<TimeSelect> {
  List<Map<String, dynamic>> demoCategories = [
    {"title": "Manhã", "isActive": false, "icon": "assets/icons/nature.svg"},
    {"title": "Tarde", "isActive": false, "icon": "assets/icons/miscellaneous.svg"},
    {"title": "Almoço", "isActive": false,"icon": "assets/icons/sun.svg"},
    {"title": "Jantar", "isActive": true, "icon": "assets/icons/moon.svg"},
  ];

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionTitle(
          title: "Horário",
          press: () {},
          isMainSection: false,
        ),
        const SizedBox(height: defaultPadding),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 3.5,
            ),
            itemCount: demoCategories.length,
            itemBuilder: (contxext, index) {
              return SeconderyButton(
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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      demoCategories[index]["icon"],
                      height: 16,
                      colorFilter: ColorFilter.mode(
                        demoCategories[index]["isActive"] 
                          ? Colors.white 
                          : isDarkMode 
                            ? Colors.white70 
                            : const Color(0xFF6C757D),
                        BlendMode.srcIn,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      demoCategories[index]["title"],
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            color: demoCategories[index]["isActive"] 
                              ? Colors.white 
                              : isDarkMode 
                                ? Colors.white70 
                                : const Color(0xFF6C757D),
                            fontSize: 14,
                          ),
                    )
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
