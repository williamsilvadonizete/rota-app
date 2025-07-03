import 'package:flutter/material.dart';
import 'package:rota_gourmet/screens/auth/sign_in_screen.dart';
import 'package:rota_gourmet/services/auth_service.dart';
import 'package:rota_gourmet/constants.dart';
import 'package:rota_gourmet/components/custom_toast.dart';
import 'package:rota_gourmet/components/fields/cpf_text_field.dart';
import 'package:rota_gourmet/components/fields/telefone_text_field.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({super.key});

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final _formKey = GlobalKey<FormState>();
  final _authService = AuthService();
  bool _obscureText = true;
  bool _isLoading = false;

  String _fullName = '';
  String _email = '';
  String _password = '';
  String _confirmPassword = '';
  String _cpf = '';
  String _telefone = '';

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    if (_password != _confirmPassword) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        CustomToast.showErrorToast(context, "As senhas não coincidem");
      });
      return;
    }

    setState(() => _isLoading = true);

    try {
      final nameParts = _fullName.split(' ');
      final firstName = nameParts.first;
      final lastName = nameParts.length > 1 ? nameParts.last : '';

      final result = await _authService.registerUser(
        username: _email,
        email: _email,
        firstName: firstName,
        lastName: lastName,
        password: _password,
        cpf: _cpf,
        telefone: _telefone,
      );

      if (result != null) {
        CustomToast.showSuccessToast(context, "Cadastro realizado com sucesso!");
        await Future.delayed(const Duration(milliseconds: 1500));
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const SignInScreen()),
          );
        }
      } else {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          CustomToast.showErrorToast(context, "Falha no cadastro");
        });
      }
    } catch (e) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        CustomToast.showErrorToast(context, "Erro: ${e.toString()}");
      });
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          // Full Name Field
          TextFormField(
            validator: requiredValidator.call,
            onSaved: (value) => _fullName = value ?? '',
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              labelText: "Nome Completo",
              labelStyle: const TextStyle(color: Colors.white70),
              prefixIcon: const Icon(Icons.person_outline, color: Colors.white70),
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.white24),
                borderRadius: BorderRadius.circular(8),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: primaryColor),
                borderRadius: BorderRadius.circular(8),
              ),
              filled: true,
              fillColor: Colors.white.withOpacity(0.05),
              hintStyle: const TextStyle(color: Colors.white38),
            ),
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 16.0),

          // Email Field
          TextFormField(
            validator: emailValidator.call,
            onSaved: (value) => _email = value ?? '',
            textInputAction: TextInputAction.next,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              labelText: "Email",
              labelStyle: const TextStyle(color: Colors.white70),
              prefixIcon: const Icon(Icons.email_outlined, color: Colors.white70),
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.white24),
                borderRadius: BorderRadius.circular(8),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: primaryColor),
                borderRadius: BorderRadius.circular(8),
              ),
              filled: true,
              fillColor: Colors.white.withOpacity(0.05),
              hintStyle: const TextStyle(color: Colors.white38),
            ),
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 16.0),

          // CPF Field
          CpfTextField(
            onSaved: (value) => _cpf = value ?? '',
            decoration: InputDecoration(
              labelText: "CPF",
              labelStyle: const TextStyle(color: Colors.white70),
              prefixIcon: const Icon(Icons.credit_card, color: Colors.white70),
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.white24),
                borderRadius: BorderRadius.circular(8),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: primaryColor),
                borderRadius: BorderRadius.circular(8),
              ),
              filled: true,
              fillColor: Colors.white.withOpacity(0.05),
              hintStyle: const TextStyle(color: Colors.white38),
            ),
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 16.0),

          // Telefone Field
          TelefoneTextField(
            onSaved: (value) => _telefone = value ?? '',
            decoration: InputDecoration(
              labelText: "Telefone",
              labelStyle: const TextStyle(color: Colors.white70),
              prefixIcon: const Icon(Icons.phone, color: Colors.white70),
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.white24),
                borderRadius: BorderRadius.circular(8),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: primaryColor),
                borderRadius: BorderRadius.circular(8),
              ),
              filled: true,
              fillColor: Colors.white.withOpacity(0.05),
              hintStyle: const TextStyle(color: Colors.white38),
            ),
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 16.0),

          // Password Field
          TextFormField(
            obscureText: _obscureText,
            validator: passwordValidator.call,
            textInputAction: TextInputAction.next,
            onChanged: (value) => _password = value,
            onSaved: (value) => _password = value ?? '',
            decoration: InputDecoration(
              labelText: "Senha",
              labelStyle: const TextStyle(color: Colors.white70),
              prefixIcon: const Icon(Icons.lock_outline, color: Colors.white70),
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.white24),
                borderRadius: BorderRadius.circular(8),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: primaryColor),
                borderRadius: BorderRadius.circular(8),
              ),
              filled: true,
              fillColor: Colors.white.withOpacity(0.05),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscureText ? Icons.visibility : Icons.visibility_off,
                  color: Colors.white70,
                ),
                onPressed: () => setState(() => _obscureText = !_obscureText),
              ),
            ),
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 16.0),

          // Confirm Password Field
          TextFormField(
            obscureText: _obscureText,
            onChanged: (value) => _confirmPassword = value,
            onSaved: (value) => _confirmPassword = value ?? '',
            validator: (value) {
              if (value != _password) {
                return 'As senhas não coincidem';
              }
              return null;
            },
            decoration: InputDecoration(
              labelText: "Confirmar senha",
              labelStyle: const TextStyle(color: Colors.white70),
              prefixIcon: const Icon(Icons.lock_outline, color: Colors.white70),
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.white24),
                borderRadius: BorderRadius.circular(8),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: primaryColor),
                borderRadius: BorderRadius.circular(8),
              ),
              filled: true,
              fillColor: Colors.white.withOpacity(0.05),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscureText ? Icons.visibility : Icons.visibility_off,
                  color: Colors.white70,
                ),
                onPressed: () => setState(() => _obscureText = !_obscureText),
              ),
            ),
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 16.0),

          // Sign Up Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _isLoading ? null : _submitForm,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: primaryColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 0,
                textStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                  color: Color(0xB3000000),
                ),
              ),
              child: _isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Color(0xB3000000),
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.person_add_rounded, size: 20, color: Color(0xB3000000)),
                        SizedBox(width: 8),
                        Text(
                          "Cadastrar-se",
                          style: TextStyle(color: Color(0xB3000000)),
                        ),
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }
}