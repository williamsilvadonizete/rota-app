import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';

// clolors that we use in our app
const titleColor = Color.fromARGB(255, 250, 251, 251);
const labelColor = Color.fromARGB(255, 250, 251, 251);
const primaryColor =Color.fromRGBO(245, 181, 0, 1);// Color.fromARGB(255, 245, 143, 26);
// const primaryColorDark =  Color.fromARGB(255, 80, 79, 77);
const primaryColorDark =  Color.fromARGB(255, 33, 32, 32);
const accentColor = Color.fromRGBO(245, 181, 0, 1);// Color(0xFFEF9920);
const bodyTextColor = Color.fromARGB(255, 240, 237, 237);
const inputColor = Color.fromARGB(255, 240, 237, 237);

const double defaultPadding = 7;
const Duration kDefaultDuration = Duration(milliseconds: 250);

const TextStyle kButtonTextStyle = TextStyle(
  color: Colors.white,
  fontSize: 14,
  fontWeight: FontWeight.bold,
);

const EdgeInsets kTextFieldPadding = EdgeInsets.symmetric(
  horizontal: defaultPadding,
  vertical: defaultPadding,
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

final requiredValidator =
    RequiredValidator(errorText: 'Este campo é obrigatório');
final matchValidator = MatchValidator(errorText: 'As senhas não coincidem');

final phoneNumberValidator = MinLengthValidator(10,
    errorText: 'O número de telefone deve ter pelo menos 10 dígitos');

// Common Text
final Center kOrText = Center(
    child: Text("Ou", style: TextStyle(color: titleColor.withOpacity(0.7))));
