import 'package:flutter/material.dart';

import 'screens/accessibility_setup_screen.dart';
import 'screens/audio_cue_toggle_screen.dart';
import 'screens/create_account_screen.dart';
import 'screens/device_pairing_screen.dart';
import 'screens/display_settings_screen.dart';
import 'screens/double_tap_shortcuts_screen.dart';
import 'screens/forgot_password_screen.dart';
import 'screens/help_screen.dart';
import 'screens/help_support_screen.dart';
import 'screens/home_screen.dart';
import 'screens/profile_settings_screen.dart';
import 'screens/reading_screen.dart';
import 'screens/reading_speed_control_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/sign_in_screen.dart';
import 'screens/splash_screen.dart';
import 'screens/tutorial_screen.dart';
import 'screens/update_profile_screen.dart';
import 'screens/upload_screen.dart';
import 'screens/voice_selection_screen.dart';
import 'screens/welcome_screen.dart';

void main() {
  runApp(const TactiReadApp());
}

class TactiReadApp extends StatelessWidget {
  const TactiReadApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TactiRead',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        // 접근성을 위한 큰 글자 크기
        textTheme: const TextTheme(
          headlineLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
          headlineMedium: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          bodyLarge: TextStyle(fontSize: 18),
          bodyMedium: TextStyle(fontSize: 16),
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/welcome': (context) => const WelcomeScreen(),
        '/sign_in': (context) => const SignInScreen(),
        '/create_account': (context) => const CreateAccountScreen(),
        '/forgot_password': (context) => const ForgotPasswordScreen(),
        '/accessibility_setup': (context) => const AccessibilitySetupScreen(),
        '/home': (context) => const HomeScreen(),
        '/upload': (context) => const UploadScreen(),
        '/reading': (context) => const ReadingScreen(),
        '/settings': (context) => const SettingsScreen(),
        '/device-pairing': (context) => const DevicePairingScreen(),
        '/tutorial': (context) => const TutorialScreen(),
        '/help': (context) => const HelpScreen(),
        '/help-support': (context) => const HelpSupportScreen(),
        '/display-settings': (context) => const DisplaySettingsScreen(),
        '/voice-selection': (context) => const VoiceSelectionScreen(),
        '/reading-speed-control': (context) => const ReadingSpeedControlScreen(),
        '/audio-cue-toggle': (context) => const AudioCueToggleScreen(),
        '/double-tap-shortcuts': (context) => const DoubleTapShortcutsScreen(),
        '/profile-settings': (context) => const ProfileSettingsScreen(),
        '/update-profile': (context) => const UpdateProfileScreen(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
