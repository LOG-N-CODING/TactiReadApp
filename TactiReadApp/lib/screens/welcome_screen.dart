import 'package:flutter/material.dart';
import '../widgets/bottom_navigation_component.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 41),
            child: Column(
              children: [
                // Status Bar
                Container(
                  height: 44,
                  padding: const EdgeInsets.symmetric(horizontal: 21),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        '9:27',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                      Row(
                        children: [
                          // 신호, WiFi, 배터리 아이콘들
                          const SizedBox(
                            width: 18,
                            height: 12,
                            child: Icon(Icons.signal_cellular_4_bar, size: 12),
                          ),
                          const SizedBox(width: 2),
                          const SizedBox(width: 21, height: 15, child: Icon(Icons.wifi, size: 15)),
                          const SizedBox(width: 2),
                          const SizedBox(
                            width: 25,
                            height: 12,
                            child: Icon(Icons.battery_std, size: 12),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                SizedBox(height: MediaQuery.of(context).size.height * 0.1),
                // TactiRead 제목
                const Text(
                  'TactiRead',
                  style: TextStyle(
                    fontSize: 44,
                    fontWeight: FontWeight.w400,
                    color: Colors.black,
                    height: 1.46,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 8),
                // Read Beyond Limits 부제목
                const Text(
                  'Read Beyond Limits',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w400,
                    color: Colors.black,
                    height: 1.46,
                  ),
                  textAlign: TextAlign.center,
                ),

                SizedBox(height: MediaQuery.of(context).size.height * 0.08),
                // Sign In 버튼
                GestureDetector(
                  onTap: () => Navigator.pushNamed(context, '/sign_in'),
                  child: Container(
                    width: 286,
                    height: 51,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: const Color(0xFFB0B0B0)),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Center(
                      child: Text(
                        'Sign In',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                          height: 1.46,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 16),
                // Create Account 버튼
                GestureDetector(
                  onTap: () => Navigator.pushNamed(context, '/create_account'),
                  child: Container(
                    width: 286,
                    height: 51,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: const Color(0xFFB0B0B0)),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Center(
                      child: Text(
                        'Create Account',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                          height: 1.46,
                        ),
                      ),
                    ),
                  ),
                ),

                SizedBox(height: MediaQuery.of(context).size.height * 0.06),
                // Audio Assistant 토글
                Column(
                  children: [
                    const Text(
                      'Audio Assistant',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                        color: Colors.black,
                        height: 1.46,
                      ),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      width: 120,
                      height: 60,
                      child: Stack(
                        children: [
                          Container(
                            width: 120,
                            height: 60,
                            decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(80),
                            ),
                          ),
                          Positioned(
                            right: 8,
                            top: 8,
                            child: Container(
                              width: 44,
                              height: 44,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                SizedBox(height: MediaQuery.of(context).size.height * 0.08),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: const BottomNavigationComponent(currentRoute: '/welcome'),
    );
  }
}
