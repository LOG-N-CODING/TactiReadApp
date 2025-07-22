import 'package:flutter/material.dart';
import '../widgets/bottom_navigation_component.dart';

class AccessibilitySetupScreen extends StatefulWidget {
  const AccessibilitySetupScreen({super.key});

  @override
  State<AccessibilitySetupScreen> createState() => _AccessibilitySetupScreenState();
}

class _AccessibilitySetupScreenState extends State<AccessibilitySetupScreen> {
  bool _audioAssistanceEnabled = true;
  double _fontSize = 0.3; // 0-1 범위

  void _playAudioPreview() {
    // TODO: 실제 오디오 미리듣기 기능 구현
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Audio preview: Welcome to TactiRead'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
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
                    Container(width: 18, height: 12, child: Icon(Icons.signal_cellular_4_bar, size: 12)),
                    const SizedBox(width: 2),
                    Container(width: 21, height: 15, child: Icon(Icons.wifi, size: 15)),
                    const SizedBox(width: 2),
                    Container(width: 25, height: 12, child: Icon(Icons.battery_std, size: 12)),
                  ],
                ),
              ],
            ),
          ),
          
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 41),
              child: Column(
                children: [
                  const SizedBox(height: 80), // 124 - 44 = 80
                  
                  // Accessibility Setup 제목
                  const Text(
                    'Accessibility Setup',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                      height: 1.46,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  
                  const SizedBox(height: 80), // 245 - 165 = 80
                  
                  // Audio Assistance 토글
                  Column(
                    children: [
                      const Text(
                        'Audio Assistance',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                          height: 1.46,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Transform.scale(
                        scale: 2.0,
                        child: Switch(
                          value: _audioAssistanceEnabled,
                          onChanged: (value) {
                            setState(() {
                              _audioAssistanceEnabled = value;
                            });
                          },
                          activeColor: Colors.white,
                          activeTrackColor: Colors.black,
                          inactiveThumbColor: Colors.white,
                          inactiveTrackColor: const Color(0xFF666666),
                          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 89), // 402 - 313 = 89
                  
                  // Font size 슬라이더
                  Column(
                    children: [
                      const Text(
                        'Font size',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                          height: 1.46,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        width: 256,
                        height: 44,
                        child: SliderTheme(
                          data: SliderTheme.of(context).copyWith(
                            activeTrackColor: Colors.black,
                            inactiveTrackColor: const Color(0x66000000),
                            thumbColor: Colors.black,
                            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 22),
                            trackHeight: 12,
                            overlayShape: const RoundSliderOverlayShape(overlayRadius: 0),
                          ),
                          child: Slider(
                            value: _fontSize,
                            min: 0.0,
                            max: 1.0,
                            onChanged: (value) {
                              setState(() {
                                _fontSize = value;
                              });
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 97), // 543 - 446 = 97
                  
                  // Audio preview
                  Column(
                    children: [
                      const Text(
                        'Audio preview',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                          height: 1.46,
                        ),
                      ),
                      const SizedBox(height: 8),
                      GestureDetector(
                        onTap: _playAudioPreview,
                        child: Container(
                          width: 72,
                          height: 72,
                          decoration: const BoxDecoration(
                            color: Colors.black,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.volume_up,
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 40),
                  
                  // Continue 버튼
                  SizedBox(
                    width: 286,
                    height: 51,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacementNamed(context, '/home');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: const Text(
                        'Continue',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Inter',
                        ),
                      ),
                    ),
                  ),
                  
                  const Spacer(),
                ],
              ),
            ),
          ),
          
          // Bottom Navigation
          const BottomNavigationComponent(),
        ],
      ),
    );
  }
}
