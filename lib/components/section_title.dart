import 'package:flutter/material.dart';

import '../constants.dart';

class SectionTitle extends StatelessWidget {
  const SectionTitle({
    super.key,
    this.isMainSection = true,
    required this.title,
    required this.press,
  });

// Main Section means on Home page section
  final bool isMainSection;
  final String title;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            isMainSection ? title : title.toUpperCase(),
            style: isMainSection
                ? Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: const Color.fromARGB(228, 245, 143, 26),
                )
                : Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: const Color.fromARGB(228, 245, 143, 26),
                ),    
          ),
          GestureDetector(
            onTap: press,
            child: Text(
              isMainSection ? "Mostrar Todos" : "Limpar".toUpperCase(),
              style: isMainSection
                  ? Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .copyWith(color: primaryColor)
                  : TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: titleColor.withOpacity(0.64),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
