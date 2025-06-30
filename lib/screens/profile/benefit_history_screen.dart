import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rota_gourmet/providers/theme_provider.dart';
import 'package:rota_gourmet/constants.dart';
import 'package:rota_gourmet/services/restaurant_service.dart';
import 'package:rota_gourmet/models/benefit_usage.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

class BenefitHistoryScreen extends StatefulWidget {
  const BenefitHistoryScreen({super.key});

  @override
  State<BenefitHistoryScreen> createState() => _BenefitHistoryScreenState();
}

class _BenefitHistoryScreenState extends State<BenefitHistoryScreen> {
  final RestaurantService _restaurantService = RestaurantService();
  BenefitUsage? _benefitUsage;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadBenefitHistory();
  }

  Future<void> _loadBenefitHistory() async {
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
            _error = 'Erro ao carregar histórico';
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

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;
    
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Histórico de Benefícios'),
        backgroundColor: isDarkMode ? const Color(0xFF1A1D1F) : const Color(0xFFF5F5DC),
        foregroundColor: isDarkMode ? Colors.white : const Color(0xFF666666),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadBenefitHistory,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? _buildErrorWidget()
              : _buildContent(),
    );
  }

  Widget _buildErrorWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: Theme.of(context).colorScheme.error,
          ),
          const SizedBox(height: 16),
          Text(
            _error!,
            style: Theme.of(context).textTheme.titleMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _loadBenefitHistory,
            child: const Text('Tentar Novamente'),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    if (_benefitUsage == null) return const SizedBox.shrink();

    return RefreshIndicator(
      onRefresh: _loadBenefitHistory,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSummaryCards(),
            const SizedBox(height: defaultPadding * 2),
            _buildChart(),
            const SizedBox(height: defaultPadding * 2),
            _buildUsageList(),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCards() {
    return Row(
      children: [
        Expanded(
          child: _buildSummaryCard(
            title: 'Total Economizado',
            value: 'R\$ ${_benefitUsage!.totalDiscount.toStringAsFixed(2)}',
            icon: Icons.savings,
            color: Colors.green,
          ),
        ),
        const SizedBox(width: defaultPadding),
        Expanded(
          child: _buildSummaryCard(
            title: 'Usos Totais',
            value: _benefitUsage!.totalUsed.toString(),
            icon: Icons.restaurant,
            color: Colors.blue,
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      color: Theme.of(context).cardColor,
      child: Padding(
        padding: const EdgeInsets.all(defaultPadding),
        child: Column(
          children: [
            Icon(
              icon,
              size: 32,
              color: color,
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChart() {
    if (_benefitUsage!.monthlyUsage.isEmpty) {
      return const SizedBox.shrink();
    }

    // Preparar dados para o gráfico
    final chartData = _benefitUsage!.monthlyUsage.map((monthly) {
      final totalDiscount = monthly.usages.fold<double>(
        0, (sum, usage) => sum + usage.discount);
      return FlSpot(
        _benefitUsage!.monthlyUsage.indexOf(monthly).toDouble(),
        totalDiscount,
      );
    }).toList();

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      color: Theme.of(context).cardColor,
      child: Padding(
        padding: const EdgeInsets.all(defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Economia Mensal',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: defaultPadding),
            SizedBox(
              height: 200,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: true,
                    horizontalInterval: 50,
                    verticalInterval: 1,
                    getDrawingHorizontalLine: (value) {
                      return FlLine(
                        color: Theme.of(context).dividerColor,
                        strokeWidth: 1,
                      );
                    },
                    getDrawingVerticalLine: (value) {
                      return FlLine(
                        color: Theme.of(context).dividerColor,
                        strokeWidth: 1,
                      );
                    },
                  ),
                  titlesData: FlTitlesData(
                    show: true,
                    rightTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 30,
                        interval: 1,
                        getTitlesWidget: (double value, TitleMeta meta) {
                          if (value.toInt() < _benefitUsage!.monthlyUsage.length) {
                            final month = _benefitUsage!.monthlyUsage[value.toInt()];
                            return Text(
                              month.monthYear.split(' ')[0],
                              style: Theme.of(context).textTheme.bodySmall,
                            );
                          }
                          return const Text('');
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: 50,
                        getTitlesWidget: (double value, TitleMeta meta) {
                          return Text(
                            'R\$ ${value.toInt()}',
                            style: Theme.of(context).textTheme.bodySmall,
                          );
                        },
                        reservedSize: 42,
                      ),
                    ),
                  ),
                  borderData: FlBorderData(
                    show: true,
                    border: Border.all(color: Theme.of(context).dividerColor),
                  ),
                  minX: 0,
                  maxX: (_benefitUsage!.monthlyUsage.length - 1).toDouble(),
                  minY: 0,
                  maxY: chartData.isNotEmpty 
                      ? chartData.map((e) => e.y).reduce((a, b) => a > b ? a : b) + 50
                      : 100,
                  lineBarsData: [
                    LineChartBarData(
                      spots: chartData,
                      isCurved: true,
                      gradient: LinearGradient(
                        colors: [
                          ThemeProvider.primaryColor.withOpacity(0.8),
                          ThemeProvider.primaryColor,
                        ],
                      ),
                      barWidth: 3,
                      isStrokeCapRound: true,
                      dotData: FlDotData(
                        show: true,
                        getDotPainter: (spot, percent, barData, index) {
                          return FlDotCirclePainter(
                            radius: 4,
                            color: ThemeProvider.primaryColor,
                            strokeWidth: 2,
                            strokeColor: Theme.of(context).cardColor,
                          );
                        },
                      ),
                      belowBarData: BarAreaData(
                        show: true,
                        gradient: LinearGradient(
                          colors: [
                            ThemeProvider.primaryColor.withOpacity(0.3),
                            ThemeProvider.primaryColor.withOpacity(0.1),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUsageList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Histórico Detalhado',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: defaultPadding),
        ..._benefitUsage!.monthlyUsage.map((monthly) => _buildMonthlySection(monthly)),
      ],
    );
  }

  Widget _buildMonthlySection(MonthlyUsage monthly) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      color: Theme.of(context).cardColor,
      margin: const EdgeInsets.only(bottom: defaultPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(defaultPadding),
            child: Row(
              children: [
                Icon(
                  Icons.calendar_today,
                  color: ThemeProvider.primaryColor,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  monthly.monthYear,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                Text(
                  '${monthly.usages.length} usos',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
          ...monthly.usages.map((usage) => _buildUsageItem(usage)),
        ],
      ),
    );
  }

  Widget _buildUsageItem(Usage usage) {
    final dateFormat = DateFormat('dd/MM/yyyy HH:mm');
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: defaultPadding, vertical: 4),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              usage.logoUrl,
              width: 50,
              height: 50,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 50,
                  height: 50,
                  color: Colors.grey[300],
                  child: Icon(
                    Icons.restaurant,
                    color: Colors.grey[600],
                  ),
                );
              },
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  usage.restaurantName,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  dateFormat.format(usage.usedAt),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      'R\$ ${usage.billAmountFull.toStringAsFixed(2)}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        decoration: TextDecoration.lineThrough,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'R\$ ${usage.billAmountDiscounted.toStringAsFixed(2)}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '-R\$ ${usage.discount.toStringAsFixed(2)}',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.green,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
} 