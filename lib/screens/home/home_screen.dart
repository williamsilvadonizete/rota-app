import 'package:flutter/material.dart';

import '../../components/cards/big/big_card_image_slide.dart';
import '../../components/cards/big/restaurant_info_big_card.dart';
import '../../components/section_title.dart';
import '../../constants.dart';
import '../../demo_data.dart';
import '../../screens/filter/filter_screen.dart';
import '../details/details_screen.dart';
import '../featured/featurred_screen.dart';
import 'components/medium_card_list.dart';
import 'components/promotion_banner.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColorDark,
      appBar: AppBar(
        leading: const SizedBox(),
        title: Column(
          children: [
            Text(
              "Delivery to".toUpperCase(),
              style: Theme.of(context)
                  .textTheme
                  .bodySmall!
                  .copyWith(color: primaryColor),
            ),
            const Text(
              "San Francisco",
              style: TextStyle(color: Colors.black),
            )
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const FilterScreen(),
                ),
              );
            },
            child: Text(
              "Filter",
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
        ],
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
                ]),
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
                ]),
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
                ]),
              // Banner
              // const PromotionBanner(),
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
              // const MediumCardList(),
              // const SizedBox(height: 20),
              // SectionTitle(title: "All Restaurants", press: () {}),
              // const SizedBox(height: 16),

              // Demo list of Big Cards
              ...List.generate(
                // For demo we use 4 items
                3,
                (index) => Padding(
                  padding: const EdgeInsets.fromLTRB(
                      defaultPadding, 0, defaultPadding, defaultPadding),
                  child: RestaurantInfoBigCard(
                    // Images are List<String>
                    images: demoBigImages..shuffle(),
                    name: "McDonald's",
                    rating: 4.3,
                    numOfRating: 200,
                    deliveryTime: 25,
                    range: "30-80",
                    foodType: const ["Chinese", "American", "Deshi food"],
                    press: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const DetailsScreen(),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
