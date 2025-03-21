import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:rota_app/constants.dart';

class CepTextField extends StatelessWidget {
  final MaskedTextController _controller = MaskedTextController(mask: '00000-000');

   @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: _controller,
        keyboardType: TextInputType.number,
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: "Cep",
          labelStyle: TextStyle(color: primaryColor),
          filled: true,
          fillColor: Colors.black54,
        ),
      ),
    );
  }
}
