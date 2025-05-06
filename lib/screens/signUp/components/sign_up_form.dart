import 'package:flutter/material.dart';
import 'package:rota_app/screens/auth/sign_in_screen.dart';
import 'package:rota_app/services/auth_service.dart';
import 'package:rota_app/constants.dart';
import 'package:rota_app/components/custom_toast.dart';

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
            decoration: const InputDecoration(hintText: "Nome Completo",  labelStyle: TextStyle(color: primaryColor)),
            style: Theme.of(context)
                .textTheme
                .bodyMedium!
                .copyWith(fontWeight: FontWeight.w600, color: primaryColor),
          ),
          const SizedBox(height: defaultPadding),

          // Email Field
          TextFormField(
            validator: emailValidator.call,
            onSaved: (value) => _email = value ?? '',
            textInputAction: TextInputAction.next,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(hintText: "Email",  labelStyle: TextStyle(color: primaryColor)),
            style: Theme.of(context)
                .textTheme
                .bodyMedium!
                .copyWith(fontWeight: FontWeight.w600, color: primaryColor),
          ),
          const SizedBox(height: defaultPadding),

          // Password Field
          TextFormField(
            obscureText: _obscureText,
            validator: passwordValidator.call,
            textInputAction: TextInputAction.next,
            onChanged: (value) => _password = value,
            onSaved: (value) => _password = value ?? '',
            style: Theme.of(context)
                .textTheme
                .bodyMedium!
                .copyWith(fontWeight: FontWeight.w600, color: primaryColor),
            decoration: InputDecoration(
              hintText: "Senha",
              suffixIcon: GestureDetector(
                onTap: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },
                child: _obscureText
                    ? const Icon(Icons.visibility_off, color: primaryColor)
                    : const Icon(Icons.visibility, color: primaryColor),
              ),
            ),
          ),
          const SizedBox(height: defaultPadding),

          // Confirm Password Field
          TextFormField(
            obscureText: _obscureText,
            onChanged: (value) => _confirmPassword = value,
            onSaved: (value) => _confirmPassword = value ?? '',
            style: Theme.of(context)
                .textTheme
                .bodyMedium!
                .copyWith(fontWeight: FontWeight.w600, color: primaryColor),
            validator: (value) {
              if (value != _password) {
                return 'As senhas não coincidem';
              }
              return null;
            },
            decoration: InputDecoration(
              hintText: "Confirmar senha",
              suffixIcon: GestureDetector(
                onTap: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },
                child: _obscureText
                    ? const Icon(Icons.visibility_off, color: primaryColor)
                    : const Icon(Icons.visibility, color: primaryColor),
              ),
            ),
          ),
          const SizedBox(height: defaultPadding),

          // Sign Up Button
          ElevatedButton(
            onPressed: _isLoading ? null : _submitForm,
            child: _isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: bodyTextColor,
                    ),
                  )
                : const Text("Cadastrar-se"),
          ),
        ],
      ),
    );
  }
}