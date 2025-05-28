import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rota_gourmet/components/week_days_and_delivery.dart';

import '../../../constants.dart';
import '../../price_range_and_food_type.dart';
import '../../small_dot.dart';

class RestaurantInfoSimpleCard extends StatelessWidget {
  final List<String> images, foodType;
  final String name;
  final double rating;
  final int numOfRating, deliveryTime;
  final bool isFreeDelivery;
  final VoidCallback press;
  final String range;

  const RestaurantInfoSimpleCard({
    super.key,
    required this.name,
    required this.rating,
    required this.numOfRating,
    required this.deliveryTime,
    this.isFreeDelivery = true,
    required this.images,
    required this.foodType,
    required this.press,
    required this.range,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: press,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: defaultPadding / 2),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Logo arredondado do restaurante
              ClipRRect(
                borderRadius: BorderRadius.circular(40), // Deixa a imagem arredondada
                child: Image.network(
                  images.isNotEmpty ? images[0] : '', // Exibe a primeira imagem da lista
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    width: 60,
                    height: 60,
                    color: Colors.grey,
                    child: Icon(Icons.image_not_supported, color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(width: defaultPadding),
              // Informações ao lado do logo
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: labelColor,
                          ),
                    ),
                    const SizedBox(height: defaultPadding / 4),
                    PriceRangeAndType(
                      priceRange: range,
                      types: foodType,
                      icons: [Icons.fastfood, Icons.local_pizza], // Você pode melhorar isso se quiser
                    ),
                    const SizedBox(height: defaultPadding / 4),
                    Row(
                      children: [
                        // RatingWithCounter(rating: rating, numOfRating: numOfRating),
                        const SizedBox(width: defaultPadding / 2),
                        SvgPicture.asset(
                          "assets/icons/clock.svg",
                          height: 20,
                          width: 20,
                          colorFilter: ColorFilter.mode(
                            primaryColor,
                            BlendMode.srcIn,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          "$deliveryTime Min",
                          style: Theme.of(context)
                              .textTheme
                              .labelSmall!
                              .copyWith(color: titleColor.withOpacity(0.74)),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: defaultPadding / 2),
                          child: SmallDot(),
                        ),
                        SvgPicture.asset(
                          "assets/icons/delivery_m.svg",
                          height: 20,
                          width: 20,
                          colorFilter: ColorFilter.mode(
                            primaryColor,
                            BlendMode.srcIn,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          isFreeDelivery ? "Entrega Grátis" : "Entrega será cobrada",
                          style: Theme.of(context)
                              .textTheme
                              .labelSmall!
                              .copyWith(color: titleColor.withOpacity(0.74)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: defaultPadding / 2),
          WeekDaysAndDelivery(
            weekDays: ["Seg", "Qui", "Sex"],
          ),
        ],
      ),
    );
  }
}
