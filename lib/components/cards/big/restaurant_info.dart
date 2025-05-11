import 'package:flutter/material.dart';
import '../../../constants.dart';
import 'package:flutter/material.dart';
import '../../../constants.dart';

class RestaurantCard extends StatelessWidget {
  final String logoUrl;
  final String name;
  final String foodType;
  final String distance;
  final List<DayAvailability> weekAvailability;
  final VoidCallback press; // <<<< Adicionado aqui!

  const RestaurantCard({
    super.key,
    required this.logoUrl,
    required this.name,
    required this.foodType,
    required this.distance,
    required this.weekAvailability,
    required this.press, // <<<< Adicionado aqui!
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: press, // <<<< Adicionado aqui!
      child: Card(
        elevation: 2,
        color: primaryColorDark,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  logoUrl,
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                  headers: {"Accept": "image/*"},
                  errorBuilder: (context, error, stackTrace) => Container(
                    width: 60,
                    height: 60,
                    color: Colors.grey,
                    child: Icon(Icons.image_not_supported, color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: labelColor,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "$foodType • $distance",
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: labelColor,
                          ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Column(
                children: [
                  Icon(Icons.delivery_dining, color: primaryColor, size: 20),
                  const SizedBox(height: 8),
                  Icon(Icons.people_alt, color: primaryColor, size: 20),
                ],
              ),
              const SizedBox(width: 12),
              WeekDaysStatus(days: weekAvailability),
            ],
          ),
        ),
      ),
    );
  }
}

class DayAvailability {
  final String dayLetter;
  final bool available;

  DayAvailability({required this.dayLetter, required this.available});
}

class WeekDaysStatus extends StatelessWidget {
  final List<DayAvailability> days;

  const WeekDaysStatus({super.key, required this.days});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: days.map((day) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2),
          child: Text(
            day.dayLetter,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: day.available ? primaryColor : Colors.grey.withOpacity(0.6),
            ),
          ),
        );
      }).toList(),
    );
  }
}
