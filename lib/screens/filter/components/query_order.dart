import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:rota_gourmet/providers/theme_provider.dart';

import '../../../components/section_title.dart';
import '../../../constants.dart';

class QueryOrder extends StatefulWidget {
  const QueryOrder({super.key});

  @override
  State<QueryOrder> createState() => _QueryOrderState();
}

class _QueryOrderState extends State<QueryOrder> {
  int selectedIndex = 0; // Índice do botão selecionado

  final List<Map<String, String>> orderOptions = [
    {"text": "Relevância", "icon": "assets/icons/sort.svg"},
    {"text": "Preço", "icon": "assets/icons/delivery.svg"},
    {"text": "Distância", "icon": "assets/icons/marker.svg"},
  ];

  void _selectOrder(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return Column(
      mainAxisSize: MainAxisSize.min, 
      crossAxisAlignment: CrossAxisAlignment.center, 
      children: [
        SectionTitle(
          title: "Ordenar por",
          press: () {},
          isMainSection: false,
        ),
        const SizedBox(height: defaultPadding),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: List.generate(orderOptions.length, (index) {
              return Padding(
                padding: const EdgeInsets.only(right: defaultPadding),
                child: RoundedButton(
                  index: index,
                  isActive: selectedIndex == index,
                  press: () => _selectOrder(index),
                  text: orderOptions[index]["text"]!,
                  icon: orderOptions[index]["icon"]!,
                ),
              );
            }),
          ),
        ),
      ],
    );
  }
}

class RoundedButton extends StatelessWidget {
  const RoundedButton({
    super.key,
    this.isActive = false,
    required this.index,
    required this.press,
    this.text = "Opção", // Valor padrão
    this.icon = "assets/icons/default_icon.svg", // Valor padrão
  });

  final bool isActive;
  final int index;
  final VoidCallback press;
  final String text;
  final String icon;

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return Column(
      children: [
        SizedBox(
          height: 56,
          width: 56,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.zero,
              backgroundColor: isActive ? ThemeProvider.primaryColor : isDarkMode ? const Color(0xFF2A2D2F) : const Color(0xFFF7F7F7),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(100),
                side: BorderSide(
                  color: isActive ? ThemeProvider.primaryColor : isDarkMode ? const Color(0xFF3A3D3F) : const Color(0xFFE5E5E5),
                ),
              ),
            ),
            onPressed: press,
            child: SvgPicture.asset(
              icon,
              width: 24,
              height: 24,
              colorFilter: ColorFilter.mode(
                isActive ? Colors.white : isDarkMode ? Colors.white70 : const Color(0xFF6C757D),
                BlendMode.srcIn,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8), // Espaço entre botão e texto
        Text(
          text,
          style: TextStyle(
            fontWeight: FontWeight.normal,
            color: isActive ? ThemeProvider.primaryColor : isDarkMode ? Colors.white70 : const Color(0xFF6C757D),
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}
