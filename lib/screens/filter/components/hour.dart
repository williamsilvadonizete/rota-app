import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:rota_gourmet/components/buttons/secondery_button.dart';
import 'package:rota_gourmet/providers/theme_provider.dart';

import '../../../components/section_title.dart';
import '../../../constants.dart';

class TimeSelect extends StatefulWidget {
  final List<int>? initialSelected;
  const TimeSelect({super.key, this.initialSelected});

  @override
  State<TimeSelect> createState() => _TimeSelectState();
}

class _TimeSelectState extends State<TimeSelect> {
  List<Map<String, dynamic>> demoCategories = [
    {"id": "1", "title": "Manhã", "isActive": false, "icon": "assets/icons/nature.svg"},
    {"id": "3", "title": "Tarde", "isActive": false, "icon": "assets/icons/miscellaneous.svg"},
    {"id": "2", "title": "Almoço", "isActive": false,"icon": "assets/icons/sun.svg"},
    {"id": "4", "title": "Jantar", "isActive": false, "icon": "assets/icons/moon.svg"},
  ];

  @override
  void initState() {
    super.initState();
    if (widget.initialSelected != null) {
      for (var d in demoCategories) {
        d['isActive'] = widget.initialSelected!.contains(int.tryParse(d['id'].toString()));
      }
    }
  }

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
            itemBuilder: (context, index) {
              return SeconderyButton(
                press: () {
                  setState(() {
                    demoCategories[index]["isActive"] = !demoCategories[index]["isActive"];
                  });
                },
                isActive: demoCategories[index]["isActive"],
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      demoCategories[index]["icon"],
                      height: 16,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      demoCategories[index]["title"],
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

  List<int> getSelectedTimes() {
    return demoCategories
        .where((d) => d['isActive'] == true)
        .map((d) => int.tryParse(d['id'].toString()) ?? 0)
        .where((id) => id != 0)
        .toList();
  }
}
