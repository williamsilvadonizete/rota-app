import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rota_gourmet/providers/theme_provider.dart';

import '../../../components/cards/medium/restaurant_info_medium_card.dart';
import '../../../components/scalton/medium_card_scalton.dart';
import '../../../constants.dart';
import '../../details/details_screen.dart';

class MediumCardList extends StatelessWidget {
  final String title;
  final List<Map<String, dynamic>> restaurants;
  final bool isLoading;

  const MediumCardList({
    super.key,
    required this.title,
    required this.restaurants,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
          child: Text(
            title, // Usa o título passado como parâmetro
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: themeProvider.isDarkMode ? Colors.white : const Color(0xFF333333),
                ),
          ),
        ),
        const SizedBox(height: defaultPadding), // Espaço entre o título e a lista
        SizedBox(
          width: double.infinity,
          height: 240,
          child: isLoading
              ? buildFeaturedPartnersLoadingIndicator()
              : restaurants.isEmpty
                  ? const Center(child: Text("Nenhum restaurante encontrado."))
                  : ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: restaurants.length,
                      itemBuilder: (context, index) => Padding(
                        padding: EdgeInsets.only(
                          left: defaultPadding,
                          right: (restaurants.length - 1) == index
                              ? defaultPadding
                              : 0,
                        ),
                        child: RestaurantInfoMediumCard(
                          image: restaurants[index]['image'],
                          name: restaurants[index]['name'],
                          location: restaurants[index]['location'] ?? '',
                          delivertTime: restaurants[index]['deliveryTime'],
                          rating: restaurants[index]['rating']?.toDouble(),
                          press: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DetailsScreen(
                                  restaurantId: restaurants[index]['id'],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
        ),
      ],
    );
  }

  Widget buildFeaturedPartnersLoadingIndicator() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(
          2,
          (index) => const Padding(
            padding: EdgeInsets.only(left: defaultPadding),
            child: MediumCardScalton(),
          ),
        ),
      ),
    );
  }
}
