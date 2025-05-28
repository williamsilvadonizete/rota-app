import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rota_gourmet/components/buttons/custom_selectable_button.dart';
import '../../../components/price_range_and_food_type.dart';
import '../../../components/rating_with_counter.dart';
import '../../../constants.dart';

class RestaurantInfo extends StatefulWidget {
  const RestaurantInfo({super.key});

  @override
  State<RestaurantInfo> createState() => _RestaurantInfoState();
}

class _RestaurantInfoState extends State<RestaurantInfo> {
  int selectedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
      child: Container(
        decoration: BoxDecoration(
          color: primaryColorDark,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(defaultPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: defaultPadding + 10),
              Text(
                "Mac Feliz",
                style: Theme.of(context)
                    .textTheme
                    .headlineMedium!
                    .copyWith(color: labelColor),
                maxLines: 1,
              ),
              const SizedBox(height: defaultPadding / 2),
              const PriceRangeAndType(
                priceRange: "\$ 12-50",
                types: ["Hamburguer", "Pizza", "Sushi"],
                icons: [Icons.fastfood, Icons.local_pizza, Icons.rice_bowl],
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomSelectableButton(
                    icon: "assets/icons/couple.svg",
                    title: "Acompanhado",
                    subtitle: "100% OFF NO 2º prato",
                    isSelected: selectedIndex == 0,
                    onTap: () {
                      setState(() {
                        selectedIndex = 0;
                      });
                    },
                  ),
                  CustomSelectableButton(
                    icon: "assets/icons/single.svg",
                    title: "Individual",
                    subtitle: "30% OFF",
                    isSelected: selectedIndex == 1,
                    onTap: () {
                      setState(() {
                        selectedIndex = 1;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  CustomSelectableButton(
                    icon: "assets/icons/delivery_m.svg",
                    title: "Delivery",
                    subtitle: "20% OFF",
                    isSelected: selectedIndex == 2,
                    onTap: () {
                      setState(() {
                        selectedIndex = 2;
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 30),
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
            style: Theme.of(context)
                .textTheme
                .labelLarge!
                .copyWith(color: labelColor),
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