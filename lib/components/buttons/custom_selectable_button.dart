import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomSelectableButton extends StatelessWidget {
  final String icon;
  final String title;
  final String subtitle;
  final bool isSelected;
  final VoidCallback onTap;

  const CustomSelectableButton({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: isSelected ? Theme.of(context).primaryColor : Colors.grey[800],
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: SvgPicture.asset(
                icon,
                height: 40,
                width: 40,
                colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
          Text(
            subtitle,
            style: const TextStyle(fontSize: 12, color: Colors.white),
          ),
        ],
      ),
    );
  }
}

class ButtonSelectionWidget extends StatefulWidget {
  const ButtonSelectionWidget({super.key});

  @override
  State<ButtonSelectionWidget> createState() => _ButtonSelectionWidgetState();
}

class _ButtonSelectionWidgetState extends State<ButtonSelectionWidget> {
  int selectedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomSelectableButton(
          icon: "assets/icons/couple.svg",
          title: "Acompanhado",
          subtitle: "100% OFF NO 2º prato",
          isSelected: selectedIndex == 0,
          onTap: () {
            setState(() {
              selectedIndex = 0;
            });
          },
        ),
        CustomSelectableButton(
          icon: "assets/icons/single.svg",
          title: "Individual",
          subtitle: "30% OFF",
          isSelected: selectedIndex == 1,
          onTap: () {
            setState(() {
              selectedIndex = 1;
            });
          },
        ),
        CustomSelectableButton(
          icon: "assets/icons/delivery_m.svg",
          title: "Delivery",
          subtitle: "20% OFF",
          isSelected: selectedIndex == 2,
          onTap: () {
            setState(() {
              selectedIndex = 2;
            });
          },
        ),
      ],
    );
  }
}
