import 'package:flutter/material.dart';
import 'package:rota_gourmet/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../onboarding/onboarding_scrreen.dart'; // Importa a tela de Onboarding
import '../auth/sign_in_screen.dart';
import '../../entry_point.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;
  late Animation<double> _scaleAnimation;
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..addStatusListener(_handleAnimationStatus);

    _opacityAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    setState(() => _initialized = true);
    _controller.forward();
  }

  Future<void> _handleAnimationStatus(AnimationStatus status) async {
    if (status == AnimationStatus.completed) {
      final prefs = await SharedPreferences.getInstance();
      final skipOnboarding = prefs.getBool('onboarding') ?? false;
      final storedToken = prefs.getString('auth_token');
      
      if (!mounted) return;

      final route = MaterialPageRoute(
        builder: (context) => storedToken != null
            ? const EntryPoint()
            : skipOnboarding
                ? const SignInScreen()
                : const OnboardingScreen(
                    navigateToSignIn: true,
                    skipOnboarding: false,
                  ),
      );

      Navigator.pushReplacement(context, route);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_initialized) {
      return const Scaffold(
        backgroundColor: primaryColorDark,
        body: Center(
          child: CircularProgressIndicator(
            color: Colors.white,
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: primaryColorDark,
      body: Stack(
        children: [
          Opacity(
            opacity: 0.5,
            child: Image.asset(
              "assets/images/background_splash.png",
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
          ),
          Center(
            child: FadeTransition(
              opacity: _opacityAnimation,
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: Image.asset(
                  "assets/images/Logo.png",
                  width: 200,
                  height: 200,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}