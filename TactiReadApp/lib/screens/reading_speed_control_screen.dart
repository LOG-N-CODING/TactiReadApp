import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ReadingSpeedControlScreen extends StatefulWidget {
  const ReadingSpeedControlScreen({super.key});

  @override
  State<ReadingSpeedControlScreen> createState() =>
      _ReadingSpeedControlScreenState();
}

class _ReadingSpeedControlScreenState extends State<ReadingSpeedControlScreen> {
  double _currentSpeed = 0.5; // Default to middle position (50%)

  // Predefined speed presets
  final Map<String, double> _speedPresets = {
    'Very Slow': 0.1,
    'Slow': 0.3,
    'Normal': 0.5,
    'Fast': 0.7,
    'Very Fast': 0.9,
  };

  void _onSpeedChanged(double value) {
    setState(() {
      _currentSpeed = value;
    });

    // 햅틱 피드백
    HapticFeedback.selectionClick();
  }

  void _setPresetSpeed(double speed) {
    setState(() {
      _currentSpeed = speed;
    });

    // 햅틱 피드백
    HapticFeedback.lightImpact();
  }

  String _getSpeedDescription() {
    if (_currentSpeed <= 0.2) return 'Very Slow';
    if (_currentSpeed <= 0.4) return 'Slow';
    if (_currentSpeed <= 0.6) return 'Normal';
    if (_currentSpeed <= 0.8) return 'Fast';
    return 'Very Fast';
  }

  int _getWordsPerMinute() {
    // Convert slider value (0-1) to words per minute (50-250 WPM)
    return (50 + (_currentSpeed * 200)).round();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 24),
            // Reading Speed Title
            const Text(
              'Reading Speed',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 28,
                fontWeight: FontWeight.w400,
                color: Colors.black,
                height: 1.21,
              ),
            ),
            const SizedBox(height: 98), // 197 - 65 - 34 = 98
            // Custom Slider
            SizedBox(
              width: 295,
              child: Column(
                children: [
                  // Slider with custom styling
                  SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      activeTrackColor: const Color(0xFF4D4D4D),
                      inactiveTrackColor: const Color(0xFFE6E6E6),
                      trackHeight: 6,
                      thumbColor: const Color(0xFF4D4D4D),
                      thumbShape: const RoundSliderThumbShape(
                        enabledThumbRadius: 12,
                      ),
                      overlayShape: const RoundSliderOverlayShape(
                        overlayRadius: 20,
                      ),
                      overlayColor: const Color(0xFF4D4D4D).withOpacity(0.1),
                      trackShape: const RoundedRectSliderTrackShape(),
                    ),
                    child: Semantics(
                      label: 'Reading speed control',
                      value:
                          '${(_currentSpeed * 100).round()} percent, ${_getSpeedDescription()}',
                      child: Slider(
                        value: _currentSpeed,
                        onChanged: _onSpeedChanged,
                        min: 0.0,
                        max: 1.0,
                      ),
                    ),
                  ),

                  const SizedBox(
                    height: 16,
                  ), // Adjust spacing for better alignment
                  // Slow and Fast Labels
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Slow',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                          height: 1.21,
                        ),
                      ),
                      Text(
                        'Fast',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                          height: 1.21,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),

            // Current Speed Display
            Center(
              child: Column(
                children: [
                  Text(
                    'Current Speed',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: Colors.grey[600],
                      height: 1.21,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _getSpeedDescription(),
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                      height: 1.21,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${_getWordsPerMinute()} words per minute',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Colors.grey[500],
                      height: 1.21,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),

            // Speed Presets
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Quick Presets',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                    height: 1.21,
                  ),
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _speedPresets.entries.map((entry) {
                    bool isSelected =
                        (_currentSpeed - entry.value).abs() < 0.05;
                    return Semantics(
                      label: '${entry.key} reading speed preset',
                      value: isSelected ? 'Selected' : 'Not selected',
                      button: true,
                      onTap: () => _setPresetSpeed(entry.value),
                      child: GestureDetector(
                        onTap: () => _setPresetSpeed(entry.value),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected ? Colors.black : Colors.grey[200],
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: isSelected
                                  ? Colors.black
                                  : Colors.grey[400]!,
                              width: 1,
                            ),
                          ),
                          child: Text(
                            entry.key,
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: isSelected ? Colors.white : Colors.black,
                              height: 1.21,
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
