import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:rota_app/constants.dart'; // Certifique-se de que o seu arquivo constants.dart está importado aqui.

class ChartWidget extends StatelessWidget {
  final double totalSavings;

  const ChartWidget({
    super.key,
    required this.totalSavings,
  });

  @override
  Widget build(BuildContext context) {
    // Dados mock para os últimos 4 meses
    final List<BarChartGroupData> mockBarData = [
      BarChartGroupData(
        x: 0,
        barRods: [
          BarChartRodData(fromY: 0, toY: 70, color: Colors.blue),
        ],
      ),
      BarChartGroupData(
        x: 1,
        barRods: [
          BarChartRodData(fromY: 0, toY: 50, color: Colors.blue),
        ],
      ),
      BarChartGroupData(
        x: 2,
        barRods: [
          BarChartRodData(fromY: 0, toY: 90, color: Colors.blue),
        ],
      ),
      BarChartGroupData(
        x: 3,
        barRods: [
          BarChartRodData(fromY: 0, toY: 30, color: Colors.blue),
        ],
      ),
    ];

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: defaultPadding, vertical: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: primaryColorDark,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Label para mostrar o total economizado de forma destacada
          Text(
            "Você economizou: R\$ ${totalSavings.toStringAsFixed(2)}",
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 250,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: 100,
                barGroups: mockBarData,
                borderData: FlBorderData(show: false),
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (double value, TitleMeta meta) {
                        const months = [
                          'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
                          'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
                        ];
                        return Text(
                          months[value.toInt() % months.length],
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      },
                    ),
                  ),
                  topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                gridData: FlGridData(show: false),
                barTouchData: BarTouchData(
                  touchTooltipData: BarTouchTooltipData(
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      return BarTooltipItem(
                        rod.toY.toString(),
                        const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
