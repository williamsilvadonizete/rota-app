import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:rota_gourmet/components/custom_toast.dart';
import 'package:rota_gourmet/entry_point.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:rota_gourmet/constants.dart';
import '../../../services/auth_service.dart';
import '../../findRestaurants/find_restaurants_screen.dart';

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
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final result = await _authService.loginWithCredentials(
        _emailController.text.trim(),
        _passwordController.text,
      );

      if (!mounted) return;

      if (result != null && result['access_token'] != null) {
        String token = result['access_token'];
        await _saveToken(token);

        CustomToast.showSuccessToast(context, "Login bem-sucedido!");
        await _navigateToHome();
      } else {
        CustomToast.showErrorToast(context, "Usuário ou senha inválidos");
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await Future.wait([
      prefs.setString('auth_token', token),
      prefs.setBool('onboarding', true),
    ]);
  }

  Future<void> _navigateToHome() async {
    final permission = await Geolocator.checkPermission();
    if (!mounted) return;

    final route = MaterialPageRoute(
      builder: (context) => permission == LocationPermission.whileInUse ||
              permission == LocationPermission.always
          ? const EntryPoint()
          : const FindRestaurantsScreen(),
    );

    Navigator.pushReplacement(context, route);
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
            textInputAction: TextInputAction.next,
            validator: (value) => value?.isEmpty ?? true ? "Digite seu e-mail" : null,
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
          const SizedBox(height: defaultPadding),
          TextFormField(
            controller: _passwordController,
            obscureText: _obscurePassword,
            textInputAction: TextInputAction.done,
            onFieldSubmitted: (_) => _handleLogin(),
            validator: (value) => value?.isEmpty ?? true ? "Digite sua senha" : null,
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
                  _obscurePassword ? Icons.visibility : Icons.visibility_off,
                  color: Colors.white70,
                ),
                onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
              ),
            ),
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: defaultPadding),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _isLoading ? null : _handleLogin,
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
                        Icon(Icons.login_rounded, size: 20, color: Color(0xB3000000)),
                        SizedBox(width: 8),
                        Text(
                          "Entrar",
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
