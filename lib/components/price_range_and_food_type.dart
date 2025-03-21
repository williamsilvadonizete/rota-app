import 'package:flutter/material.dart';
import '../constants.dart';

class PriceRangeAndType extends StatelessWidget {
  const PriceRangeAndType({
    super.key,
    this.priceRange = "\$\$",
    required this.types,
    required this.icons,
  });

  final String priceRange;
  final List<String> types;
  final List<IconData> icons;

  @override
  Widget build(BuildContext context) {
    assert(types.length == icons.length, "Cada tipo deve ter um ícone correspondente");

    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: defaultPadding,
      runSpacing: defaultPadding,
      children: [
        Text(priceRange, style: Theme.of(context).textTheme.bodyMedium),
        ...List.generate(types.length, (index) => buildTypeItem(context, icons[index], types[index])),
      ],
    );
  }

  Widget buildTypeItem(BuildContext context, IconData icon, String type) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: Colors.white),
        const SizedBox(width: 4),
        Text(type, style: Theme.of(context).textTheme.bodyMedium),
      ],
    );
  }
}
