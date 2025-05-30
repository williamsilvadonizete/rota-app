import 'package:flutter/material.dart';
import 'package:rota_gourmet/constants.dart';
import 'package:rota_gourmet/providers/theme_provider.dart';

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
          labelText: "Estado",
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
              color: ThemeProvider.primaryColor,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          filled: true,
          fillColor: Theme.of(context).cardColor,
        ),
        dropdownColor: Theme.of(context).cardColor,
        style: TextStyle(
          color: Theme.of(context).textTheme.bodyMedium?.color,
          fontWeight: FontWeight.w500,
        ),
        icon: Icon(
          Icons.arrow_drop_down,
          color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.7),
        ),
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
