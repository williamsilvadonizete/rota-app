import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:rota_gourmet/components/custom_bar.dart';
import '../../components/welcome_text.dart';
import '../../constants.dart';
import 'sign_up_screen.dart';
import 'components/sign_in_form.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:rota_gourmet/services/auth_service.dart';
import 'package:rota_gourmet/entry_point.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();
    _validateToken();
  }

  Future<void> _validateToken() async {
    final prefs = await SharedPreferences.getInstance();
    final storedToken = prefs.getString('auth_token');
    if (storedToken != null) {
      final result = await _authService.validateStoredToken();
      if (result != null && result['access_token'] != null) {
        await _saveToken(result['access_token']);
        _navigateToHome();
      }
    }
  }

  Future<void> _saveToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
  }

  void _navigateToHome() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const EntryPoint()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColorDark,
      appBar: CustomAppBar(showBackButton: false),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: defaultPadding).copyWith(top: defaultPadding * 3),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const WelcomeText(
              title: "Bem-Vindo",
              text: "Digite seu E-mail ou Telefone para entrar. Você não vai mais parar em Casa! :)",
            ),
            const SignInForm(),
            const SizedBox(height: defaultPadding),
            kOrText,
            const SizedBox(height: defaultPadding * 1.5),
            Center(
              child: Text.rich(
                TextSpan(
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall!
                      .copyWith(fontWeight: FontWeight.w600, color: labelColor),
                  text: "Nāo tem uma conta? ",
                  children: <TextSpan>[
                    TextSpan(
                      text: "Cadastre-se",
                      style: const TextStyle(color: primaryColor),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const SignUpScreen(),
                              ),
                            ),
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(height: defaultPadding),
          ],
        ),
      ),
    );
  }
}
