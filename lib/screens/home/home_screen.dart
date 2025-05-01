import 'package:flutter/material.dart';
import 'package:rota_app/components/cards/big/restaurant_info.dart';
import 'package:rota_app/components/custom_status_bar.dart';
import 'package:rota_app/components/cards/big/big_card_image_slide.dart';
import 'package:rota_app/components/cards/big/restaurant_info_simple_card.dart';
import 'package:rota_app/components/section_title.dart';
import 'package:rota_app/constants.dart';
import 'package:rota_app/demo_data.dart';
import 'package:rota_app/screens/details/details_screen.dart';
import 'package:rota_app/screens/featured/featurred_screen.dart';
import 'package:rota_app/screens/home/components/medium_card_list.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColorDark,
      appBar: const CustomStatusAppBar(
        showBackButton: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
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
              ...List.generate(
                3,
                (index) => Padding(
                  padding: const EdgeInsets.fromLTRB(
                      defaultPadding, 0, defaultPadding, defaultPadding),
                  child: RestaurantCard(
                          logoUrl: 'https://ciclogestaoderesiduos.com.br/wp-content/uploads/2018/10/kisspng-fast-food-mcdonald-s-logo-golden-arches-restaurant-mcdonalds-5ac3bf23df0da8.6342440115227778919136.jpg',
                          name: 'Mac',
                          foodType: 'Fast Food',
                          distance: '20 km',
                          weekAvailability: [
                            DayAvailability(dayLetter: 'S', available: false),
                            DayAvailability(dayLetter: 'T', available: false),
                            DayAvailability(dayLetter: 'Q', available: true),
                            DayAvailability(dayLetter: 'Q', available: true),
                            DayAvailability(dayLetter: 'S', available: true),
                            DayAvailability(dayLetter: 'S', available: true),
                            DayAvailability(dayLetter: 'D', available: true),
                          ],
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
            ],
          ),
        ),
      ),
    );
  }
}
