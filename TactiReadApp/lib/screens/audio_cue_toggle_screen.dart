import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AudioCueToggleScreen extends StatefulWidget {
  const AudioCueToggleScreen({super.key});

  @override
  State<AudioCueToggleScreen> createState() => _AudioCueToggleScreenState();
}

class _AudioCueToggleScreenState extends State<AudioCueToggleScreen> {
  bool isAudioCueEnabled = true; // Default to enabled
  double audioVolume = 0.7; // Default volume level (70%)

  // Audio cue types
  Map<String, bool> audioCueTypes = {
    'Button Sounds': true,
    'Navigation Sounds': true,
    'Reading Progress': false,
    'Alert Sounds': true,
  };

  void _onAudioCueToggled(bool value) {
    setState(() {
      isAudioCueEnabled = value;
      // If disabling audio cues, turn off all types
      if (!value) {
        audioCueTypes.updateAll((key, value) => false);
      } else {
        // If enabling, restore default settings
        audioCueTypes = {
          'Button Sounds': true,
          'Navigation Sounds': true,
          'Reading Progress': false,
          'Alert Sounds': true,
        };
      }
    });

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

  void _onAudioTypeToggled(String type, bool value) {
    setState(() {
      audioCueTypes[type] = value;
    });

    HapticFeedback.lightImpact();
  }

  void _onVolumeChanged(double value) {
    setState(() {
      audioVolume = value;
    });

    HapticFeedback.selectionClick();
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 36.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
              // Audio Cue Title
              const Text(
                'Audio Cue',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 28,
                  fontWeight: FontWeight.w400,
                  color: Colors.black,
                  height: 1.21,
                ),
              ),
              const SizedBox(height: 39), // 138 - 65 - 34 = 39
              // Main Audio Cue Toggle Setting
              Container(
                width: 306,
                padding: const EdgeInsets.symmetric(
                  vertical: 11,
                  horizontal: 4,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Expanded(
                      child: Text(
                        'Turn sounds on/off',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                          height: 1.21,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Semantics(
                      label: 'Audio cue toggle',
                      value: isAudioCueEnabled ? 'On' : 'Off',
                      onTap: () => _onAudioCueToggled(!isAudioCueEnabled),
                      child: _buildCustomSwitch(
                        isAudioCueEnabled,
                        _onAudioCueToggled,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // Volume Control (only shown when audio cues are enabled)
              if (isAudioCueEnabled) ...[
                Text(
                  'Volume',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                    height: 1.21,
                  ),
                ),
                const SizedBox(height: 16),
                SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    activeTrackColor: Colors.black,
                    inactiveTrackColor: Colors.grey[300],
                    trackHeight: 4,
                    thumbColor: Colors.black,
                    thumbShape: const RoundSliderThumbShape(
                      enabledThumbRadius: 10,
                    ),
                    overlayShape: const RoundSliderOverlayShape(
                      overlayRadius: 16,
                    ),
                    overlayColor: Colors.black.withOpacity(0.1),
                  ),
                  child: Semantics(
                    label: 'Audio volume control',
                    value: '${(audioVolume * 100).round()} percent',
                    child: Slider(
                      value: audioVolume,
                      onChanged: _onVolumeChanged,
                      min: 0.0,
                      max: 1.0,
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Quiet',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                    Text(
                      'Loud',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),

                // Audio Cue Types
                Text(
                  'Sound Types',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                    height: 1.21,
                  ),
                ),
                const SizedBox(height: 16),

                ...audioCueTypes.entries
                    .map(
                      (entry) => Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                entry.key,
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black,
                                  height: 1.21,
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Semantics(
                              label: '${entry.key} toggle',
                              value: entry.value ? 'On' : 'Off',
                              onTap: () =>
                                  _onAudioTypeToggled(entry.key, !entry.value),
                              child: _buildSmallSwitch(
                                entry.value,
                                (value) =>
                                    _onAudioTypeToggled(entry.key, value),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                    .toList(),

                const SizedBox(height: 24),

                // Test Sound Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // Play test sound
                      HapticFeedback.mediumImpact();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('🔊 Test sound played'),
                          duration: Duration(milliseconds: 1000),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                    icon: const Icon(Icons.volume_up),
                    label: const Text('Test Sound'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 32),
              ],

              // Information Section
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey[200]!),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          size: 20,
                          color: Colors.grey[600],
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'About Audio Cues',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey[800],
                            height: 1.21,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Audio cues provide sound feedback for various actions and navigation. This includes button taps, page transitions, and reading progress indicators.',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey[600],
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
          border: Border.all(color: Colors.black, width: 1),
          color: value ? Colors.black : Colors.white,
        ),
        child: AnimatedAlign(
          duration: const Duration(milliseconds: 200),
          alignment: value ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              color: Colors.white,
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

  Widget _buildSmallSwitch(bool value, ValueChanged<bool> onChanged) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: Container(
        width: 50,
        height: 24,
        padding: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.grey[400]!, width: 1),
          color: value ? Colors.black : Colors.white,
        ),
        child: AnimatedAlign(
          duration: const Duration(milliseconds: 200),
          alignment: value ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            width: 16,
            height: 16,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 1,
                  offset: const Offset(0, 0.5),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
