import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';

const defaultPadding = 10.0;
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

// CPF Validator
String? cpfValidator(String? value) {
  if (value == null || value.isEmpty) {
    return 'CPF é obrigatório';
  }
  
  // Remove caracteres não numéricos
  final cpf = value.replaceAll(RegExp(r'[^\d]'), '');
  
  if (cpf.length != 11) {
    return 'CPF deve ter 11 dígitos';
  }
  
  // Verifica se todos os dígitos são iguais
  if (RegExp(r'^(\d)\1{10}$').hasMatch(cpf)) {
    return 'CPF inválido';
  }
  
  // Validação dos dígitos verificadores
  int sum = 0;
  for (int i = 0; i < 9; i++) {
    sum += int.parse(cpf[i]) * (10 - i);
  }
  int remainder = sum % 11;
  int digit1 = remainder < 2 ? 0 : 11 - remainder;
  
  if (int.parse(cpf[9]) != digit1) {
    return 'CPF inválido';
  }
  
  sum = 0;
  for (int i = 0; i < 10; i++) {
    sum += int.parse(cpf[i]) * (11 - i);
  }
  remainder = sum % 11;
  int digit2 = remainder < 2 ? 0 : 11 - remainder;
  
  if (int.parse(cpf[10]) != digit2) {
    return 'CPF inválido';
  }
  
  return null;
}

// Telefone Validator
String? telefoneValidator(String? value) {
  if (value == null || value.isEmpty) {
    return 'Telefone é obrigatório';
  }
  
  // Remove caracteres não numéricos
  final telefone = value.replaceAll(RegExp(r'[^\d]'), '');
  
  if (telefone.length < 10 || telefone.length > 11) {
    return 'Telefone deve ter 10 ou 11 dígitos';
  }
  
  return null;
}

// Common Text
final Center kOrText = Center(
    child: Text("Ou", style: TextStyle(color: titleColor.withOpacity(0.7))));
