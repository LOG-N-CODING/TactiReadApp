import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AudioCueToggleScreen extends StatefulWidget {
  const AudioCueToggleScreen({super.key});

  @override
  State<AudioCueToggleScreen> createState() => _AudioCueToggleScreenState();
}

class _AudioCueToggleScreenState extends State<AudioCueToggleScreen> {
  bool isAudioCueEnabled = true; // Default to enabled

  void _onAudioCueToggled(bool value) async {
    setState(() {
      isAudioCueEnabled = value;
    });

    // Save setting
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isAudioCueEnabled', value);

    // 햅틱 피드백
    HapticFeedback.selectionClick();

    // 토글 상태 변경에 대한 확인 메시지
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(value ? 'Audio cues enabled' : 'Audio cues disabled'),
        duration: const Duration(milliseconds: 800),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _loadAudioSetting();
  }

  void _loadAudioSetting() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      isAudioCueEnabled = prefs.getBool('isAudioCueEnabled') ?? true;
    });
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 36.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
              // Audio Cue Title
              Text(
                'Audio Cue',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 28,
                  fontWeight: FontWeight.w400,
                  color: Theme.of(context).textTheme.titleLarge?.color,
                  height: 1.21,
                ),
              ),
              const SizedBox(height: 39), // 138 - 65 - 34 = 39
              // Main Audio Cue Toggle Setting
              Container(
                width: 306,
                padding: const EdgeInsets.symmetric(vertical: 11, horizontal: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        'Turn sounds on/off',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                          color: Theme.of(context).textTheme.bodyLarge?.color,
                          height: 1.21,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Semantics(
                      label: 'Audio cue toggle',
                      value: isAudioCueEnabled ? 'On' : 'Off',
                      onTap: () => _onAudioCueToggled(!isAudioCueEnabled),
                      child: _buildCustomSwitch(isAudioCueEnabled, _onAudioCueToggled),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // Information Section
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).brightness == Brightness.dark 
                      ? Colors.grey[800] 
                      : Colors.grey[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: Theme.of(context).brightness == Brightness.dark 
                        ? Colors.grey[600]! 
                        : Colors.grey[200]!,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.info_outline, 
                          size: 20, 
                          color: Theme.of(context).textTheme.bodyMedium?.color,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'About Audio Cues',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Theme.of(context).textTheme.titleMedium?.color,
                            height: 1.21,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Audio cues provide sound feedback for various actions and navigation.',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Theme.of(context).textTheme.bodyMedium?.color,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCustomSwitch(bool value, ValueChanged<bool> onChanged) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: Container(
        width: 60,
        height: 30,
        padding: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(32),
          color: value 
              ? (Theme.of(context).brightness == Brightness.dark 
                  ? Colors.white 
                  : Colors.black)
              : Colors.grey,
        ),
        child: AnimatedAlign(
          duration: const Duration(milliseconds: 200),
          alignment: value ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              color: Theme.of(context).brightness == Brightness.dark 
                  ? Colors.black 
                  : Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 2,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
