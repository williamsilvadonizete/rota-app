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
import 'package:rota_gourmet/screens/home/components/medium_card_list.dart';
import 'package:rota_gourmet/services/restaurant_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final RestaurantService _restaurantService = RestaurantService();
  final ScrollController _scrollController = ScrollController();
  final List<dynamic> _restaurants = [];
  int _currentPage = 1;
  bool _isLoading = false;
  bool _hasMore = true;

  @override
  void initState() {
    super.initState();
    _fetchRestaurants();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _fetchRestaurants() async {
    if (_isLoading || !_hasMore) return;

    if (!mounted) return;
    setState(() => _isLoading = true);

    try {
      LocationPermission permission = await Geolocator.checkPermission();
      Position position =  Position(
                            latitude: -18.921079,
                            longitude: -48.288413,
                            timestamp: DateTime.now(),
                            accuracy: 0.0,
                            altitude: 0.0,
                            heading: 0.0,
                            speed: 0.0,
                            altitudeAccuracy: 0.0,
                            headingAccuracy: 0.0,
                            speedAccuracy: 0.0,
                          );
      if (permission == LocationPermission.whileInUse || 
           permission == LocationPermission.always) {
            position = await Geolocator.getCurrentPosition(
              desiredAccuracy: LocationAccuracy.best,
            );
      }
       
      final response = await _restaurantService.getNearbyRestaurants(
        latitude: position.latitude,
        longitude: position.longitude,
        page: _currentPage,
        pageSize: 20,
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

  void _onScroll() {
    if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent &&
        !_isLoading) {
      _fetchRestaurants();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: const CustomStatusAppBar(showBackButton: true),
      body: SafeArea(
        child: SingleChildScrollView(
          controller: _scrollController,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: defaultPadding),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
                child: BigCardImageSlide(images: demoBigImages),
              ),
              const SizedBox(height: defaultPadding * 2),
              SectionTitle(
                title: "Parceiros em Destaque",
                press: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const FeaturedScreen(),
                  ),
                ),
              ),
              const SizedBox(height: defaultPadding),
              const MediumCardList(
                title: "Categorias",
                restaurants: [
                  {
                    "image": "assets/images/pizza.png",
                    "name": "Pizza",
                  },
                  {
                    "image": "assets/images/stack.png",
                    "name": "Steakhouse",
                  },
                  {
                    "image": "assets/images/internacional.png",
                    "name": "Internacional",
                  },
                  {
                    "image": "assets/images/hamburguer.png",
                    "name": "Hamburguer",
                  },
                ],
              ),
              const SizedBox(height: 20),
              const MediumCardList(
                title: "Para comer agora",
                restaurants: [
                  {
                    "image": "assets/images/medium_3.png",
                    "name": "Pizza do Chef",
                    "location": "Av. Paulista, 123",
                    "deliveryTime": 30,
                    "rating": 4.8,
                  },
                  {
                    "image": "assets/images/medium_4.png",
                    "name": "Sushi House",
                    "location": "Rua das Flores, 456",
                    "deliveryTime": 20,
                    "rating": 4.5,
                  },
                ],
              ),
              const SizedBox(height: 20),
              const MediumCardList(
                title: "Para comer a noite",
                restaurants: [
                  {
                    "image": "assets/images/medium_1.png",
                    "name": "Pizza do Chef",
                    "location": "Av. Paulista, 123",
                    "deliveryTime": 30,
                    "rating": 4.8,
                  },
                  {
                    "image": "assets/images/medium_2.png",
                    "name": "Sushi House",
                    "location": "Rua das Flores, 456",
                    "deliveryTime": 20,
                    "rating": 4.5,
                  },
                ],
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
                  restaurant: {
                    'restaurantName': restaurant['restaurantName'] ?? '',
                    'categories': restaurant['categories'] ?? [],
                    'priceRange': restaurant['priceRange'] ?? '\$ 0-0',
                    'rating': restaurant['rating'] ?? 0.0,
                    'numOfRating': restaurant['numOfRating'] ?? 0,
                    'deliveryFee': restaurant['deliveryFee'] ?? 0,
                    'deliveryTime': restaurant['deliveryTime'] ?? 0,
                    'logoUrl': restaurant['logoUrl'] ?? '',
                    'backgroundImageUrl': restaurant['backgroundImageUrl'] ?? '',
                  },
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

  Widget _buildLoadingIndicator() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget _buildEndOfList() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Center(
        child: Text('Todos os restaurantes carregados'),
      ),
    );
  }
}