import 'package:flutter/material.dart';
import 'package:rota_gourmet/providers/theme_provider.dart';

class SeconderyButton extends StatelessWidget {
  final VoidCallback press;
  final Widget child;

  const SeconderyButton({
    super.key,
    required this.press,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        border: Border.all(
          color: isDarkMode 
            ? ThemeProvider.primaryColor.withOpacity(0.5)
            : Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.24) ?? Colors.grey,
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
            child: child,
          ),
        ),
      ),
    );
  }
}
