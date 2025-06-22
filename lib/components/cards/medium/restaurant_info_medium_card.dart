import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rota_gourmet/providers/theme_provider.dart';
import 'package:rota_gourmet/constants.dart';

class RestaurantInfoMediumCard extends StatelessWidget {
  final String? image;
  final String name;
  final String? location;
  final int? delivertTime;
  final double? rating;
  final VoidCallback press;

  const RestaurantInfoMediumCard({
    super.key,
    this.image,
    required this.name,
    this.location,
    this.delivertTime,
    this.rating,
    required this.press,
  });

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    ImageProvider<Object> getImage() {
      if (image != null && image!.isNotEmpty) {
        if (image!.startsWith('http')) {
          return NetworkImage(image!);
        } else {
          return AssetImage(image!);
        }
      }
      // Imagem padrão
      return const AssetImage('assets/images/notfound.jpg');
    }

    return GestureDetector(
      onTap: press,
      child: Container(
        width: 200,
        decoration: BoxDecoration(
          color: isDarkMode ? const Color(0xFF1A1A1A) : Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              height: 120,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
                image: DecorationImage(
                  image: getImage(),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(defaultPadding / 2),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: isDarkMode ? Colors.white : const Color(0xFF333333),
                        ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (location != null && location!.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          size: 16,
                          color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            location!,
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                                ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                  if (rating != null || delivertTime != null) ...[
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        if (rating != null) ...[
                          Icon(
                            Icons.star,
                            size: 16,
                            color: ThemeProvider.primaryColor,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            rating.toString(),
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                                ),
                          ),
                          const SizedBox(width: 8),
                        ],
                        if (delivertTime != null) ...[
                          Icon(
                            Icons.access_time,
                            size: 16,
                            color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                          ),
                          const SizedBox(width: 4),
                          Text(
                            "$delivertTime min",
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                                ),
                          ),
                        ],
                      ],
                    ),
                  ]
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
