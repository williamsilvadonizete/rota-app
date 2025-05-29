import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';

const defaultPadding = 20.0;
const defaultPaddingSmall = 10.0;
const defaultPaddingLarge = 30.0;

// Main colors
const primaryColor = Color.fromRGBO(245, 181, 0, 1);
const primaryColorDark = Color.fromARGB(255, 33, 32, 32);
const bodyTextColor = Color(0xFF666666);
const titleColor = Color(0xFF333333);
const labelColor = Color(0xFFFAFBFB);
const inputColor = Color(0xFFF0EDED);

const kTextFieldPadding = EdgeInsets.symmetric(horizontal: 16, vertical: 12);

// clolors that we use in our app
const accentColor = Color.fromRGBO(245, 181, 0, 1);// Color(0xFFEF9920);

const Duration kDefaultDuration = Duration(milliseconds: 250);

const TextStyle kButtonTextStyle = TextStyle(
  color: Colors.white,
  fontSize: 14,
  fontWeight: FontWeight.bold,
);

// Text Field Decoration
const OutlineInputBorder kDefaultOutlineInputBorder = OutlineInputBorder(
  borderRadius: BorderRadius.all(Radius.circular(6)),
  borderSide: BorderSide(
    color: Color(0xFFF3F2F2),
  ),
);

const InputDecoration otpInputDecoration = InputDecoration(
  contentPadding: EdgeInsets.zero,
  counterText: "",
  errorStyle: TextStyle(height: 0),
);

const kErrorBorderSide = BorderSide(color: Colors.red, width: 1);

// Validator
final passwordValidator = MultiValidator([
  RequiredValidator(errorText: 'Senha é obrigatória'),
  MinLengthValidator(8, errorText: 'A senha deve ter pelo menos 8 caracteres'),
  PatternValidator(r'(?=.*?[#?!@$%^&*-/])',
      errorText: 'A senha deve conter pelo menos um caractere especial')
]);

final emailValidator = MultiValidator([
  RequiredValidator(errorText: 'E-mail é obrigatório'),
  EmailValidator(errorText: 'Digite um e-mail válido')
]);

String? requiredValidator(String? value) {
  if (value == null || value.isEmpty) {
    return 'Este campo é obrigatório';
  }
  return null;
}

final matchValidator = MatchValidator(errorText: 'As senhas não coincidem');

final phoneNumberValidator = MinLengthValidator(10,
    errorText: 'O número de telefone deve ter pelo menos 10 dígitos');

// Common Text
final Center kOrText = Center(
    child: Text("Ou", style: TextStyle(color: titleColor.withOpacity(0.7))));
