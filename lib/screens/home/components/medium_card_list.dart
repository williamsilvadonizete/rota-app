import 'package:flutter/material.dart';

import '../../../components/cards/medium/restaurant_info_medium_card.dart';
import '../../../components/scalton/medium_card_scalton.dart';
import '../../../constants.dart';
import '../../details/details_screen.dart';

class MediumCardList extends StatefulWidget {
  final String title; // Título dinâmico
  final List<Map<String, dynamic>> restaurants; // Lista de restaurantes dinâmica

  const MediumCardList({
    super.key,
    required this.title,
    required this.restaurants,
  });

  @override
  State<MediumCardList> createState() => _MediumCardListState();
}

class _MediumCardListState extends State<MediumCardList> {
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
          child: Text(
            widget.title, // Usa o título passado como parâmetro
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: const Color.fromARGB(228, 245, 143, 26),
                ),
          ),
        ),
        const SizedBox(height: defaultPadding), // Espaço entre o título e a lista
        SizedBox(
          width: double.infinity,
          height: 254,
          child: isLoading
              ? buildFeaturedPartnersLoadingIndicator()
              : ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: widget.restaurants.length,
                  itemBuilder: (context, index) => Padding(
                    padding: EdgeInsets.only(
                      left: defaultPadding,
                      right: (widget.restaurants.length - 1) == index
                          ? defaultPadding
                          : 0,
                    ),
                    child: RestaurantInfoMediumCard(
                      image: widget.restaurants[index]['image'],
                      name: widget.restaurants[index]['name'],
                      location: widget.restaurants[index]['location'] ?? '',
                      delivertTime: widget.restaurants[index]['deliveryTime'] ?? 0,
                      rating: widget.restaurants[index]['rating'] ?? 0.0,
                      press: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const DetailsScreen(),
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

  SingleChildScrollView buildFeaturedPartnersLoadingIndicator() {
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
