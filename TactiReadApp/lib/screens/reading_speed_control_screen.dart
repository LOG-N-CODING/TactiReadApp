import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReadingSpeedControlScreen extends StatefulWidget {
  const ReadingSpeedControlScreen({super.key});

  @override
  State<ReadingSpeedControlScreen> createState() => _ReadingSpeedControlScreenState();
}

class _ReadingSpeedControlScreenState extends State<ReadingSpeedControlScreen> {
  double _currentSpeed = 0.3; // Default to 0.3 (60% of 0.1-0.5 range)

  // Predefined speed presets (adjusted to 0.1-0.5 range)
  final Map<String, double> _speedPresets = {
    'Very Fast': 0.5,
    'Fast': 0.4,
    'Normal': 0.3,
    'Slow': 0.2,
    'Very Slow': 0.1,
  };

  @override
  void initState() {
    super.initState();
    _loadReadingSpeed();
  }

  // SharedPreferences에서 읽기 속도 로드
  Future<void> _loadReadingSpeed() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      double savedSpeed = prefs.getDouble('reading_speed') ?? 0.3;
      // 새로운 범위(0.1-0.5)에 맞게 값 제한
      _currentSpeed = savedSpeed.clamp(0.1, 0.5);

      // 만약 저장된 값이 범위를 벗어났다면 새로운 값으로 저장
      if (savedSpeed != _currentSpeed) {
        _saveReadingSpeed(_currentSpeed);
      }
    });
  }

  // SharedPreferences에 읽기 속도 저장
  Future<void> _saveReadingSpeed(double speed) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('reading_speed', speed);
  }

  void _onSpeedChanged(double value) {
    setState(() {
      _currentSpeed = value;
    });

    // SharedPreferences에 저장
    _saveReadingSpeed(value);

    // 햅틱 피드백
    HapticFeedback.selectionClick();
  }

  void _setPresetSpeed(double speed) {
    setState(() {
      _currentSpeed = speed;
    });

    // SharedPreferences에 저장
    _saveReadingSpeed(speed);

    // 햅틱 피드백
    HapticFeedback.lightImpact();
  }

  String _getSpeedDescription() {
    if (_currentSpeed <= 0.15) return 'Very Slow';
    if (_currentSpeed <= 0.25) return 'Slow';
    if (_currentSpeed <= 0.35) return 'Normal';
    if (_currentSpeed <= 0.45) return 'Fast';
    return 'Very Fast';
  }

  int _getWordsPerMinute() {
    // Convert slider value (0.1-0.5) to words per minute (50-150 WPM)
    return (50 + ((_currentSpeed - 0.1) / 0.4 * 100)).round();
  }

  // 현재 속도가 어떤 preset 범위에 속하는지 확인
  bool _isInPresetRange(String presetName) {
    switch (presetName) {
      case 'Very Slow':
        return _currentSpeed <= 0.15;
      case 'Slow':
        return _currentSpeed > 0.15 && _currentSpeed <= 0.25;
      case 'Normal':
        return _currentSpeed > 0.25 && _currentSpeed <= 0.35;
      case 'Fast':
        return _currentSpeed > 0.35 && _currentSpeed <= 0.45;
      case 'Very Fast':
        return _currentSpeed > 0.45;
      default:
        return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Theme.of(context).iconTheme.color),
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
            Text(
              'Reading Speed',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 28,
                fontWeight: FontWeight.w400,
                color: Theme.of(context).textTheme.titleLarge?.color,
                height: 1.21,
              ),
            ),
            const SizedBox(height: 98), // 197 - 65 - 34 = 98
            // Custom Slider
            SizedBox(
              width: double.infinity,
              child: Column(
                children: [
                  // Slider with custom styling
                  SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      activeTrackColor: Theme.of(context).brightness == Brightness.dark
                          ? Colors.white
                          : const Color(0xFF4D4D4D),
                      inactiveTrackColor: Theme.of(context).brightness == Brightness.dark
                          ? Colors.grey.shade700
                          : const Color(0xFFE6E6E6),
                      trackHeight: 6,
                      thumbColor: Theme.of(context).brightness == Brightness.dark
                          ? Colors.white
                          : const Color(0xFF4D4D4D),
                      thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 12),
                      overlayShape: const RoundSliderOverlayShape(overlayRadius: 20),
                      overlayColor:
                          (Theme.of(context).brightness == Brightness.dark
                                  ? Colors.white
                                  : const Color(0xFF4D4D4D))
                              .withOpacity(0.1),
                      trackShape: const RoundedRectSliderTrackShape(),
                    ),
                    child: Semantics(
                      label: 'Reading speed control',
                      value: '${(_currentSpeed * 100).round()} percent, ${_getSpeedDescription()}',
                      child: Slider(
                        value: _currentSpeed,
                        onChanged: _onSpeedChanged,
                        min: 0.1,
                        max: 0.5,
                      ),
                    ),
                  ),

                  const SizedBox(height: 16), // Adjust spacing for better alignment
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
                          color: Theme.of(context).textTheme.bodyLarge?.color,
                          height: 1.21,
                        ),
                      ),
                      Text(
                        'Fast',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: Theme.of(context).textTheme.bodyLarge?.color,
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
                      color: Theme.of(context).textTheme.bodyMedium?.color,
                      height: 1.21,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _getSpeedDescription(),
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: Theme.of(context).textTheme.titleLarge?.color,
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
                      color: Theme.of(context).textTheme.bodySmall?.color,
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
                    color: Theme.of(context).textTheme.titleMedium?.color,
                    height: 1.21,
                  ),
                ),
                const SizedBox(height: 16),
                Column(
                  children: _speedPresets.entries.map((entry) {
                    // 범위 기반으로 선택 상태 결정
                    bool isSelected = _isInPresetRange(entry.key);
                    return Container(
                      width: double.infinity,
                      margin: const EdgeInsets.only(bottom: 8),
                      child: Semantics(
                        label: '${entry.key} reading speed preset',
                        value: isSelected ? 'Selected' : 'Not selected',
                        button: true,
                        onTap: () => _setPresetSpeed(entry.value),
                        child: GestureDetector(
                          onTap: () => _setPresetSpeed(entry.value),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? (Theme.of(context).brightness == Brightness.dark
                                        ? Colors.white
                                        : Colors.black)
                                  : (Theme.of(context).brightness == Brightness.dark
                                        ? Colors.grey[700]
                                        : Colors.grey[200]),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: isSelected
                                    ? (Theme.of(context).brightness == Brightness.dark
                                          ? Colors.white
                                          : Colors.black)
                                    : (Theme.of(context).brightness == Brightness.dark
                                          ? Colors.grey[600]!
                                          : Colors.grey[400]!),
                                width: 1,
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  entry.key,
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: isSelected
                                        ? (Theme.of(context).brightness == Brightness.dark
                                              ? Colors.black
                                              : Colors.white)
                                        : Theme.of(context).textTheme.bodyMedium?.color,
                                    height: 1.21,
                                  ),
                                ),
                                if (isSelected)
                                  Icon(
                                    Icons.check,
                                    size: 20,
                                    color: Theme.of(context).brightness == Brightness.dark
                                        ? Colors.black
                                        : Colors.white,
                                  ),
                              ],
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
