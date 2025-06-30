import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:rota_gourmet/constants.dart';
import 'package:rota_gourmet/services/restaurant_service.dart';
import 'package:rota_gourmet/models/benefit_usage.dart';

class PerformanceChartModal {
  static void show({
    required BuildContext context,
  }) {
    showModalBottomSheet(
      context: context,
      builder: (context) => const _PerformanceChartContent(),
      backgroundColor: primaryColorDark,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      isScrollControlled: true,
    );
  }
}

class _PerformanceChartContent extends StatefulWidget {
  const _PerformanceChartContent();

  @override
  State<_PerformanceChartContent> createState() => _PerformanceChartContentState();
}

class _PerformanceChartContentState extends State<_PerformanceChartContent> {
  final RestaurantService _restaurantService = RestaurantService();
  BenefitUsage? _benefitUsage;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadBenefitData();
  }

  Future<void> _loadBenefitData() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      final data = await _restaurantService.getBenefitUsageHistory();
      
      if (mounted) {
        if (data != null) {
          setState(() {
            _benefitUsage = BenefitUsage.fromJson(data);
            _isLoading = false;
          });
        } else {
          setState(() {
            _error = 'Erro ao carregar dados';
            _isLoading = false;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = 'Erro inesperado: $e';
          _isLoading = false;
        });
      }
    }
  }

  double get totalSaved => _benefitUsage?.totalDiscount ?? 0.0;
  
  double get totalSpent {
    if (_benefitUsage == null) return 0.0;
    double total = 0.0;
    for (var monthly in _benefitUsage!.monthlyUsage) {
      for (var usage in monthly.usages) {
        total += usage.billAmountFull;
      }
    }
    return total;
  }

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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Análise de Economia',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                if (_isLoading)
                  const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                else
                  IconButton(
                    icon: const Icon(Icons.refresh, color: Colors.white),
                    onPressed: _loadBenefitData,
                  ),
              ],
            ),
            const SizedBox(height: 20),
            if (_isLoading)
              const Expanded(
                child: Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
              )
            else if (_error != null)
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        color: Colors.red[300],
                        size: 48,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        _error!,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _loadBenefitData,
                        child: const Text('Tentar Novamente'),
                      ),
                    ],
                  ),
                ),
              )
            else if (_benefitUsage != null)
              Expanded(
                child: _buildPieChart(),
              ),
            const SizedBox(height: 20),
            if (!_isLoading && _error == null && _benefitUsage != null)
              _buildLegends(),
          ],
        ),
      ),
    );
  }

  Widget _buildPieChart() {
    if (totalSpent == 0) {
      return const Center(
        child: Text(
          'Nenhum dado disponível',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
      );
    }

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
        const SizedBox(height: 8),
        _buildLegend(
          color: Colors.orange,
          text: 'Usos totais: ${_benefitUsage?.totalUsed ?? 0}',
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