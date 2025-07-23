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
                padding: const EdgeInsets.symmetric(horizontal: 14),
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

                    // Main settings list
                    Column(
                      children: [
                        // Display section
                        _buildSectionHeader('Display'),
                        Card(
                          margin: const EdgeInsets.symmetric(horizontal: 8),
                          elevation: 2,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          child: Column(
                            children: [
                              ListTile(
                                leading: Icon(
                                  Icons.dark_mode,
                                  color: Theme.of(context).primaryColor,
                                ),
                                title: const Text(
                                  'Dark mode',
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                trailing: const Icon(Icons.chevron_right),
                                onTap: () {
                                  Navigator.pushNamed(context, '/display-settings');
                                },
                              ),
                              const Divider(height: 1),
                              ListTile(
                                leading: Icon(
                                  Icons.contrast,
                                  color: Theme.of(context).primaryColor,
                                ),
                                title: const Text(
                                  'High contrast mode',
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                trailing: const Icon(Icons.chevron_right),
                                onTap: () {
                                  Navigator.pushNamed(context, '/display-settings');
                                },
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 32),

                        // Audio section
                        _buildSectionHeader('Audio'),
                        Card(
                          margin: const EdgeInsets.symmetric(horizontal: 8),
                          elevation: 2,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          child: Column(
                            children: [
                              ListTile(
                                leading: Icon(
                                  Icons.record_voice_over,
                                  color: Theme.of(context).primaryColor,
                                ),
                                title: const Text(
                                  'Voice selection',
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                trailing: const Icon(Icons.chevron_right),
                                onTap: () {
                                  Navigator.pushNamed(context, '/voice-selection');
                                },
                              ),
                              const Divider(height: 1),
                              ListTile(
                                leading: Icon(Icons.speed, color: Theme.of(context).primaryColor),
                                title: const Text(
                                  'Reading speed control',
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                trailing: const Icon(Icons.chevron_right),
                                onTap: () {
                                  Navigator.pushNamed(context, '/reading-speed-control');
                                },
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 32),

                        // Interface section
                        _buildSectionHeader('Interface'),
                        Card(
                          margin: const EdgeInsets.symmetric(horizontal: 8),
                          elevation: 2,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          child: Column(
                            children: [
                              ListTile(
                                leading: Icon(
                                  Icons.volume_up,
                                  color: Theme.of(context).primaryColor,
                                ),
                                title: const Text(
                                  'Audio cue toggle',
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                trailing: const Icon(Icons.chevron_right),
                                onTap: () {
                                  Navigator.pushNamed(context, '/audio-cue-toggle');
                                },
                              ),
                              const Divider(height: 1),
                              ListTile(
                                leading: Icon(
                                  Icons.touch_app,
                                  color: Theme.of(context).primaryColor,
                                ),
                                title: const Text(
                                  'Double-tap shortcuts',
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                trailing: const Icon(Icons.chevron_right),
                                onTap: () {
                                  Navigator.pushNamed(context, '/double-tap-shortcuts');
                                },
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 32),

                        // Account section
                        _buildSectionHeader('Account'),
                        Card(
                          margin: const EdgeInsets.symmetric(horizontal: 8),
                          elevation: 2,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          child: Column(
                            children: [
                              ListTile(
                                leading: Icon(Icons.person, color: Theme.of(context).primaryColor),
                                title: const Text(
                                  'Profile',
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                trailing: const Icon(Icons.chevron_right),
                                onTap: () {
                                  Navigator.pushNamed(context, '/profile-settings');
                                },
                              ),
                              const Divider(height: 1),
                              ListTile(
                                leading: const Icon(Icons.logout, color: Colors.red),
                                title: const Text(
                                  'Logout',
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.red,
                                  ),
                                ),
                                trailing: const Icon(Icons.chevron_right, color: Colors.red),
                                onTap: () {
                                  _showLogoutDialog();
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
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

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: TextStyle(
            fontFamily: 'Pretendard Variable',
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Theme.of(context).textTheme.titleMedium?.color,
            height: 1.2,
          ),
        ),
      ),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);

              // 실제 로그아웃 처리
              final authService = AuthService();
              await authService.logout();

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Logged out successfully.'),
                  backgroundColor: Colors.red,
                  duration: Duration(seconds: 2),
                ),
              );

              // 로그인 화면으로 이동
              Navigator.pushNamedAndRemoveUntil(context, '/sign_in', (route) => false);
            },
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}
