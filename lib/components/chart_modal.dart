import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:rota_gourmet/constants.dart';

class PerformanceChartModal {
  static void show({
    required BuildContext context,
    required double totalSpent,
    required double totalSaved,
  }) {
    showModalBottomSheet(
      context: context,
      builder: (context) => _PerformanceChartContent(
        totalSpent: totalSpent,
        totalSaved: totalSaved,
      ),
      backgroundColor: primaryColorDark,
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

  double get savedAmount => totalSpent - totalSaved;

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
              'Análise de Economia',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
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
          ),
          PieChartSectionData(
            value: savedAmount,
            color: Colors.blueAccent,
            radius: 60,
            title: '',
          ),
          PieChartSectionData(
            value: totalSpent,
            color: Colors.grey,
            radius: 60,
            title: '',
            showTitle: false,
          ),
        ],
      ),
    );
  }

  Widget _buildLegends() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
         _buildLegend(
          color: Colors.greenAccent,
          text: 'Você economizou: R\$${savedAmount.toStringAsFixed(2)}',
        ),
         const SizedBox(height: 8),
        _buildLegend(
          color: Colors.blueAccent,
          text: 'Total com desconto: R\$${totalSaved.toStringAsFixed(2)}',
        ),
        const SizedBox(height: 8),
        _buildLegend(
          color: Colors.grey,
          text: 'Total sem desconto: R\$${totalSpent.toStringAsFixed(2)}',
        ),
      ],
    );
  }

  Widget _buildLegend({required Color color, required String text}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
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
              color: Colors.white,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}