import 'package:flutter/material.dart';
import '../services/bluetooth_permission_service.dart';
import '../services/user_session_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    // 앱 로딩 시뮬레이션
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      // 블루투스 권한 요청
      await BluetoothPermissionService.requestBluetoothPermissions(context);

      if (mounted) {
        // 인증 상태 확인
        bool isLoggedIn = await UserSessionService.isLoggedIn();

        if (isLoggedIn) {
          // 로그인된 상태 - 튜토리얼 완료 여부 확인
          bool tutorialCompleted = await UserSessionService.isTutorialCompleted();

          if (tutorialCompleted) {
            // 튜토리얼 완료 - 홈 화면으로
            Navigator.pushReplacementNamed(context, '/home');
          } else {
            // 튜토리얼 미완료 - 튜토리얼 화면으로
            Navigator.pushReplacementNamed(context, '/tutorial');
          }
        } else {
          // 로그인되지 않은 상태 - 환영 화면으로
          Navigator.pushReplacementNamed(context, '/welcome');
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1976D2),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 앱 로고/아이콘
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Icon(Icons.touch_app, size: 60, color: Color(0xFF1976D2)),
            ),
            const SizedBox(height: 32),

            // 앱 이름
            const Text(
              'TactiRead',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 8),

            // 앱 설명
            const Text(
              'Smart reader for braille displays',
              style: TextStyle(fontSize: 16, color: Colors.white70),
            ),
            const SizedBox(height: 48),

            // 로딩 인디케이터
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
            const SizedBox(height: 16),

            const Text('Initializing...', style: TextStyle(fontSize: 14, color: Colors.white70)),
          ],
        ),
      ),
    );
  }
}
