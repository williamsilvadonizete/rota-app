import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:rota_app/components/buttons/secondery_button.dart';

import '../../../components/section_title.dart';
import '../../../constants.dart';

class ActivitiesSelect extends StatefulWidget {
  const ActivitiesSelect({super.key});

  @override
  State<ActivitiesSelect> createState() => _ActivitiesSelectState();
}

class _ActivitiesSelectState extends State<ActivitiesSelect> {
  List<Map<String, dynamic>> demoCategories = [
    {"title": "Acompanhado", "isActive": false, "icon": "assets/icons/couple.svg"},
    {"title": "Individual", "isActive": false, "icon": "assets/icons/single.svg"},
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionTitle(
          title: "Atividade",
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
              crossAxisCount: 2, // 2 colunas
              crossAxisSpacing: 10, // Espaço entre colunas
              mainAxisSpacing: 10, // Espaço entre linhas
              childAspectRatio: 3.5, // Ajuste do tamanho do botão
            ),
            itemCount: demoCategories.length,
            itemBuilder: (contxext, index) {
              return SeconderyButton(
                press: () {
                  setState(() {
                    demoCategories[index]["isActive"] = !demoCategories[index]["isActive"];
                  });
                },
                backgroundColor:  demoCategories[index]["isActive"] ? primaryColor : primaryColorDark,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      demoCategories[index]["icon"],
                      height: 16, // Ícone um pouco maior para melhor visualização
                      colorFilter: ColorFilter.mode(
                        demoCategories[index]["isActive"] ? primaryColorDark : bodyTextColor,
                        BlendMode.srcIn,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      demoCategories[index]["title"],
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            color: demoCategories[index]["isActive"] ? primaryColorDark : bodyTextColor,
                            fontSize: 14, // Ajuste do tamanho da fonte
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
