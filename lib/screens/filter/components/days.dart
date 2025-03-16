import 'package:flutter/material.dart';
import 'package:rota_app/components/buttons/secondery_button.dart';

import '../../../components/section_title.dart';
import '../../../constants.dart';

class DaysSelect extends StatefulWidget {
  const DaysSelect({super.key});

  @override
  State<DaysSelect> createState() => _DaysSelectState();
}

class _DaysSelectState extends State<DaysSelect> {
  List<Map<String, dynamic>> demoCategories = [
    {"title": "Seg", "isActive": false},
    {"title": "Ter", "isActive": false},
    {"title": "Qua", "isActive": false},
    {"title": "Qui", "isActive": false},
    {"title": "Sex", "isActive": false},
    {"title": "Sab", "isActive": false},
    {"title": "Dom", "isActive": false},
  ];

  @override
  Widget build(BuildContext context) {
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
              (index) => Expanded( // Utilizando Expanded para garantir que todos os botões tenham o mesmo tamanho
                child: SeconderyButton(
                  press: () {
                    setState(() {
                      demoCategories[index]["isActive"] = !demoCategories[index]["isActive"];
                    });
                  },
                  backgroundColor: demoCategories[index]["isActive"] ? primaryColor : primaryColorDark,
                  child: Center(
                    child: Text(
                      demoCategories[index]["title"],
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            color: demoCategories[index]["isActive"] ? primaryColorDark : bodyTextColor,
                            fontSize: 11, // Mantendo o tamanho reduzido
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
