import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:rota_gourmet/constants.dart';

class CpfTextField extends StatelessWidget {
  final MaskedTextController _controller = MaskedTextController(mask: '000.000.000-00');
  final String? Function(String?)? validator;
  final void Function(String?)? onSaved;
  final TextInputAction? textInputAction;
  final InputDecoration? decoration;
  final TextStyle? style;

  CpfTextField({
    super.key,
    this.validator,
    this.onSaved,
    this.textInputAction,
    this.decoration,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: _controller,
        validator: validator ?? cpfValidator,
        onSaved: onSaved,
        textInputAction: textInputAction ?? TextInputAction.next,
        keyboardType: TextInputType.number,
        style: style ?? TextStyle(
          color: Theme.of(context).textTheme.bodyMedium?.color,
          fontWeight: FontWeight.w500,
        ),
        decoration: decoration ?? InputDecoration(
          labelText: "CPF",
          labelStyle: TextStyle(
            color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.7),
          ),
          prefixIcon: Icon(
            Icons.badge_outlined,
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
