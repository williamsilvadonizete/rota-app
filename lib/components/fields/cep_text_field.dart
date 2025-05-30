import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:rota_gourmet/constants.dart';

class CepTextField extends StatelessWidget {
  final MaskedTextController _controller = MaskedTextController(mask: '00000-000');

  CepTextField({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: _controller,
        keyboardType: TextInputType.number,
        style: TextStyle(
          color: Theme.of(context).textTheme.bodyMedium?.color,
          fontWeight: FontWeight.w500,
        ),
        decoration: InputDecoration(
          labelText: "CEP",
          labelStyle: TextStyle(
            color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.7),
          ),
          prefixIcon: Icon(
            Icons.location_on_outlined,
            color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.7),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.24) ?? Colors.grey,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: primaryColor,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          filled: true,
          fillColor: Theme.of(context).cardColor,
        ),
      ),
    );
  }
}
