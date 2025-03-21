import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:rota_app/constants.dart';


class TelefoneTextField extends StatelessWidget {
  final MaskedTextController _controller = MaskedTextController(mask: '(00) 00000-0000');

  TelefoneTextField({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: _controller,
        keyboardType: TextInputType.phone,
        style: TextStyle(color: Colors.white),
        
        decoration: InputDecoration(
          labelText: "Telefone",
          labelStyle: TextStyle(color: primaryColor),
          filled: true,
          fillColor: Colors.black54,
        ),
      ),
    );
  }
}
