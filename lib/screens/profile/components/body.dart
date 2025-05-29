import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rota_gourmet/components/custom_status_bar.dart';
import 'package:rota_gourmet/screens/profile/profile_detail.dart';
import 'package:rota_gourmet/components/custom_toast.dart';
import 'package:rota_gourmet/constants.dart';
import 'package:rota_gourmet/screens/auth/sign_in_screen.dart';
import 'package:rota_gourmet/services/auth_service.dart';

class Body extends StatelessWidget {
  const Body({super.key});

  Future<void> _handleLogout(BuildContext context) async {
    final authService = AuthService();
    final success = await authService.logout();

    if (success) {
      if (context.mounted) {
        CustomToast.showSuccessToast(context, "Logout realizado com sucesso!");
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const SignInScreen()),
          (route) => false,
        );
      }
    } else {
      if (context.mounted) {
        CustomToast.showErrorToast(context, "Erro ao realizar logout");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 33, 32, 32),
      appBar: CustomStatusAppBar(showBackButton: true),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          child: Column(
            children: [
              ProfileMenuCard(
                svgSrc: "assets/icons/profile.svg",
                title: "Informações do Usuário",
                subTitle: "Altere suas informações",
                press: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ProfileDetailScreen()),
                  );
                },
              ),
              ProfileMenuCard(
                svgSrc: "assets/icons/share.svg",
                title: "Compartilhar",
                subTitle: "Convide seus amigos",
                press: () {
                  // Aqui pode ser implementado o compartilhamento
                  print("Compartilhar acionado");
                },
              ),
              const SizedBox(height: 24),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: ElevatedButton.icon(
                  onPressed: () => _handleLogout(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor.withOpacity(0.9),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  icon: const Icon(Icons.logout_rounded, size: 24),
                  label: const Text(
                    "Sair",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

class ProfileMenuCard extends StatelessWidget {
  const ProfileMenuCard({
    super.key,
    required this.title,
    required this.subTitle,
    required this.svgSrc,
    required this.press,
  });

  final String title, subTitle, svgSrc;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: InkWell(
        onTap: press,
        borderRadius: BorderRadius.circular(12),
        splashColor: Colors.white12,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.black54,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 6,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white12,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: SvgPicture.asset(
                  svgSrc,
                  height: 24,
                  width: 24,
                  colorFilter: const ColorFilter.mode(
                    Colors.white70,
                    BlendMode.srcIn,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subTitle,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.white60,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios_rounded,
                size: 20,
                color: Colors.white38,
              )
            ],
          ),
        ),
      ),
    );
  }
}
