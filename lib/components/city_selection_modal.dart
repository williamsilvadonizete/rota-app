import 'package:flutter/material.dart';
import 'package:rota_app/constants.dart';

class CitySelectionModal {
  static void show(BuildContext context, {required Function(String) onCitySelected}) {
    showModalBottomSheet(
      backgroundColor: primaryColorDark,
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      isScrollControlled: true,
      builder: (context) {
        return FractionallySizedBox(
          heightFactor: 0.8,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'Selecione a cidade',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: primaryColor),
                ),
              ),
              Expanded(
                child: ListView(
                  children: ['Uberlândia', 'São Paulo', 'Rio de Janeiro', 'Belo Horizonte']
                      .map((city) => ListTile(
                            title: Text(city),
                            textColor: titleColor,
                            onTap: () {
                              onCitySelected(city);
                              Navigator.pop(context);
                            },
                          ))
                      .toList(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
