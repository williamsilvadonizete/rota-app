import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:rota_app/constants.dart'; // Ajuste conforme seu projeto

class PerformanceChartModal {
  static void show({
    required BuildContext context,
    required double totalSpent,    // Valor total gasto (pago)
    required double totalSaved,    // Valor economizado
  }) {
    showModalBottomSheet(
      context: context,
      builder: (context) => _PerformanceChartContent(
        totalSpent: totalSpent,
        totalSaved: totalSaved,
      ),
      backgroundColor: primaryColorDark, // Cor de fundo (ajuste conforme suas constantes)
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      isScrollControlled: true,
    );
  }
}

class _PerformanceChartContent extends StatelessWidget {
  final double totalSpent;
  final double totalSaved;

  const _PerformanceChartContent({
    required this.totalSpent,
    required this.totalSaved,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.6,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Total Economizado',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white, // Cor ajustável
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: _buildPieChart(),
            ),
            const SizedBox(height: 20),
            _buildLegends(),
          ],
        ),
      ),
    );
  }

  Widget _buildPieChart() {
    return PieChart(
      PieChartData(
        centerSpaceRadius: 40,
        sectionsSpace: 0,
        startDegreeOffset: -90,
        sections: [
          PieChartSectionData(
            value: totalSaved,
            color: Colors.greenAccent,
            radius: 60,
            title: '',
            titleStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87, // Cor do texto
            ),
          ),
          PieChartSectionData(
            value: totalSpent,
            color: Colors.grey,
            radius: 60,
            title: '',
            titleStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegends() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildLegend(
          color: Colors.greenAccent,
          text: 'Economizado: R\$${totalSaved.toStringAsFixed(2)}',
        ),
        const SizedBox(width: 16),
        _buildLegend(
          color: Colors.grey,
          text: 'Gasto: R\$${totalSpent.toStringAsFixed(2)}',
        ),
      ],
    );
  }

  Widget _buildLegend({required Color color, required String text}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          text,
          style: const TextStyle(
            color: Colors.white, // Cor ajustável
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}