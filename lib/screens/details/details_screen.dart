import 'package:flutter/material.dart';
import 'package:rota_gourmet/components/restaurant_bar.dart';
import 'package:rota_gourmet/constants.dart';
import 'components/iteams.dart';
import '../../../services/restaurant_service.dart';
import 'package:rota_gourmet/components/buttons/custom_selectable_button.dart';

class DetailsScreen extends StatefulWidget {
  final int restaurantId;
  const DetailsScreen({super.key, required this.restaurantId});

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  Map<String, dynamic>? _restaurantInfo;
  bool _isLoading = true;
  int _selectedIndex = 0; // 0 = Acompanhado, 1 = Individual

  @override
  void initState() {
    super.initState();
    _fetchRestaurantInfo();
  }

  Future<void> _fetchRestaurantInfo() async {
    final service = RestaurantService();
    final info = await service.getRestaurantInfo(widget.restaurantId);
    setState(() {
      _restaurantInfo = info;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      extendBodyBehindAppBar: true,
      appBar: RestaurantBar(
        showBackButton: true,
        title: _restaurantInfo?['fantasyName'] ?? '',
        logoUrl: _restaurantInfo?['logoUrl'] ?? '',
        backgroundImageUrl: _restaurantInfo?['wallpaperUrl'] ?? '',
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 300),
                  if (_restaurantInfo != null) ...[
                    Center(
                      child: Text(
                        _restaurantInfo!["fantasyName"] ?? '',
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: isDarkMode ? Colors.white : const Color(0xFF333333),
                            ),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomSelectableButton(
                          icon: "assets/icons/couple.svg",
                          title: "Acompanhado",
                          subtitle: "100% OFF NO 2º prato",
                          isSelected: _selectedIndex == 0,
                          isDisabled: false,
                          onTap: () {
                            setState(() {
                              _selectedIndex = 0;
                            });
                          },
                        ),
                        const SizedBox(width: 24),
                        Stack(
                          clipBehavior: Clip.none,
                          children: [
                          
                            CustomSelectableButton(
                              icon: "assets/icons/single.svg",
                              title: "Individual",
                              subtitle: "30% OFF",
                              isSelected: _selectedIndex == 1,
                              isDisabled: true,
                              onTap: () {},
                            ),
                            Positioned(
                              top: 4,
                              right: 4,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.primary,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  "Em Breve",
                                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  if (_restaurantInfo != null)
                    Items(restaurantInfo: _restaurantInfo!),
                  if (_restaurantInfo == null)
                    const Center(child: Text('Restaurante não encontrado.')),
                ],
              ),
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
            crossAxisAlignment: CrossAxisAlignment.start,
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
        if (info['phone'] != null) ...[
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.phone, size: 20),
              const SizedBox(width: 8),
              Flexible(child: Text(info['phone'].toString())),
            ],
          ),
        ],
        if (info['website'] != null) ...[
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.language, size: 20),
              const SizedBox(width: 8),
              Flexible(child: Text(info['website'].toString(), overflow: TextOverflow.ellipsis)),
            ],
          ),
        ],
        if (info['instagram'] != null) ...[
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.camera_alt, size: 20),
              const SizedBox(width: 8),
              Flexible(child: Text('@${info['instagram']}', overflow: TextOverflow.ellipsis)),
            ],
          ),
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
