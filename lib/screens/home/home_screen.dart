import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:rota_gourmet/components/cards/big/restaurant_info.dart';
import 'package:rota_gourmet/components/custom_status_bar.dart';
import 'package:rota_gourmet/components/cards/big/big_card_image_slide.dart';
import 'package:rota_gourmet/components/section_title.dart';
import 'package:rota_gourmet/constants.dart';
import 'package:rota_gourmet/demo_data.dart';
import 'package:rota_gourmet/screens/details/details_screen.dart';
import 'package:rota_gourmet/screens/featured/featurred_screen.dart';
import 'package:rota_gourmet/screens/home/components/category_medium_card_list.dart';
import 'package:rota_gourmet/screens/home/components/medium_card_list.dart';
import 'package:rota_gourmet/services/category_service.dart';
import 'package:rota_gourmet/services/restaurant_service.dart';
import 'package:rota_gourmet/providers/theme_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final RestaurantService _restaurantService = RestaurantService();
  final CategoryService _categoryService = CategoryService();
  final ScrollController _scrollController = ScrollController();
  final List<dynamic> _restaurants = [];
  List<dynamic> _categories = [];
  int _currentPage = 1;
  bool _isLoading = false;
  bool _hasMore = true;
  static const int _pageSize = 20;

  // Adicionando estado para restaurantes da noite
  List<Map<String, dynamic>> _nightRestaurants = [];
  List<Map<String, dynamic>> _nowRestaurants = [];

  bool _isLoadingNight = false;
  bool _isLoadingNow = false;
  Position? _currentPosition;

  @override
  void initState() {
    super.initState();
    _loadInitialData();
    _scrollController.addListener(_onScroll);
  }

  Future<void> _loadInitialData() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.whileInUse ||
          permission == LocationPermission.always) {
        _currentPosition =
            await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
      }
    } catch (e) {
      debugPrint("Error getting location: $e");
    } finally {
      _currentPosition ??= Position(
          latitude: -18.921079,
          longitude: -48.288413,
          timestamp: DateTime.now(),
          accuracy: 0.0,
          altitude: 0.0,
          heading: 0.0,
          speed: 0.0,
          speedAccuracy: 0.0,
          altitudeAccuracy: 0.0,
          headingAccuracy: 0.0);
      
      _fetchRestaurants();
      _fetchCategories();
      _fetchNightRestaurants();
      _fetchNowRestaurants();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _fetchCategories() async {
    final categories = await _categoryService.getActiveCategories();
    if (categories != null && mounted) {
      setState(() {
        _categories = categories;
      });
    }
  }

  Future<void> _fetchRestaurants() async {
    if (_isLoading || !_hasMore || _currentPosition == null) return;

    if (!mounted) return;
    setState(() => _isLoading = true);

    try {
      final response = await _restaurantService.getNearbyRestaurants(
        latitude: _currentPosition!.latitude,
        longitude: _currentPosition!.longitude,
        page: _currentPage,
        pageSize: _pageSize,
      );

      if (!mounted) return;

      if (response != null && response['restaurants'] != null) {
        setState(() {
          _restaurants.addAll(response['restaurants']);
          _hasMore = _restaurants.length < response['total'];
          _currentPage++;
        });
      }
    } catch (e) {
      debugPrint('Error fetching restaurants: $e');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  // Novo método para buscar restaurantes para comer a noite
  Future<void> _fetchNightRestaurants() async {
    if (_currentPosition == null) return;
    setState(() => _isLoadingNight = true);

    try {
      // Dia da semana atual (1=Domingo, 2=Segunda, ..., 7=Sábado)
      final now = DateTime.now();
      final int today = now.weekday == 7 ? 1 : now.weekday; // API: 1=Domingo

      final response = await _restaurantService.getNearbyRestaurants(
        latitude: _currentPosition!.latitude,
        longitude: _currentPosition!.longitude,
        page: 1,
        pageSize: 10,
        workTimes: [4],
        workDays: [today],
      );
      if (response != null && response['restaurants'] != null) {
        setState(() {
          _nightRestaurants =
              (response['restaurants'] as List).map<Map<String, dynamic>>((r) {
            return {
              'image': r['wallpaperUrl'] ?? '',
              'name': r['restaurantName'] ?? '',
              'location': r['address'] ?? '',
              'deliveryTime': r['deliveryTime'] ?? 0,
              'rating': r['rating'] ?? 0.0,
              'id': r['id'],
            };
          }).toList();
        });
      }
    } catch (e) {
      debugPrint('Error fetching night restaurants: $e');
    } finally {
      if (mounted) setState(() => _isLoadingNight = false);
    }
  }

  Future<void> _fetchNowRestaurants() async {
    if (_currentPosition == null) return;
    setState(() => _isLoadingNow = true);
    try {
      // Dia da semana atual (1=Domingo, 2=Segunda, ..., 7=Sábado)
      final now = DateTime.now();
      final int today = now.weekday == 7 ? 1 : now.weekday; // API: 1=Domingo

      // Determinar período do dia para o filtro workTimes
      int hour = now.hour;
      int? workTime;
      if (hour >= 6 && hour < 12) {
        workTime = 1; // Manhã
      } else if (hour >= 12 && hour < 15) {
        workTime = 2; // Almoço
      } else if (hour >= 15 && hour < 18) {
        workTime = 3; // Tarde
      } else if (hour >= 18 && hour < 24) {
        workTime = 4; // Jantar
      }

      final response = await _restaurantService.getNearbyRestaurants(
        latitude: _currentPosition!.latitude,
        longitude: _currentPosition!.longitude,
        page: 1,
        pageSize: 10,
        workDays: [today],
        workTimes: workTime != null ? [workTime] : null,
      );
      if (response != null && response['restaurants'] != null) {
        setState(() {
          _nowRestaurants =
              (response['restaurants'] as List).map<Map<String, dynamic>>((r) {
            return {
              'image': r['wallpaperUrl'] ?? '',
              'name': r['restaurantName'] ?? '',
              'location': r['address'] ?? '',
              'deliveryTime': r['deliveryTime'] ?? 0,
              'rating': r['rating'] ?? 0.0,
              'id': r['id'],
            };
          }).toList();
        });
      }
    } catch (e) {
      debugPrint('Error fetching now restaurants: $e');
    } finally {
      if (mounted) setState(() => _isLoadingNow = false);
    }
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.8 &&
        !_isLoading) {
      _fetchRestaurants();
    }
  }

  Widget _buildLoadingIndicator() {
    return Padding(
      padding: const EdgeInsets.all(defaultPadding),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(
              color: ThemeProvider.primaryColor,
            ),
            const SizedBox(height: defaultPadding),
            Text(
              'Carregando mais restaurantes...',
              style: TextStyle(
                color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEndOfList() {
    return Padding(
      padding: const EdgeInsets.all(defaultPadding),
      child: Center(
        child: Text(
          'Não há mais restaurantes para carregar',
          style: TextStyle(
            color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.7),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: const CustomStatusAppBar(showBackButton: true),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {
            _restaurants.clear();
            _currentPage = 1;
            _hasMore = true;
          });
          await _loadInitialData();
        },
        child: SingleChildScrollView(
          controller: _scrollController,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
                child: BigCardImageSlide(images: demoBigImages),
              ),
              const SizedBox(height: 20),
              if (_categories.isNotEmpty) ...[
                CategoryMediumCardList(
                  title: "Categorias",
                  restaurants: _categories.map((category) {
                    return {
                      'id': category['id'],
                      'name': category['name'],
                      'image': category['imageUrl'],
                    };
                  }).toList(),
                ),
                const SizedBox(height: 20),
              ],
              MediumCardList(
                title: "Para comer agora",
                restaurants: _nowRestaurants,
                isLoading: _isLoadingNow,
              ),
              const SizedBox(height: 20),
              // MediumCardList dinâmico para comer a noite
              MediumCardList(
                title: "Para comer a noite",
                restaurants: _nightRestaurants,
                isLoading: _isLoadingNight,
              ),
              const SizedBox(height: 20),
              SectionTitle(
                title: "Restaurantes",
                press: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const FeaturedScreen(),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              ..._buildRestaurantCards(),
              if (_isLoading) _buildLoadingIndicator(),
              if (!_hasMore && _restaurants.isNotEmpty) _buildEndOfList(),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildRestaurantCards() {
    return _restaurants.map((restaurant) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(
            defaultPadding, 0, defaultPadding, defaultPadding),
        child: RestaurantCard(
          logoUrl: restaurant['logoUrl'] ?? '',
          name: restaurant['restaurantName'] ?? '',
          foodType: restaurant['categories']?.join(', ') ?? '',
          distance: '${restaurant['distanceKm']?.toStringAsFixed(1)} km',
          weekAvailability: _mapWorkDays(restaurant['workDays']),
          press: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DetailsScreen(
                  restaurantId: restaurant['id'],
                ),
              ),
            );
          },
        ),
      );
    }).toList();
  }

  List<DayAvailability> _mapWorkDays(List<dynamic>? workDays) {
    if (workDays == null) return [];
    
    return workDays.map((day) {
      return DayAvailability(
        dayLetter: day['acronymDay'] ?? '',
        available: day['available'] ?? false,
      );
    }).toList();
  }
}