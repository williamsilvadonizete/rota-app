import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:rota_gourmet/components/custom_toast.dart';
import 'package:rota_gourmet/entry_point.dart';
import 'package:rota_gourmet/screens/home/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:rota_gourmet/constants.dart';
import '../../../services/auth_service.dart';
import '../../findRestaurants/find_restaurants_screen.dart'; // Substitua pela tela correta

class SignInForm extends StatefulWidget {
  const SignInForm({super.key});

  @override
  State<SignInForm> createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
  final AuthService _authService = AuthService();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  void _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final result = await _authService.loginWithCredentials(
      _emailController.text.trim(),
      _passwordController.text,
    );

    setState(() => _isLoading = false);

    if (result != null && result['access_token'] != null) {
      // if (true) {
      String token = result['access_token'];
      await _saveToken(token);

      // Use addPostFrameCallback para garantir que o Toast seja mostrado após a renderização
      WidgetsBinding.instance.addPostFrameCallback((_) {
        CustomToast.showSuccessToast(context, "Login bem-sucedido!");
      });

      _navigateToHome();
    } else {
      // Use addPostFrameCallback para garantir que o Toast seja mostrado após a renderização
      WidgetsBinding.instance.addPostFrameCallback((_) {
        CustomToast.showErrorToast(context, "Usuário ou senha inválidos");
      });
    }
  }

  Future<void> _saveToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
    await prefs.setBool('onboarding', true);
  }

  void _navigateToHome() async {
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const EntryPoint(),
            ),
          );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const FindRestaurantsScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            validator: (value) => value!.isEmpty ? "Digite seu e-mail" : null,
            decoration: const InputDecoration(
                labelText: "Email", labelStyle: TextStyle(color: primaryColor)),
            style: Theme.of(context)
                .textTheme
                .bodyMedium!
                .copyWith(fontWeight: FontWeight.w600, color: primaryColor),
          ),
          const SizedBox(height: defaultPadding),
          TextFormField(
            controller: _passwordController,
            obscureText: true,
            validator: (value) => value!.isEmpty ? "Digite sua senha" : null,
            decoration: const InputDecoration(
                labelText: "Senha", labelStyle: TextStyle(color: primaryColor)),
            style: Theme.of(context)
                .textTheme
                .bodyMedium!
                .copyWith(fontWeight: FontWeight.w600, color: primaryColor),
          ),
          const SizedBox(height: defaultPadding),
          ElevatedButton(
            onPressed: _isLoading ? null : _handleLogin,
            child: _isLoading
                ? const CircularProgressIndicator(color: Colors.white)
                : const Text("Entrar"),
          ),
        ],
      ),
    );
  }
}
