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
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final blue = theme.primaryColor;
    final cardBg = isDark ? Colors.grey[800]! : (theme.cardTheme.color ?? Colors.white);
    final cardText = theme.textTheme.bodyLarge?.color ?? blue;
    final sliderActive = isDark ? Colors.white : blue;
    final sliderInactive = isDark ? Colors.grey[700]! : Colors.blue[100]!;
    final thumbColor = isDark ? Colors.white : blue;
    final overlayColor = isDark ? Colors.white.withOpacity(0.1) : blue.withOpacity(0.1);
    final labelText = theme.textTheme.bodyLarge?.color ?? blue;
    final presetSelectedBg = isDark ? Colors.white : blue;
    final presetSelectedText = isDark ? Colors.black : Colors.white;
    final presetUnselectedBg = isDark ? Colors.grey[700]! : Colors.blue[50]!;
    final presetUnselectedText = cardText;
    final presetSelectedBorder = isDark ? Colors.white : blue;
    final presetUnselectedBorder = isDark ? Colors.grey[600]! : Colors.blue[200]!;
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: theme.iconTheme.color),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
              Text(
                'Reading Speed',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 28,
                  fontWeight: FontWeight.w400,
                  color: theme.textTheme.titleLarge?.color ?? blue,
                  height: 1.21,
                ),
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: Column(
                  children: [
                    SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        activeTrackColor: sliderActive,
                        inactiveTrackColor: sliderInactive,
                        trackHeight: 6,
                        thumbColor: thumbColor,
                        thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 12),
                        overlayShape: const RoundSliderOverlayShape(overlayRadius: 20),
                        overlayColor: overlayColor,
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
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Slow',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: labelText,
                            height: 1.21,
                          ),
                        ),
                        Text(
                          'Fast',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: labelText,
                            height: 1.21,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              Center(
                child: Column(
                  children: [
                    Text(
                      'Current Speed',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: theme.textTheme.bodyMedium?.color ?? blue,
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
                        color: theme.textTheme.titleLarge?.color ?? blue,
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
                        color: theme.textTheme.bodySmall?.color ?? blue,
                        height: 1.21,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Quick Presets',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: theme.textTheme.titleMedium?.color ?? blue,
                      height: 1.21,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Column(
                    children: _speedPresets.entries.map((entry) {
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
                                color: isSelected ? presetSelectedBg : presetUnselectedBg,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: isSelected ? presetSelectedBorder : presetUnselectedBorder,
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
                                      color: isSelected ? presetSelectedText : presetUnselectedText,
                                      height: 1.21,
                                    ),
                                  ),
                                  if (isSelected)
                                    Icon(
                                      Icons.check,
                                      size: 20,
                                      color: presetSelectedText,
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
      ),
    );
  }
}
