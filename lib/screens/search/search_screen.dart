import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:rota_gourmet/components/cards/big/restaurant_info.dart';
import 'package:rota_gourmet/screens/details/details_screen.dart';
import 'package:rota_gourmet/screens/filter/filter_screen.dart';
import 'package:rota_gourmet/services/restaurant_service.dart';
import '../../components/scalton/big_card_scalton.dart';
import '../../constants.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  bool _showSearchResult = false;
  bool _isLoading = false;
  final RestaurantService _restaurantService = RestaurantService();
  final List<dynamic> _restaurants = [];
  String _selectedCategory = '';
  
  // Temporary fixed categories - will be fetched from API in the future
  final List<Map<String, String>> _categories = [
    {'name': 'Pizza', 'icon': '🍕'},
    {'name': 'Hambúrguer', 'icon': '🍔'},
    {'name': 'Sushi', 'icon': '🍣'},
    {'name': 'Brasileira', 'icon': '🥘'},
    {'name': 'Italiana', 'icon': '🍝'},
    {'name': 'Japonesa', 'icon': '🍱'},
    {'name': 'Chinesa', 'icon': '🥢'},
    {'name': 'Mexicana', 'icon': '🌮'},
  ];

  @override
  void initState() {
    super.initState();
    _fetchRestaurants();
  }

  Future<void> _fetchRestaurants() async {
    if (_isLoading) return;

    setState(() => _isLoading = true);

    try {
      LocationPermission permission = await Geolocator.checkPermission();
      Position position = Position(
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
        page: 1,
        pageSize: 20,
      );

      if (response != null && response['restaurants'] != null) {
        setState(() {
          _restaurants.clear();
          _restaurants.addAll(response['restaurants']);
          _showSearchResult = true;
        });
      }
    } catch (e) {
      debugPrint('Error fetching restaurants: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColorDark,
      appBar: AppBar(
        backgroundColor: primaryColorDark,
        title: const Text(
          "Encontre restaurantes",
          style: TextStyle(
            color: primaryColor,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            color: primaryColor,
            onPressed: _showFilterModal,
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: defaultPadding),
              const SearchForm(),
              const SizedBox(height: defaultPadding),
              Text(
                "Categorias",
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: titleColor,
                    ),
              ),
              const SizedBox(height: defaultPadding),
              SizedBox(
                height: 40,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _categories.length,
                  itemBuilder: (context, index) {
                    final category = _categories[index];
                    final isSelected = _selectedCategory == category['name'];
                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: ChoiceChip(
                        label: Text('${category['icon']} ${category['name']}'),
                        selected: isSelected,
                        onSelected: (selected) {
                          setState(() {
                            _selectedCategory = selected ? category['name']! : '';
                          });
                          if (selected) {
                            _fetchRestaurants();
                          }
                        },
                        backgroundColor: Colors.grey[800],
                        selectedColor: primaryColor,
                        labelStyle: TextStyle(
                          color: isSelected ? Colors.white : Colors.grey[300],
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: defaultPadding),
              Text(
                _showSearchResult ? "Resultados" : "Top Restaurantes",
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: titleColor,
                    ),
              ),
              const SizedBox(height: defaultPadding),
              Expanded(
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : ListView.builder(
                        itemCount: _restaurants.length,
                        itemBuilder: (context, index) {
                          final restaurant = _restaurants[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: defaultPadding),
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
                                    builder: (context) => const DetailsScreen(),
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
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

  void _showFilterModal() {
    showModalBottomSheet(
      context: context,
      backgroundColor: primaryColorDark,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      isScrollControlled: true,
      builder: (context) {
        return FractionallySizedBox(
          heightFactor: 0.8,
          child: const FilterScreen(),
        );
      },
    );
  }
}

class SearchForm extends StatefulWidget {
  const SearchForm({super.key});

  @override
  State<SearchForm> createState() => _SearchFormState();
}

class _SearchFormState extends State<SearchForm> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: TextFormField(
        onChanged: (value) {
          // Obter dados enquanto digita
        },
        onFieldSubmitted: (value) {
          if (_formKey.currentState!.validate()) {
            // Se os dados estiverem corretos, salve os dados
            _formKey.currentState!.save();
          } else {
            // Caso haja erro na validação
          }
        },
        validator: requiredValidator.call,
        style: Theme.of(context).textTheme.labelLarge,
        textInputAction: TextInputAction.search,
        decoration: InputDecoration(
          hintText: "Buscar Restaurantes",
          contentPadding: kTextFieldPadding,
          prefixIcon: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SvgPicture.asset(
              'assets/icons/search.svg',
              colorFilter: const ColorFilter.mode(
                bodyTextColor,
                BlendMode.srcIn,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
