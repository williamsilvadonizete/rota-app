import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rota_gourmet/providers/theme_provider.dart';
import 'package:rota_gourmet/screens/splashscreen/splashscreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  final themeProvider = ThemeProvider();
  await themeProvider.init();
  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => themeProvider),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        final isDark = themeProvider.isDarkMode;
        
        return MaterialApp(
          title: 'Rota App',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            useMaterial3: true,
            brightness: Brightness.light,
            primaryColor: ThemeProvider.primaryColor,
            scaffoldBackgroundColor: ThemeProvider.backgroundColor,
            colorScheme: ColorScheme.light(
              primary: ThemeProvider.primaryColor,
              secondary: ThemeProvider.secondaryColor,
              background: ThemeProvider.backgroundColor,
              surface: Colors.white,
              onPrimary: Colors.white,
              onSecondary: Colors.black,
              onBackground: ThemeProvider.titleColor,
              onSurface: ThemeProvider.titleColor,
            ),
            appBarTheme: AppBarTheme(
              backgroundColor: isDark ? const Color(0xFF1A1D1F) : Colors.white,
              elevation: 0,
              iconTheme: IconThemeData(
                color: isDark ? Colors.white : ThemeProvider.titleColor,
              ),
              titleTextStyle: TextStyle(
                color: isDark ? Colors.white : ThemeProvider.titleColor,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          darkTheme: ThemeData(
            useMaterial3: true,
            brightness: Brightness.dark,
            primaryColor: ThemeProvider.primaryColor,
            scaffoldBackgroundColor: const Color(0xFF1A1D1F),
            colorScheme: ColorScheme.dark(
              primary: ThemeProvider.primaryColor,
              secondary: ThemeProvider.secondaryColor,
              background: const Color(0xFF1A1D1F),
              surface: const Color(0xFF2A2D2F),
              onPrimary: Colors.white,
              onSecondary: Colors.black,
              onBackground: Colors.white,
              onSurface: Colors.white,
            ),
            appBarTheme: const AppBarTheme(
              backgroundColor: Color(0xFF1A1D1F),
              elevation: 0,
              iconTheme: IconThemeData(color: Colors.white),
              titleTextStyle: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          themeMode: themeProvider.themeMode,
          home: const SplashScreen(),
        );
      },
    );
  }
}