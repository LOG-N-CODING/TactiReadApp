import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeService extends ChangeNotifier {
  static final ThemeService _instance = ThemeService._internal();
  factory ThemeService() => _instance;
  ThemeService._internal();

  bool _isDarkMode = false;
  bool _isHighContrast = false;

  bool get isDarkMode => _isDarkMode;
  bool get isHighContrast => _isHighContrast;

  // Initialize theme settings from storage
  Future<void> initializeTheme() async {
    final prefs = await SharedPreferences.getInstance();
    _isDarkMode = prefs.getBool('isDarkMode') ?? false;
    _isHighContrast = prefs.getBool('isHighContrast') ?? false;
    notifyListeners();
  }

  // Toggle dark mode
  Future<void> toggleDarkMode() async {
    _isDarkMode = !_isDarkMode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', _isDarkMode);
    notifyListeners();
  }

  // Toggle high contrast mode
  Future<void> toggleHighContrast() async {
    _isHighContrast = !_isHighContrast;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isHighContrast', _isHighContrast);
    notifyListeners();
  }

  // Get current theme data
  ThemeData getThemeData() {
    if (_isHighContrast) {
      return _highContrastTheme();
    } else if (_isDarkMode) {
      return _darkTheme();
    } else {
      return _lightTheme();
    }
  }

  // Get current theme with initialization
  Future<ThemeData> getCurrentTheme() async {
    await initializeTheme();
    return getThemeData();
  }

  ThemeData _lightTheme() {
    return ThemeData(
      brightness: Brightness.light,
      primaryColor: Colors.blue,
      colorScheme: ColorScheme.light(
        primary: Colors.blue,
        secondary: Colors.blueAccent,
        background: Colors.blue[50]!,
        surface: Colors.white,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onBackground: Colors.blue,
        onSurface: Colors.blue,
      ),
      scaffoldBackgroundColor: Colors.blue[50],
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: Colors.blue, fontSize: 18),
        bodyMedium: TextStyle(color: Colors.blue, fontSize: 16),
        titleLarge: TextStyle(color: Colors.blue, fontSize: 28, fontWeight: FontWeight.bold),
        titleMedium: TextStyle(color: Colors.blue, fontSize: 24, fontWeight: FontWeight.bold),
        titleSmall: TextStyle(color: Colors.blue, fontSize: 20, fontWeight: FontWeight.bold),
      ),
      cardTheme: CardThemeData(color: Colors.white, elevation: 2, shadowColor: Colors.blue[100]),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
        ),
      ),
      iconTheme: const IconThemeData(color: Colors.blue),
      dividerColor: Colors.blue[100],
    );
  }

  ThemeData _darkTheme() {
    return ThemeData(
      brightness: Brightness.dark,
      primarySwatch: Colors.grey,
      scaffoldBackgroundColor: Colors.grey[900],
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.grey[900],
        foregroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: Colors.white, fontSize: 18),
        bodyMedium: TextStyle(color: Colors.white, fontSize: 16),
        titleLarge: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
        titleMedium: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
        titleSmall: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
      ),
      cardTheme: CardThemeData(color: Colors.grey[800], elevation: 2, shadowColor: Colors.black),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
        ),
      ),
      iconTheme: const IconThemeData(color: Colors.white),
      dividerColor: Colors.grey[600],
    );
  }

  ThemeData _highContrastTheme() {
    return ThemeData(
      brightness: Brightness.light,
      primarySwatch: Colors.grey,
      scaffoldBackgroundColor: Colors.white,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
        bodyMedium: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16),
        titleLarge: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 28),
        titleMedium: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 24),
        titleSmall: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20),
      ),
      cardTheme: CardThemeData(color: Colors.white, elevation: 4, shadowColor: Colors.black),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
          side: const BorderSide(color: Colors.black, width: 2),
        ),
      ),
      iconTheme: const IconThemeData(color: Colors.black),
      dividerColor: Colors.black,
    );
  }
}
