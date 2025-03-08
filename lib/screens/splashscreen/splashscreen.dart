import 'package:flutter/material.dart';
import 'package:rota_app/constants.dart';
import '../onboarding/onboarding_scrreen.dart'; // Importa a tela de Onboarding

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    // Inicializa o AnimationController para controlar a animação
    _controller = AnimationController(
      duration: const Duration(seconds: 4), // Duração da animação
      vsync: this,
    )
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          // Após a animação terminar, navega para a próxima tela
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const OnboardingScreen()),
          );
        }
      });

    // Definir animações para opacidade e escala
    _opacityAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );
    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    // Iniciar a animação
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColorDark, // Cor de fundo da Splash
      body: Stack(
        children: [
          // Imagem de fundo com um pouco de transparência
          Opacity(
            opacity: 0.5, // Definindo o nível de transparência
            child: Image.asset(
              "assets/images/background_splash.png", // Substitua pela imagem desejada
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
          ),
          // Conteúdo da tela de splash com animações
          Center(
            child: FadeTransition(
              opacity: _opacityAnimation, // Animação de opacidade
              child: ScaleTransition(
                scale: _scaleAnimation, // Animação de escala
                child: Image.asset("assets/images/Logo.png"), // Imagem do logo
              ),
            ),
          ),
        ],
      ),
    );
  }
}
