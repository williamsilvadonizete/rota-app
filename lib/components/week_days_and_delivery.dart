import 'package:flutter/material.dart';
import '../constants.dart';

class WeekDaysAndDelivery extends StatelessWidget {
  const WeekDaysAndDelivery({
    super.key,
    required this.weekDays,
  });

  final List<String> weekDays;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ...List.generate(
          7, // Para cada dia da semana
          (index) {
            String day = _getDayName(index);
            bool isOpen = weekDays.contains(day);
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: defaultPadding / 2),
              child: Row(
                children: [
                  Text(
                    day,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: isOpen ? Colors.green : titleColor.withOpacity(0.5),
                          fontWeight: isOpen ? FontWeight.bold : FontWeight.normal,
                        ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  String _getDayName(int index) {
    // Lista de dias da semana em português
    const days = [
      "Seg",
      "Ter",
      "Qua",
      "Qui",
      "Sex",
      "Sab",
      "Dom"
    ];
    return days[index];
  }
}
