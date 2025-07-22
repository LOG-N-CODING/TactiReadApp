import 'package:flutter/material.dart';
import '../widgets/bottom_navigation_component.dart';
import '../services/auth_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 37),
                child: Column(
                  children: [
                    const SizedBox(height: 43), // 피그마에서 타이틀까지의 거리
                    // Settings title
                    Text(
                      'Settings',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 28,
                        fontWeight: FontWeight.w400,
                        color: Theme.of(context).textTheme.titleLarge?.color,
                        height: 1.46,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 30),

                    // Main settings container with proper spacing
                    Container(
                      width: 302,
                      child: Column(
                        children: [
                          // Display section
                          Column(
                            children: [
                              // Display header
                              Container(
                                width: double.infinity,
                                height: 44,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF4E4E4E),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Padding(
                                  padding: EdgeInsets.only(left: 23, top: 13),
                                  child: Text(
                                    'Display',
                                    style: TextStyle(
                                      fontFamily: 'Pretendard Variable',
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white,
                                      height: 1.0,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              // Dark mode link
                              GestureDetector(
                                onTap: () {
                                  Navigator.pushNamed(context, '/display-settings');
                                },
                                child: Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                  child: const Text(
                                    'Dark mode',
                                    style: TextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: 18,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.black,
                                      height: 1.46,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              // High contrast mode link
                              GestureDetector(
                                onTap: () {
                                  Navigator.pushNamed(context, '/display-settings');
                                },
                                child: Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                  child: const Text(
                                    'High contrast mode',
                                    style: TextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: 18,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.black,
                                      height: 1.46,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 41),

                          // Audio section
                          Column(
                            children: [
                              // Audio header
                              Container(
                                width: double.infinity,
                                height: 44,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF4E4E4E),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Padding(
                                  padding: EdgeInsets.only(left: 23, top: 13),
                                  child: Text(
                                    'Audio',
                                    style: TextStyle(
                                      fontFamily: 'Pretendard Variable',
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white,
                                      height: 1.0,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              // Voice selection link
                              GestureDetector(
                                onTap: () {
                                  Navigator.pushNamed(context, '/voice-selection');
                                },
                                child: Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                  child: const Text(
                                    'Voice selection',
                                    style: TextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: 18,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.black,
                                      height: 1.46,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              // Reading speed control link
                              GestureDetector(
                                onTap: () {
                                  Navigator.pushNamed(context, '/reading-speed-control');
                                },
                                child: Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                  child: const Text(
                                    'Reading speed control',
                                    style: TextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: 18,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.black,
                                      height: 1.46,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 41),

                          // Interface section
                          Column(
                            children: [
                              // Interface header
                              Container(
                                width: double.infinity,
                                height: 44,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF4E4E4E),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Padding(
                                  padding: EdgeInsets.only(left: 23, top: 13),
                                  child: Text(
                                    'Interface',
                                    style: TextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white,
                                      height: 1.21,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              // Audio cue toggle link
                              GestureDetector(
                                onTap: () {
                                  Navigator.pushNamed(context, '/audio-cue-toggle');
                                },
                                child: Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                  child: const Text(
                                    'Audio cue toggle',
                                    style: TextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: 18,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.black,
                                      height: 1.46,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              // Double-tap shortcuts link
                              GestureDetector(
                                onTap: () {
                                  Navigator.pushNamed(context, '/double-tap-shortcuts');
                                },
                                child: Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                  child: const Text(
                                    'Double-tap shortcuts',
                                    style: TextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: 18,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.black,
                                      height: 1.46,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 41),

                          // Account section
                          Column(
                            children: [
                              // Account header
                              Container(
                                width: double.infinity,
                                height: 44,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF4E4E4E),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Padding(
                                  padding: EdgeInsets.only(left: 23, top: 13),
                                  child: Text(
                                    'Account',
                                    style: TextStyle(
                                      fontFamily: 'Pretendard Variable',
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white,
                                      height: 1.0,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              // Profile link
                              GestureDetector(
                                onTap: () {
                                  Navigator.pushNamed(context, '/profile-settings');
                                },
                                child: Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                  child: const Text(
                                    'Profile',
                                    style: TextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: 18,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.black,
                                      height: 1.46,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              // Logout link
                              GestureDetector(
                                onTap: () {
                                  _showLogoutDialog();
                                },
                                child: Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                  child: const Text(
                                    'Logout',
                                    style: TextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: 18,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.black,
                                      height: 1.46,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 22), // 피그마 디자인의 하단 패딩
                  ],
                ),
              ),
            ),

            // Bottom Navigation
            const BottomNavigationComponent(currentRoute: '/settings'),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('로그아웃'),
        content: const Text('정말 로그아웃하시겠습니까?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('취소')),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);

              // 실제 로그아웃 처리
              final authService = AuthService();
              await authService.logout();

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('로그아웃되었습니다.'),
                  backgroundColor: Colors.red,
                  duration: Duration(seconds: 2),
                ),
              );

              // 로그인 화면으로 이동
              Navigator.pushNamedAndRemoveUntil(context, '/sign_in', (route) => false);
            },
            child: const Text('로그아웃'),
          ),
        ],
      ),
    );
  }
}
