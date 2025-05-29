import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rota_gourmet/components/buttons/custom_selectable_button.dart';
import '../../../components/price_range_and_food_type.dart';
import '../../../components/rating_with_counter.dart';
import '../../../constants.dart';

class RestaurantInfo extends StatefulWidget {
  final Map<String, dynamic> restaurant;

  const RestaurantInfo({
    super.key,
    required this.restaurant,
  });

  @override
  State<RestaurantInfo> createState() => _RestaurantInfoState();
}

class _RestaurantInfoState extends State<RestaurantInfo> {
  int selectedIndex = -1;

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(defaultPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: defaultPadding + 10),
              Text(
                widget.restaurant['restaurantName'] ?? '',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: isDarkMode ? Colors.white : const Color(0xFF333333),
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 1,
              ),
              const SizedBox(height: defaultPadding / 2),
              PriceRangeAndType(
                priceRange: widget.restaurant['priceRange'] ?? '\$ 0-0',
                types: (widget.restaurant['categories'] as List<dynamic>?)?.cast<String>() ?? [],
                icons: const [Icons.fastfood, Icons.local_pizza, Icons.rice_bowl],
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: CustomSelectableButton(
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
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Stack(
                      children: [
                        CustomSelectableButton(
                          icon: "assets/icons/single.svg",
                          title: "Individual",
                          subtitle: "30% OFF",
                          isSelected: false,
                          isDisabled: true,
                        ),
                        Positioned(
                          top: 8,
                          right: 8,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.primary,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              "Em Breve",
                              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              RatingWithCounter(
                rating: (widget.restaurant['rating'] ?? 0.0).toDouble(),
                numOfRating: widget.restaurant['numOfRating'] ?? 0,
              ),
              const SizedBox(height: defaultPadding),
              Row(
                children: [
                  DeliveryInfo(
                    iconSrc: "assets/icons/delivery.svg",
                    text: widget.restaurant['deliveryFee'] == 0 ? "Free" : "\$${widget.restaurant['deliveryFee']}",
                    subText: "Delivery",
                  ),
                  const SizedBox(width: defaultPadding),
                  DeliveryInfo(
                    iconSrc: "assets/icons/clock.svg",
                    text: "${widget.restaurant['deliveryTime'] ?? 0}",
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
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SvgPicture.asset(
          iconSrc,
          height: 20,
          width: 20,
          colorFilter: ColorFilter.mode(
            Theme.of(context).colorScheme.primary,
            BlendMode.srcIn,
          ),
        ),
        const SizedBox(width: 8),
        Text.rich(
          TextSpan(
            text: "$text\n",
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: isDarkMode ? Colors.white : const Color(0xFF333333),
              fontWeight: FontWeight.bold,
            ),
            children: [
              TextSpan(
                text: subText,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: isDarkMode ? Colors.white70 : const Color(0xFF666666),
                  fontWeight: FontWeight.normal,
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}