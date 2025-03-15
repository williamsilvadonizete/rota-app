import 'package:flutter/material.dart';

import '../../../components/section_title.dart';
import '../../../constants.dart';

class Categories extends StatefulWidget {
  const Categories({super.key});

  @override
  State<Categories> createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionTitle(
          title: "Categories",
          press: () {},
          isMainSection: false,
        ),
        const SizedBox(height: defaultPadding),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
          child: Wrap(
            spacing: defaultPadding / 2,
            children: List.generate(
              demoCategories.length,
              (index) => ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(56, 40),
                  backgroundColor: index == 2 ? primaryColor : bodyTextColor,
                ),
              //   SeconderyButton(
              //   press: () {},
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.center,
              //     children: [
              //       SvgPicture.asset(
              //         "assets/icons/location.svg",
              //         height: 24,
              //         colorFilter: const ColorFilter.mode(
              //           primaryColor,
              //           BlendMode.srcIn,
              //         ),
              //       ),
              //       const SizedBox(width: 8),
              //       Text(
              //         "Sua localizaçāo atual",
              //         style: Theme.of(context)
              //             .textTheme
              //             .bodyMedium!
              //             .copyWith(color: primaryColor),
              //       )
              //     ],
              //   ),
              // ),
                child: Text(demoCategories[index]["title"]),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // Demo data categories
  List<Map<String, dynamic>> demoCategories = [
    {"title": "All", "isActive": false},
    {"title": "Brunch", "isActive": false},
    {"title": "Dinner", "isActive": false},
    {"title": "Burgers", "isActive": true},
    {"title": "Chinese", "isActive": false},
    {"title": "Pizza", "isActive": false},
    {"title": "Salads", "isActive": false},
    {"title": "Soups", "isActive": false},
    {"title": "Breakfast", "isActive": false},
  ];
}
