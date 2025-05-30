import 'package:flutter/material.dart';
import 'package:rota_gourmet/providers/theme_provider.dart';

class SeconderyButton extends StatelessWidget {
  final VoidCallback press;
  final Widget child;
  final bool isPrimary;
  final bool isActive;

  const SeconderyButton({
    super.key,
    required this.press,
    required this.child,
    this.isPrimary = false,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    Color buttonColor;
    Color borderColor;
    Color contentColor;
    Color textColor;

    if (isPrimary) {
      buttonColor = ThemeProvider.primaryColor;
      borderColor = Colors.transparent;
      contentColor = Colors.white;
      textColor = Colors.white;
    } else if (isActive) {
      buttonColor = ThemeProvider.primaryColor;
      borderColor = ThemeProvider.primaryColor;
      contentColor = Colors.white;
      textColor = const Color(0xFF333333);
    } else {
      if (isDarkMode) {
        buttonColor = const Color(0xFF2A2D2F);
        borderColor = const Color(0xFF3A3D3F);
        contentColor = Colors.white70;
        textColor = Colors.white70;
      } else {
        buttonColor = const Color(0xFFF7F7F7);
        borderColor = const Color(0xFFE5E5E5);
        contentColor = const Color(0xFF6C757D);
        textColor = const Color(0xFF6C757D);
      }
    }

    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        color: buttonColor,
        border: Border.all(
          color: borderColor,
          width: 1.5,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: press,
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: IconTheme.merge(
              data: IconThemeData(color: contentColor),
              child: DefaultTextStyle.merge(
                style: TextStyle(color: textColor),
                child: child,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
