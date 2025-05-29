import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider with ChangeNotifier {
  static const Color primaryColor = Color.fromRGBO(245, 181, 0, 1);
  static const Color primaryColorDark = Color(0xFF1F1F1F);
  static const Color primaryColorLight = Color(0xFFFFFFFF);
  static const Color secondaryColor = Color(0xFF2A2A2A);
  static const Color secondaryColorLight = Color(0xFFF5F5F5);
  static const Color accentColor = Color.fromRGBO(245, 181, 0, 1);
  static const Color backgroundColor = Color(0xFF121212);
  static const Color backgroundColorLight = Color(0xFFF5F5F5);
  static const Color cardColor = Color(0xFF1E1E1E);
  static const Color cardColorLight = Color(0xFFFFFFFF);
  static const Color textColor = Color(0xFFFFFFFF);
  static const Color textColorLight = Color(0xFF000000);
  static const Color textColorSecondary = Color(0xFFB3B3B3);
  static const Color textColorSecondaryLight = Color(0xFF666666);
  static const Color errorColor = Color(0xFFCF6679);
  static const Color successColor = Color(0xFF4CAF50);
  static const Color warningColor = Color(0xFFFFC107);
  static const Color infoColor = Color(0xFF2196F3);

  bool _isDarkMode = true;
  bool _isLoggedIn = false;

  bool get isDarkMode => _isDarkMode;
  bool get isLoggedIn => _isLoggedIn;

  ThemeProvider() {
    _loadThemePreference();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    _isLoggedIn = token != null;
    notifyListeners();
  }

  Future<void> _loadThemePreference() async {
    final prefs = await SharedPreferences.getInstance();
    _isDarkMode = prefs.getBool('isDarkMode') ?? true;
    notifyListeners();
  }

  Future<void> toggleTheme() async {
    _isDarkMode = !_isDarkMode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', _isDarkMode);
    notifyListeners();
  }

  ThemeMode get themeMode {
    if (!_isLoggedIn) {
      return ThemeMode.dark;
    }
    return _isDarkMode ? ThemeMode.dark : ThemeMode.light;
  }

  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    primaryColor: primaryColor,
    scaffoldBackgroundColor: backgroundColorLight,
    cardColor: cardColorLight,
    appBarTheme: const AppBarTheme(
      backgroundColor: backgroundColorLight,
      foregroundColor: textColorLight,
      elevation: 0,
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: textColorLight),
      bodyMedium: TextStyle(color: textColorLight),
      bodySmall: TextStyle(color: textColorSecondaryLight),
    ),
    colorScheme: ColorScheme.light(
      primary: primaryColor,
      secondary: secondaryColorLight,
      surface: cardColorLight,
      background: backgroundColorLight,
      error: errorColor,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: primaryColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.grey[300]!),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: errorColor),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: errorColor),
      ),
      labelStyle: TextStyle(color: Colors.grey[600]),
      floatingLabelStyle: TextStyle(color: primaryColor),
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    primaryColor: primaryColor,
    scaffoldBackgroundColor: backgroundColor,
    cardColor: cardColor,
    appBarTheme: const AppBarTheme(
      backgroundColor: backgroundColor,
      foregroundColor: textColor,
      elevation: 0,
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: textColor),
      bodyMedium: TextStyle(color: textColor),
      bodySmall: TextStyle(color: textColorSecondary),
    ),
    colorScheme: ColorScheme.dark(
      primary: primaryColor,
      secondary: secondaryColor,
      surface: cardColor,
      background: backgroundColor,
      error: errorColor,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: primaryColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.grey[700]!),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: errorColor),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: errorColor),
      ),
      labelStyle: TextStyle(color: Colors.grey[400]),
      floatingLabelStyle: TextStyle(color: primaryColor),
    ),
  );
} 