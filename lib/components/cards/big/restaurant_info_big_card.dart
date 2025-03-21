import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rota_app/components/week_days_and_delivery.dart';

import '../../../constants.dart';
import '../../price_range_and_food_type.dart';
import '../../rating_with_counter.dart';
import '../../small_dot.dart';
import 'big_card_image_slide.dart';

class RestaurantInfoBigCard extends StatelessWidget {
  final List<String> images, foodType;
  final String name;
  final double rating;
  final int numOfRating, deliveryTime;
  final bool isFreeDelivery;
  final VoidCallback press;
  final String range;

  const RestaurantInfoBigCard({
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
          // pass list of images here
          BigCardImageSlide(images: images),
          const SizedBox(height: defaultPadding / 2),
          Text(name, style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: labelColor,
                ),    ),
          const SizedBox(height: defaultPadding / 4),
          const PriceRangeAndType(
                priceRange: "\$ 12-50",
                types: ["Hamburguer", "Pizza", "Sushi"],
                icons: [Icons.fastfood, Icons.local_pizza, Icons.rice_bowl],
              ),
          const SizedBox(height: defaultPadding / 4),
          Row(
            children: [
              RatingWithCounter(rating: rating, numOfRating: numOfRating),
              const SizedBox(width: defaultPadding / 2),
              SvgPicture.asset(
                "assets/icons/clock.svg",
                height: 20,
                width: 20,
                colorFilter: ColorFilter.mode(
                  primaryColor,// Cor branca com opacidade de 50%
                  BlendMode.srcIn,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                "$deliveryTime Min",
                style: Theme.of(context).textTheme.labelSmall!.copyWith(color: titleColor.withOpacity(0.74)),
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
                  primaryColor, // Cor branca com opacidade de 50%
                  BlendMode.srcIn,
                ),
              ),
              const SizedBox(width: 8),
              Text(isFreeDelivery ? "Entrega Grátis" : "Entrega será cobrada",
                  style: Theme.of(context).textTheme.labelSmall!.copyWith(color: titleColor.withOpacity(0.74))),
            ],
          ),
          WeekDaysAndDelivery(
            weekDays: ["Seg", "Qui", "Sex"],
          ),
        ],
      ),
    );
  }
}
