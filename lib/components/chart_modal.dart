import 'package:flutter/material.dart';
import 'package:rota_app/constants.dart';
import 'package:fl_chart/fl_chart.dart'; // Certifique-se que está no pubspec.yaml

class ChartModal {
  static void show(BuildContext context, {required double totalSavings, required double totalExpected}) {
    showModalBottomSheet(
      backgroundColor: primaryColorDark,
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      isScrollControlled: true,
      builder: (context) {
        return FractionallySizedBox(
          heightFactor: 0.6,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      'Gráfico de Desempenho',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: primaryColor),
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    height: 200,
                    child: PieChartWidget(
                      totalSavings: totalSavings,
                      totalExpected: totalExpected,
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Adicionando as legendas
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Legend(color: Colors.greenAccent, text: 'Valor Economizado'),
                      const SizedBox(width: 16),
                      Legend(color: Colors.orange, text: 'Valor Pago'),
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class PieChartWidget extends StatelessWidget {
  final double totalSavings;
  final double totalExpected;

  const PieChartWidget({super.key, required this.totalSavings, required this.totalExpected});

  @override
  Widget build(BuildContext context) {
    final double amountPaid = (totalExpected - totalSavings).clamp(0, double.infinity);

    return PieChart(
      PieChartData(
        centerSpaceRadius: 50,
        sectionsSpace: 5,
        sections: [
          PieChartSectionData(
            value: totalSavings,
            color: Colors.greenAccent,
            title: 'A', // Sem texto dentro do gráfico
          ),
          PieChartSectionData(
            value: amountPaid,
            color: Colors.orange,
            title: 'B', // Sem texto dentro do gráfico
          ),
        ],
      ),
    );
  }
}

class Legend extends StatelessWidget {
  final Color color;
  final String text;

  const Legend({super.key, required this.color, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 6),
        Text(
          text,
          style: const TextStyle(color: labelColor, fontSize: 12),
        ),
      ],
    );
  }
}
