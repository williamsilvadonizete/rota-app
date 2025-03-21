import 'package:flutter/material.dart';
import 'package:rota_app/constants.dart';

class EstadoDropdown extends StatefulWidget {
  const EstadoDropdown({super.key});

  @override
  _EstadoDropdownState createState() => _EstadoDropdownState();
}

class _EstadoDropdownState extends State<EstadoDropdown> {
  String? _estadoSelecionado;

  final List<String> estados = ['MG', 'SP', 'RJ', 'RS', 'BA', 'PR', 'SC', 'PE', 'CE', 'GO'];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: DropdownButtonFormField<String>(
        value: _estadoSelecionado,
        decoration: InputDecoration(
          labelText: "Selecione o Estado",
          labelStyle: TextStyle(color: primaryColor),
          filled: true,
          fillColor: Colors.black54,
        ),
        dropdownColor: Colors.black54,
        style: TextStyle(color: Colors.white),
        items: estados.map((String estado) {
          return DropdownMenuItem<String>(
            value: estado,
            child: Text(estado),
          );
        }).toList(),
        onChanged: (String? novoValor) {
          setState(() {
            _estadoSelecionado = novoValor;
          });
        },
      ),
    );
  }
}
