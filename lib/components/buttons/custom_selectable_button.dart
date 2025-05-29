import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rota_gourmet/providers/theme_provider.dart';

class CustomSelectableButton extends StatelessWidget {
  final String icon;
  final String title;
  final String subtitle;
  final bool isSelected;
  final VoidCallback? onTap;
  final bool isDisabled;

  const CustomSelectableButton({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.isSelected,
    this.onTap,
    this.isDisabled = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return GestureDetector(
      onTap: isDisabled ? null : onTap,
      child: Opacity(
        opacity: isDisabled ? 0.5 : 1.0,
        child: Column(
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: isSelected 
                  ? ThemeProvider.primaryColor
                  : isDisabled 
                    ? isDarkMode ? Colors.grey[700] : Colors.grey[300]
                    : isDarkMode ? Colors.grey[800] : Colors.grey[200],
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
              style: TextStyle(
                fontWeight: FontWeight.bold, 
                color: isDarkMode ? Colors.white : Colors.black87
              ),
            ),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 12, 
                color: isDarkMode ? Colors.white70 : Colors.black54
              ),
            ),
          ],
        ),
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
