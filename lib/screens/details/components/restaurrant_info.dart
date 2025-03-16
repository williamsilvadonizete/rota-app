import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../components/price_range_and_food_type.dart';
import '../../../components/rating_with_counter.dart';
import '../../../constants.dart';

class RestaurantInfo extends StatelessWidget {
  const RestaurantInfo({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
      child: Container(
        decoration: BoxDecoration(
          color: primaryColorDark, // Cor de fundo alterada para azul
          borderRadius: BorderRadius.circular(12), // Adicionando borda arredondada
        ),
        child: Padding(
          padding: const EdgeInsets.all(defaultPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Mac Feliz",
                style: Theme.of(context).textTheme.headlineMedium!.copyWith(color: labelColor),
                maxLines: 1,
              ),
              const SizedBox(height: defaultPadding / 2),
              const PriceRangeAndFoodtype(
                foodType: ["Hamburguer", "Sanduba", "Batata"],
                priceRange: "\$ 12-50",
              ),
              const SizedBox(height: defaultPadding / 2),
              const RatingWithCounter(rating: 4.3, numOfRating: 200),
              const SizedBox(height: defaultPadding),
              Row(
                children: [
                  const DeliveryInfo(
                    iconSrc: "assets/icons/delivery.svg",
                    text: "Free",
                    subText: "Delivery",
                  ),
                  const SizedBox(width: defaultPadding),
                  const DeliveryInfo(
                    iconSrc: "assets/icons/clock.svg",
                    text: "25",
                    subText: "Minutes",
                  ),
                  const Spacer(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DeliveryInfo extends StatelessWidget {
  const DeliveryInfo({
    super.key,
    required this.iconSrc,
    required this.text,
    required this.subText,
  });

  final String iconSrc, text, subText;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SvgPicture.asset(
          iconSrc,
          height: 20,
          width: 20,
          colorFilter: const ColorFilter.mode(
            primaryColor,
            BlendMode.srcIn,
          ),
        ),
        const SizedBox(width: 8),
        Text.rich(
          TextSpan(
            text: "$text\n",
            style: Theme.of(context).textTheme.labelLarge!.copyWith(color: labelColor),
            children: [
              TextSpan(
                text: subText,
                style: Theme.of(context)
                    .textTheme
                    .labelSmall!
                    .copyWith(fontWeight: FontWeight.normal, color: labelColor),
              )
            ],
          ),
        ),
      ],
    );
  }
}
