import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rota_gourmet/components/qrscanner/qr_scanner_widget.dart';
import 'package:rota_gourmet/screens/onboarding/onboarding_scrreen.dart';

import 'constants.dart';
import 'screens/home/home_screen.dart';
import 'screens/profile/profile_screen.dart';
import 'screens/search/search_screen.dart';

class EntryPoint extends StatefulWidget {
  const EntryPoint({super.key});

  @override
  State<EntryPoint> createState() => _EntryPointState();
}

class _EntryPointState extends State<EntryPoint> {
  int _selectedIndex = 0;

  final List<Map<String, dynamic>> _navitems = [
    {"icon": "assets/icons/home.svg", "title": "Home"},
    {"icon": "assets/icons/search.svg", "title": "Busca"},
    {"icon": null, "title": null}, // Espaço para o botão QR Code
    {"icon": "assets/icons/question.svg", "title": "Como Usar"},
    {"icon": "assets/icons/profile.svg", "title": "Perfil"},
  ];

  final List<Widget> _screens = [
    const HomeScreen(),
    const SearchScreen(),
    const SizedBox(), // Placeholder for QR Code button
    const SizedBox(), // Placeholder for How to Use
    const ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    if (index == 3) {
      // Botão de ajuda
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
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColorDark,
      body: _screens[_selectedIndex],
      bottomNavigationBar: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Container(
            height: 110, // Aumenta a altura da BottomNavigationBar
            decoration: BoxDecoration(
              color: primaryColorDark,
            ),
            child: CupertinoTabBar(
              onTap: _onItemTapped,
              currentIndex: _selectedIndex,
              activeColor: primaryColor,
              inactiveColor: bodyTextColor,
              backgroundColor: Colors.transparent, // Mantemos a cor no Container
              items: List.generate(
                _navitems.length,
                (index) {
                  if (index == 2) {
                    // Botão QR Code
                    return const BottomNavigationBarItem(
                      icon: SizedBox.shrink(),
                      label: '',
                    );
                  } else if (index == 3) {
                    // Botão de ajuda
                    return BottomNavigationBarItem(
                      icon: GestureDetector(
                        onTap: () {
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
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: SvgPicture.asset(
                            _navitems[index]["icon"]!,
                            height: 30,
                            width: 30,
                            colorFilter: ColorFilter.mode(
                              index == _selectedIndex ? primaryColor : bodyTextColor,
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                      ),
                      label: _navitems[index]["title"],
                    );
                  } else {
                    return BottomNavigationBarItem(
                      icon: Padding(
                        padding: const EdgeInsets.only(top: 10), // Centraliza os ícones na nova altura
                        child: SvgPicture.asset(
                          _navitems[index]["icon"],
                          height: 30,
                          width: 30,
                          colorFilter: ColorFilter.mode(
                            index == _selectedIndex ? primaryColor : bodyTextColor,
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                      label: _navitems[index]["title"],
                    );
                  }
                },
              ),
            ),
          ),
         Positioned(
  bottom: 33,
  child: Column(
    children: [
      FloatingActionButton(
        onPressed: () => QrScannerModal.show(
          context: context,
          onScanCompleted: (value) {
            // Ação quando um QR Code é lido
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Código lido: $value')),
            );
          },
        ),
        backgroundColor: primaryColor,
        shape: const CircleBorder(),
        child: const Icon(Icons.qr_code, size: 42, color: Colors.white),
      ),
      const SizedBox(height: 1),
      const Text(
        "Escanear",
        style: TextStyle(
          color: Colors.white,
          fontSize: 11,
          fontWeight: FontWeight.w500,
        ),
      ),
    ],
  ),
)
        ],
      ),
    );
  }
}
