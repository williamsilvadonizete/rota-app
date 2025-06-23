import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:rota_gourmet/components/cards/big/restaurant_info.dart';
import 'package:rota_gourmet/providers/theme_provider.dart';
import 'package:rota_gourmet/screens/details/details_screen.dart';
import 'package:rota_gourmet/screens/filter/filter_screen.dart';
import 'package:rota_gourmet/services/category_service.dart';
import 'package:rota_gourmet/services/restaurant_service.dart';
import '../../components/scalton/big_card_scalton.dart';
import '../../constants.dart';

class SearchScreen extends StatefulWidget {
  final String? initialCategory;
  final int? initialCategoryId;
  const SearchScreen({super.key, this.initialCategory, this.initialCategoryId});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  bool _showSearchResult = false;
  bool _isLoading = false;
  final RestaurantService _restaurantService = RestaurantService();
  final CategoryService _categoryService = CategoryService();
  final List<dynamic> _restaurants = [];
  String _selectedCategory = '';
  int? _selectedCategoryId;
  List<dynamic> _categories = [];
  

  @override
  void initState() {
    super.initState();
    if (widget.initialCategory != null) {
      _selectedCategory = widget.initialCategory!;
    }
    if (widget.initialCategoryId != null) {
      _selectedCategoryId = widget.initialCategoryId;
    }
    _fetchRestaurants();
    _fetchCategories();
  }

  Future<void> _fetchCategories() async {
    try {
      final categories = await _categoryService.getActiveCategories();
      if (categories != null && mounted) {
        // Reorder if an initial category is provided
        if (widget.initialCategory != null) {
          final selectedCategoryIndex =
              categories.indexWhere((c) => c['name'] == widget.initialCategory);

          if (selectedCategoryIndex != -1) {
            final selectedCategory = categories.removeAt(selectedCategoryIndex);
            categories.insert(0, selectedCategory);
          }
        }

        setState(() {
          _categories = categories;
        });
      }
    } catch (e) {
      debugPrint('Error fetching categories: $e');
    }
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
        categoryIds: _selectedCategoryId != null ? [_selectedCategoryId!] : null,
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
    final themeProvider = Provider.of<ThemeProvider>(context);
    final backgroundColor = themeProvider.isDarkMode 
        ? primaryColorDark 
        : const Color(0xFFF5F5DC);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        title: Text(
          "Encontre restaurantes",
          style: TextStyle(
            color: themeProvider.isDarkMode ? ThemeProvider.primaryColor : const Color(0xFF333333),
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.filter_list,
              color: themeProvider.isDarkMode ? ThemeProvider.primaryColor : const Color(0xFF333333),
            ),
            onPressed: _showFilterModal,
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(defaultPadding),
              child: const SearchForm(),
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: themeProvider.isDarkMode ? const Color(0xFF1A1A1A) : Colors.white,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(defaultPadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Categorias",
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: themeProvider.isDarkMode ? Colors.white : const Color(0xFF333333),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: defaultPadding),
                      SizedBox(
                        height: 45,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: _categories.length,
                          itemBuilder: (context, index) {
                            final category = _categories[index];
                            final isSelected = _selectedCategory == category['name'];
                            return Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: ChoiceChip(
                                label: Text(
                                  category['name'],
                                  style: TextStyle(
                                    color: isSelected
                                        ? Colors.black54
                                        : (themeProvider.isDarkMode
                                            ? Colors.grey[300]
                                            : const Color(0xFF666666)),
                                    fontWeight: isSelected
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                  ),
                                ),
                                selected: isSelected,
                                onSelected: (selected) {
                                  setState(() {
                                    if (selected) {
                                      _selectedCategory = category['name']!;
                                      _selectedCategoryId = category['id'];
                                    } else {
                                      _selectedCategory = '';
                                      _selectedCategoryId = null;
                                    }
                                  });
                                  if (selected) {
                                    _fetchRestaurants();
                                  }
                                },
                                backgroundColor: themeProvider.isDarkMode ? Colors.grey[800] : Colors.grey[200],
                                selectedColor: ThemeProvider.primaryColor,
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: defaultPadding * 1.5),
                      Text(
                        _showSearchResult ? "Resultados" : "Top Restaurantes",
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: themeProvider.isDarkMode ? Colors.white : const Color(0xFF333333),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: defaultPadding),
                      Expanded(
                        child: _isLoading
                            ? Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    CircularProgressIndicator(
                                      color: ThemeProvider.primaryColor,
                                    ),
                                    const SizedBox(height: defaultPadding),
                                    Text(
                                      'Carregando restaurantes...',
                                      style: TextStyle(
                                        color: themeProvider.isDarkMode ? Colors.white70 : const Color(0xFF666666),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : _restaurants.isEmpty
                                ? Center(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.search_off_rounded,
                                          size: 64,
                                          color: themeProvider.isDarkMode ? Colors.white70 : const Color(0xFF666666),
                                        ),
                                        const SizedBox(height: defaultPadding),
                                        Text(
                                          'Nenhum restaurante encontrado',
                                          style: TextStyle(
                                            color: themeProvider.isDarkMode ? Colors.white70 : const Color(0xFF666666),
                                            fontSize: 16,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
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
                                    },
                                  ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
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
      backgroundColor: Colors.transparent,
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
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    
    return Form(
      key: _formKey,
      child: Container(
        decoration: BoxDecoration(
          color: themeProvider.isDarkMode ? const Color(0xFF1A1A1A) : Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: TextFormField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: 'Buscar restaurantes...',
            prefixIcon: Icon(
              Icons.search,
              color: themeProvider.isDarkMode ? Colors.grey[400] : Colors.grey[600],
            ),
            suffixIcon: _searchController.text.isNotEmpty
                ? IconButton(
                    icon: Icon(
                      Icons.clear,
                      color: themeProvider.isDarkMode ? Colors.grey[400] : Colors.grey[600],
                    ),
                    onPressed: () {
                      _searchController.clear();
                      setState(() {});
                    },
                  )
                : null,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide.none,
            ),
            filled: true,
            fillColor: themeProvider.isDarkMode ? const Color(0xFF1A1A1A) : Colors.white,
            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          ),
          style: TextStyle(
            color: themeProvider.isDarkMode ? Colors.white : const Color(0xFF333333),
          ),
          onChanged: (value) {
            setState(() {});
          },
          onFieldSubmitted: (value) {
            if (_formKey.currentState!.validate()) {
              // Implement search functionality
            }
          },
        ),
      ),
    );
  }
}
