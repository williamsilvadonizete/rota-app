import 'package:flutter/material.dart';
import '../../../components/cards/iteam_card.dart';
import '../../../constants.dart';
import '../../addToOrder/add_to_order_screen.dart';

class Items extends StatefulWidget {
  final Map<String, dynamic> restaurantInfo;
  const Items({super.key, required this.restaurantInfo});

  @override
  State<Items> createState() => _ItemsState();
}

class _ItemsState extends State<Items> {
  int _selectedTabIndex = 0;
  
  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final info = widget.restaurantInfo;
    final rules = info['rules'] as List<dynamic>?;
    final rulesCount = rules?.length ?? 0;
    
    return DefaultTabController(
      length: 3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TabBar(
            isScrollable: true,
            labelColor: primaryColor,
            unselectedLabelColor: isDarkMode ? Colors.white70 : titleColor,
            labelStyle: Theme.of(context).textTheme.titleLarge!.copyWith(
              fontWeight: FontWeight.bold,
            ),
            tabs: [
              // const Tab(child: Text('Cardápio')),
              const Tab(child: Text('Informações')),
              Tab(child: Text('Regras${rulesCount > 0 ? ' ($rulesCount)' : ''}')),
            ],
          ),
          SizedBox(
            height: 420, // ajuste conforme necessário
            child: TabBarView(
              children: [
                SingleChildScrollView(
                  padding: const EdgeInsets.all(defaultPadding),
                  child: _buildInfoTab(context, info),
                ),
                SingleChildScrollView(
                  padding: const EdgeInsets.all(defaultPadding),
                  child: (rules == null || rules.isEmpty)
                      ? const Text('Nenhuma regra cadastrada.')
                      : Column(
                          children: [
                            ...rules.map<Widget>((rule) => Card(
                                  elevation: 1,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                  child: Padding(
                                    padding: const EdgeInsets.all(16),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Icon(Icons.rule, size: 24),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Text(
                                            rule['description'] ?? '',
                                            style: Theme.of(context).textTheme.bodyLarge,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ))
                          ],
                        ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 80),
        ],
      ),
    );
  }

  Widget _buildInfoTab(BuildContext context, Map<String, dynamic> info) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          info['fantasyName'] ?? info['restaurantName'] ?? '',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: isDarkMode ? Colors.white : const Color(0xFF333333),
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 12),
        if (info['categories'] != null)
          Wrap(
            spacing: 8,
            children: (info['categories'] as List<dynamic>?)?.map((c) {
              final name = c is Map && c['name'] != null ? c['name'].toString() : c.toString();
              return Chip(
                label: Text(name),
                backgroundColor: isDarkMode ? Colors.grey[800] : Colors.grey[200],
              );
            }).toList() ?? [],
          ),
        if (info['address'] != null) ...[
          const SizedBox(height: 16),
          Row(
            children: [
              const Icon(Icons.location_on, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  '${info['address']['street'] ?? ''}, ${info['address']['number'] ?? ''} - ${info['address']['neighborhood'] ?? ''}\n${info['address']['cityName'] ?? ''} - ${info['address']['stateName'] ?? ''}\nCEP: ${info['address']['zipCode'] ?? ''}',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: isDarkMode ? Colors.white70 : Colors.black54,
                      ),
                ),
              ),
            ],
          ),
        ],
        if (info['phone'] != null || info['website'] != null || info['instagram'] != null) ...[
          const SizedBox(height: 16),
          if (info['phone'] != null) ...[
            Row(
              children: [
                const Icon(Icons.phone, size: 20),
                const SizedBox(width: 8),
                Flexible(child: Text(info['phone'].toString())),
              ],
            ),
            const SizedBox(height: 8),
          ],
          if (info['website'] != null) ...[
            Row(
              children: [
                const Icon(Icons.language, size: 20),
                const SizedBox(width: 8),
                Flexible(child: Text(info['website'].toString(), overflow: TextOverflow.ellipsis)),
              ],
            ),
            const SizedBox(height: 8),
          ],
          if (info['instagram'] != null) ...[
            Row(
              children: [
                const Icon(Icons.camera_alt, size: 20),
                const SizedBox(width: 8),
                Flexible(child: Text('@${info['instagram']}', overflow: TextOverflow.ellipsis)),
              ],
            ),
          ],
        ],
        if (info['tags'] != null && (info['tags'] as List).isNotEmpty) ...[
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            children: (info['tags'] as List).map((tag) {
              final name = tag['name'] ?? '';
              final icon = tag['icon'] ?? null;
              return Chip(
                avatar: icon != null ? Icon(Icons.circle, size: 16) : null,
                label: Text(name),
                backgroundColor: isDarkMode ? Colors.grey[900] : Colors.grey[100],
              );
            }).toList(),
          ),
        ],
        if (info['works'] != null && (info['works'] as List).isNotEmpty) ...[
          const SizedBox(height: 16),
          Text('Horários de Funcionamento:', style: Theme.of(context).textTheme.titleMedium),
          ...((info['works'] as List).map((work) {
            final dayId = work['dayId'];
            final enabled = work['enabled'] == true;
            final periods = work['periods'] as List?;
            final dayNames = ['Seg', 'Ter', 'Qua', 'Qui', 'Sex', 'Sab', 'Dom'];
            final dayName = (dayId is int && dayId >= 1 && dayId <= 7) ? dayNames[dayId - 1] : 'Dia';
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: Row(
                children: [
                  Text('$dayName:', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(width: 8),
                  if (!enabled) Text('Fechado', style: TextStyle(color: Colors.red)),
                  if (enabled && periods != null)
                    ...periods.where((p) => p['enabled'] == true).map((p) {
                      final start = p['start']?.toString().padLeft(2, '0') ?? '--';
                      final end = p['end']?.toString().padLeft(2, '0') ?? '--';
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: Text('$start:00 às $end:00'),
                      );
                    }),
                ],
              ),
            );
          })),
        ],
      ],
    );
  }
}

final List<Tab> demoTabs = <Tab>[
  const Tab(
    child: Text('Cardápio'),
  ),
  const Tab(
    child: Text('Informações'),
  ),
];

final List<Map<String, dynamic>> demoData = List.generate(
  3,
  (index) => {
    "image": "assets/images/featured _items_${index + 1}.png",
    "title": "Cookie Sandwich",
    "description": "Shortbread, chocolate turtle cookies, and red velvet.",
    "price": 7.4,
    "foodType": "Chinese",
    "priceRange": "\$" * 2,
  },
);

// Widget inline para evitar dependências externas
class _CustomSelectableButton extends StatelessWidget {
  final String icon;
  final String title;
  final String subtitle;
  final bool isSelected;
  final bool isDisabled;
  final VoidCallback onTap;

  const _CustomSelectableButton({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.isSelected,
    required this.isDisabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: isDisabled ? null : onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? Theme.of(context).colorScheme.primary.withOpacity(0.12)
              : (isDarkMode ? Colors.grey[900] : Colors.grey[200]),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? Theme.of(context).colorScheme.primary
                : Colors.transparent,
            width: 2,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(icon, height: 32, color: isDisabled ? Colors.grey : null),
            const SizedBox(height: 8),
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: isDisabled
                        ? Colors.grey
                        : (isSelected
                            ? Theme.of(context).colorScheme.primary
                            : (isDarkMode ? Colors.white : Colors.black)),
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: isDisabled ? Colors.grey : Colors.black54,
                  ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
