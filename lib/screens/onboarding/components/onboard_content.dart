import 'package:flutter/material.dart';

import '../../../constants.dart';

class OnboardContent extends StatelessWidget {
  const OnboardContent({
    super.key,
    required this.illustration,
    required this.title,
    required this.text,
  });

  final String? illustration, title, text;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: AspectRatio(
            aspectRatio: 1,
            child: Image.asset(illustration!),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          title!,
          style: Theme.of(context)
              .textTheme
              .titleLarge!
              .copyWith(fontWeight: FontWeight.bold,
              color: accentColor)
        ),
        const SizedBox(height: 8),
        Text(
          text!,
          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                 color: labelColor, // Altere para a cor desejada
          ),
          textAlign: TextAlign.center,
          
        ),
      ],
    );
  }
}
