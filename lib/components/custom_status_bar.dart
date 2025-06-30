import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:rota_gourmet/components/city_selection_modal.dart';
import 'package:rota_gourmet/constants.dart';
import 'package:rota_gourmet/components/chart_modal.dart';  // Importa o ChartModal
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:rota_gourmet/screens/auth/sign_in_screen.dart';
import 'package:rota_gourmet/services/auth_service.dart';
import 'package:rota_gourmet/screens/onboarding/onboarding_scrreen.dart';
import 'dart:async';

class CustomStatusAppBar extends StatefulWidget implements PreferredSizeWidget {
  @override
  final Size preferredSize;

  final bool showBackButton;

  const CustomStatusAppBar({
    super.key,
    this.showBackButton = false,
  }) : preferredSize = const Size.fromHeight(120.0);

  @override
  _CustomStatusAppBarState createState() => _CustomStatusAppBarState();
}

class _CustomStatusAppBarState extends State<CustomStatusAppBar> {
  String selectedCity = 'Uberlândia';  // Cidade inicial
  String _userName = '';
  Timer? _tokenCheckTimer;
  final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();
    _loadUserName();
    _startTokenCheck();
  }

  @override
  void dispose() {
    _tokenCheckTimer?.cancel();
    super.dispose();
  }

  void _startTokenCheck() {
    _tokenCheckTimer?.cancel();
    // Check token every 5 minutes
    _tokenCheckTimer = Timer.periodic(const Duration(minutes: 5), (timer) {
      _validateToken();
    });
  }

  Future<void> _validateToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');
      
      if (token == null) {
        await _handleLogout();
        return;
      }

      // Check if token will expire in the next 10 minutes
      final expirationTime = JwtDecoder.getExpirationDate(token);
      final now = DateTime.now();
      final timeUntilExpiration = expirationTime.difference(now);

      if (timeUntilExpiration.inMinutes <= 10) {
        // Try to refresh the token
        final newTokens = await _authService.validateStoredToken();
        
        if (newTokens != null && newTokens['access_token'] != null) {
          // Save the new token
          await prefs.setString('auth_token', newTokens['access_token']);
          
          // Update user info with new token
          final decodedToken = JwtDecoder.decode(newTokens['access_token']);
          final firstName = decodedToken['given_name'] ?? '';
          final lastName = decodedToken['family_name'] ?? '';
          
          if (mounted) {
            setState(() {
              _userName = '$firstName $lastName'.trim();
            });
          }
        } else {
          // If refresh failed, logout and redirect to login
          await _handleLogout();
          return;
        }
      } else {
        // Token is still valid, just update user info
        final decodedToken = JwtDecoder.decode(token);
        final firstName = decodedToken['given_name'] ?? '';
        final lastName = decodedToken['family_name'] ?? '';
        
        if (mounted) {
          setState(() {
            _userName = '$firstName $lastName'.trim();
          });
        }
      }
    } catch (e) {
      print('Error validating token: $e');
      // If any error occurs during validation, logout and redirect to login
      await _handleLogout();
    }
  }

  Future<void> _handleLogout() async {
    if (!mounted) return;

    try {
      final success = await _authService.logout();
      
      // Remove token regardless of logout success
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('auth_token');
      
      if (mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const SignInScreen()),
          (route) => false,
        );
      }
    } catch (e) {
      print('Erro durante o processo de logout: $e');
      // Even if logout fails, remove token and redirect to login
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('auth_token');
      
      if (mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const SignInScreen()),
          (route) => false,
        );
      }
    }
  }

  Future<void> _loadUserName() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');
      
      if (token != null) {
        final decodedToken = JwtDecoder.decode(token);
        final firstName = decodedToken['given_name'] ?? '';
        final lastName = decodedToken['family_name'] ?? '';
        
        if (mounted) {
          setState(() {
            _userName = '$firstName $lastName'.trim();
          });
        }
      }
    } catch (e) {
      print('Error loading user name: $e');
    }
  }

  // Função para abrir o modal do gráfico utilizando o ChartModal
  void _openChartModal() {
    PerformanceChartModal.show(
      context: context,
    );
  }

  void _openOnboarding() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const OnboardingScreen(
          navigateToSignIn: false,
          skipOnboarding: false,
          isFromHelp: true,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: primaryColor,
      centerTitle: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
      ),
      // leading: widget.showBackButton
      //     ? IconButton(
      //         onPressed: () => Navigator.of(context).pop(),
      //         icon: const Icon(Icons.arrow_back, color: primaryColorDark),
      //       )
      //     : IconButton(
      //         onPressed: () {},
      //         icon: const Icon(Icons.subject, color: primaryColorDark),
      //       ),
      actions: [
        IconButton(
          onPressed: _openOnboarding,
          icon: const Icon(
            Icons.help_outline,
            color: primaryColorDark,
          ),
        ),
        IconButton(
          onPressed: _openChartModal, // Chama o método para abrir o modal
          icon: const Icon(
            Icons.bar_chart,
            color: primaryColorDark,
          ),
        ),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(80.0),
        child: Padding(
          padding: const EdgeInsets.only(left: 25, bottom: 15),
          child: _buildUserInfo(context),
        ),
      ),
    );
  }

  Widget _buildUserInfo(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: const BoxDecoration(
            color: primaryColor,
            shape: BoxShape.circle,
          ),
          child: SvgPicture.asset(
            "assets/icons/logo.svg",
            fit: BoxFit.contain,
          ),
        ),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _userName.isNotEmpty ? _userName : 'Bem-vindo',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: primaryColorDark,
              ),
            ),
            // GestureDetector(
            //   onTap: () => CitySelectionModal.show(
            //     context,
            //     onCitySelected: (city) {
            //       setState(() {
            //         selectedCity = city;  // Atualiza a cidade selecionada
            //       });
            //       print("Cidade selecionada: $city");
            //     },
            //   ),
            //   child: Row(
            //     children: [
            //       const Icon(
            //         Icons.location_on,
            //         color: primaryColorDark,
            //         size: 16,
            //       ),
            //       const SizedBox(width: 4),  // Espaço entre o ícone e o texto
            //       Text(
            //         selectedCity,
            //         style: const TextStyle(
            //             fontSize: 14, color: primaryColorDark, decoration: TextDecoration.underline),
            //       ),
            //     ],
            //   ),
            // ),
          ],
        ),
      ],
    );
  }
}
