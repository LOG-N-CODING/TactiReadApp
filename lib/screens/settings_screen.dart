import 'package:flutter/material.dart';
import '../widgets/bottom_navigation_component.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 39),
                child: Column(
                  children: [
                    const SizedBox(height: 65),
                    
                    // Settings title
                    const Text(
                      'Settings',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 28,
                        fontWeight: FontWeight.w400,
                        color: Colors.black,
                        height: 1.46,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    
                    const SizedBox(height: 30),
                    
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
                        // Dot height link
                        GestureDetector(
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Dot height 설정으로 이동합니다.'),
                                backgroundColor: Colors.blue,
                                duration: Duration(seconds: 2),
                              ),
                            );
                          },
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            child: const Text(
                              'Dot height',
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
                        // Graphic detail link
                        GestureDetector(
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Graphic detail 설정으로 이동합니다.'),
                                backgroundColor: Colors.blue,
                                duration: Duration(seconds: 2),
                              ),
                            );
                          },
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            child: const Text(
                              'Graphic detail',
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
                    
                    const SizedBox(height: 30),
                    
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
                        // Narration voice link
                        GestureDetector(
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Narration voice 설정으로 이동합니다.'),
                                backgroundColor: Colors.blue,
                                duration: Duration(seconds: 2),
                              ),
                            );
                          },
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            child: const Text(
                              'Narration voice',
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
                        // Speed link
                        GestureDetector(
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Speed 설정으로 이동합니다.'),
                                backgroundColor: Colors.blue,
                                duration: Duration(seconds: 2),
                              ),
                            );
                          },
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            child: const Text(
                              'Speed',
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

                    const SizedBox(height: 30),

                    // Connectivity section
                    Column(
                      children: [
                        // Connectivity header
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
                              'Connectivity',
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
                        // Device Pairing link
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, '/device_pairing');
                          },
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            child: const Text(
                              'Device Pairing',
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

                    const SizedBox(height: 30),

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
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Profile 설정으로 이동합니다.'),
                                backgroundColor: Colors.blue,
                                duration: Duration(seconds: 2),
                              ),
                            );
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
                    
                    const SizedBox(height: 30),
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
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('취소'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('로그아웃되었습니다.'),
                  backgroundColor: Colors.red,
                  duration: Duration(seconds: 2),
                ),
              );
            },
            child: const Text('로그아웃'),
          ),
        ],
      ),
    );
  }
}
