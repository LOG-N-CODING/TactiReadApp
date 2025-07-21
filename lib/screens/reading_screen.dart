import 'package:flutter/material.dart';
import '../widgets/bottom_navigation_component.dart';

class ReadingScreen extends StatefulWidget {
  const ReadingScreen({super.key});

  @override
  State<ReadingScreen> createState() => _ReadingScreenState();
}

class _ReadingScreenState extends State<ReadingScreen> {
  double _readingSpeed = 0.3; // 0.0 to 1.0
  double _dotHeight = 0.3; // 0.0 to 1.0
  bool _voiceGuidance = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: 
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 40),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            // File title
                            const Text(
                              'File title',
                              style: TextStyle(
                                fontFamily: 'Pretendard Variable',
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF505050),
                                height: 1.0,
                              ),
                            ),
                            
                            const SizedBox(height: 26),
                            
                            // Device status
                            const Text(
                              'Device status',
                              style: TextStyle(
                                fontFamily: 'Pretendard Variable',
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF505050),
                                height: 1.0,
                              ),
                            ),

                          ],
                        ),
                        // Start Reading button (centered)
                        Center(
                          child: GestureDetector(
                            onTap: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('읽기를 시작합니다.'),
                                  backgroundColor: Colors.green,
                                  duration: Duration(seconds: 2),
                                ),
                              );
                            },
                            child: Container(
                              width: 165,
                              height: 44,
                              decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Center(
                                child: Text(
                                  'Start Reading',
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
                          ),
                        ),

                      ],
                    ),
                    
                    const SizedBox(height: 30),
                    
                    // Start Reading button and navigation buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Previous page button
                        GestureDetector(
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('이전 페이지로 이동합니다.'),
                                backgroundColor: Colors.blue,
                                duration: Duration(seconds: 2),
                              ),
                            );
                          },
                          child: Container(
                            width: 142,
                            height: 44,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: const Color(0xFFB0B0B0)),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Center(
                              child: Text(
                                'Previous page',
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black,
                                  height: 1.21,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                        
                        const SizedBox(width: 12),
                        
                        // Next page button
                        GestureDetector(
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('다음 페이지로 이동합니다.'),
                                backgroundColor: Colors.blue,
                                duration: Duration(seconds: 2),
                              ),
                            );
                          },
                          child: Container(
                            width: 142,
                            height: 44,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: const Color(0xFFB0B0B0)),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Center(
                              child: Text(
                                'Next page',
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black,
                                  height: 1.21,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 40),
                    
                    // Dot height slider
                    Center(
                      child: Column(
                      children: [
                        const Text(
                        'Dot height',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                          height: 1.46,
                        ),
                        textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        SizedBox(
                        width: 256,
                        height: 44,
                        child: Stack(
                          children: [
                          // Background track
                          Positioned(
                            left: 0,
                            top: 16,
                            child: Container(
                            width: 256,
                            height: 12,
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.4),
                              borderRadius: BorderRadius.circular(80),
                            ),
                            ),
                          ),
                          // Active track
                          Positioned(
                            left: 0,
                            top: 16,
                            child: Container(
                            width: 256 * _dotHeight,
                            height: 12,
                            decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(80),
                            ),
                            ),
                          ),
                          // Thumb
                          Positioned(
                            left: (256 - 44) * _dotHeight,
                            top: 0,
                            child: Container(
                            width: 44,
                            height: 44,
                            decoration: const BoxDecoration(
                              color: Colors.black,
                              shape: BoxShape.circle,
                            ),
                            ),
                          ),
                          // Invisible slider for interaction
                          SliderTheme(
                            data: SliderTheme.of(context).copyWith(
                            trackHeight: 44,
                            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 22),
                            overlayShape: SliderComponentShape.noOverlay,
                            activeTrackColor: Colors.transparent,
                            inactiveTrackColor: Colors.transparent,
                            thumbColor: Colors.transparent,
                            ),
                            child: Slider(
                            value: _dotHeight,
                            onChanged: (value) {
                              setState(() {
                              _dotHeight = value;
                              });
                            },
                            ),
                          ),
                          ],
                        ),
                        ),
                      ],
                      ),
                    ),

                    const SizedBox(height: 50),

                    // Reading speed slider
                    Center(
                      child: Column(
                      children: [
                        const Text(
                        'Reading speed',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                          height: 1.46,
                        ),
                        textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        SizedBox(
                        width: 256,
                        height: 44,
                        child: Stack(
                          children: [
                          // Background track
                          Positioned(
                            left: 0,
                            top: 16,
                            child: Container(
                            width: 256,
                            height: 12,
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.4),
                              borderRadius: BorderRadius.circular(80),
                            ),
                            ),
                          ),
                          // Active track
                          Positioned(
                            left: 0,
                            top: 16,
                            child: Container(
                            width: 256 * _readingSpeed,
                            height: 12,
                            decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(80),
                            ),
                            ),
                          ),
                          // Thumb
                          Positioned(
                            left: (256 - 44) * _readingSpeed,
                            top: 0,
                            child: Container(
                            width: 44,
                            height: 44,
                            decoration: const BoxDecoration(
                              color: Colors.black,
                              shape: BoxShape.circle,
                            ),
                            ),
                          ),
                          // Invisible slider for interaction
                          SliderTheme(
                            data: SliderTheme.of(context).copyWith(
                            trackHeight: 44,
                            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 22),
                            overlayShape: SliderComponentShape.noOverlay,
                            activeTrackColor: Colors.transparent,
                            inactiveTrackColor: Colors.transparent,
                            thumbColor: Colors.transparent,
                            ),
                            child: Slider(
                            value: _readingSpeed,
                            onChanged: (value) {
                              setState(() {
                              _readingSpeed = value;
                              });
                            },
                            ),
                          ),
                          ],
                        ),
                        ),
                      ],
                      ),
                    ),
                    
                    const SizedBox(height: 50),
                    
                    // Voice guidance toggle
                    Center(
                      child: Column(
                        children: [
                          const Text(
                            'graphics',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 18,
                              fontWeight: FontWeight.w400,
                              color: Colors.black,
                              height: 1.46,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 8),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _voiceGuidance = !_voiceGuidance;
                              });
                            },
                            child: Container(
                              width: 120,
                              height: 60,
                              decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(80),
                              ),
                              child: Stack(
                                children: [
                                  AnimatedPositioned(
                                    duration: const Duration(milliseconds: 200),
                                    left: _voiceGuidance ? 68 : 8,
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
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
            
            // Bottom Navigation
            const BottomNavigationComponent(currentRoute: '/reading'),
          ],
        ),
      ),
    );
  }
}
