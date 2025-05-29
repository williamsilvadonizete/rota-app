import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rota_gourmet/providers/theme_provider.dart';
import 'package:rota_gourmet/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:rota_gourmet/screens/profile/profile_detail.dart';
import 'package:rota_gourmet/services/auth_service.dart';
import 'package:rota_gourmet/screens/auth/sign_in_screen.dart';
import 'package:rota_gourmet/screens/help/help_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String _userName = '';
  String _userEmail = '';

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  Future<void> _loadUserInfo() async {
    if (!mounted) return;
    
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');
      
      if (!mounted) return;
      
      if (token != null) {
        final decodedToken = JwtDecoder.decode(token);
        final firstName = decodedToken['given_name'] ?? '';
        final lastName = decodedToken['family_name'] ?? '';
        final email = decodedToken['email'] ?? '';
        
        if (mounted) {
          setState(() {
            _userName = '$firstName $lastName'.trim();
            _userEmail = email;
          });
        }
      }
    } catch (e) {
      debugPrint('Error loading user info: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;
    
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Perfil'),
        backgroundColor: ThemeProvider.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(defaultPadding),
        children: [
          _buildProfileHeader(context),
          const SizedBox(height: defaultPadding * 2),
          _buildSettingsSection(context),
        ],
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      color: Theme.of(context).cardColor,
      child: Padding(
        padding: const EdgeInsets.all(defaultPadding),
        child: Column(
          children: [
            CircleAvatar(
              radius: 50,
              backgroundColor: ThemeProvider.primaryColor,
              child: Text(
                _userName.isNotEmpty ? _userName[0].toUpperCase() : '?',
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: defaultPadding),
            Text(
              _userName,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              _userEmail,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Configurações',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: defaultPadding),
        Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          color: Theme.of(context).cardColor,
          child: Column(
            children: [
              _buildThemeToggle(context),
              const Divider(height: 1),
              _buildSettingsItem(
                context,
                icon: Icons.person_outline,
                title: 'Informações Pessoais',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ProfileDetailScreen()),
                  );
                },
              ),
              const Divider(height: 1),
              _buildSettingsItem(
                context,
                icon: Icons.notifications_outlined,
                title: 'Notificações',
                onTap: () {
                  // Implementar navegação para configurações de notificações
                },
              ),
              const Divider(height: 1),
              _buildSettingsItem(
                context,
                icon: Icons.help_outline,
                title: 'Ajuda',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const HelpScreen()),
                  );
                },
              ),
              const Divider(height: 1),
              _buildSettingsItem(
                context,
                icon: Icons.logout,
                title: 'Sair',
                onTap: () async {
                  if (!mounted) return;
                  
                  try {
                    final authService = AuthService();
                    await authService.logout();
                  } catch (e) {
                    debugPrint('Error during logout: $e');
                  } finally {
                    if (mounted) {
                      // Sempre redireciona para o login, independente do resultado do logout
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => const SignInScreen()),
                        (route) => false,
                      );
                    }
                  }
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildThemeToggle(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return SwitchListTile(
          title: const Text('Tema Escuro'),
          subtitle: Text(
            themeProvider.isDarkMode ? 'Ativado' : 'Desativado',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          value: themeProvider.isDarkMode,
          onChanged: (bool value) {
            themeProvider.toggleTheme();
          },
          secondary: Icon(
            themeProvider.isDarkMode ? Icons.dark_mode : Icons.light_mode,
            color: ThemeProvider.primaryColor,
          ),
          activeColor: ThemeProvider.primaryColor,
          activeTrackColor: ThemeProvider.primaryColor.withOpacity(0.5),
        );
      },
    );
  }

  Widget _buildSettingsItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: ThemeProvider.primaryColor,
      ),
      title: Text(title),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
