import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class VoiceSelectionScreen extends StatefulWidget {
  const VoiceSelectionScreen({super.key});

  @override
  State<VoiceSelectionScreen> createState() => _VoiceSelectionScreenState();
}

class _VoiceSelectionScreenState extends State<VoiceSelectionScreen> {
  String selectedVoiceType = 'Male'; // Default selection based on Figma design

  final List<String> voiceTypes = ['Male', 'Female', 'Robotic'];

  void _onVoiceSelected(String voiceType) {
    setState(() {
      selectedVoiceType = voiceType;
    });

    // 햅틱 피드백
    HapticFeedback.selectionClick();

    // 선택된 음성에 대한 확인 메시지 (선택적)
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$voiceType voice selected'),
        duration: const Duration(milliseconds: 800),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
      ),
    );
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
            // Voice Selection Title
            const Text(
              'Voice Selection',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 28,
                fontWeight: FontWeight.w400,
                color: Colors.black,
                height: 1.21,
              ),
            ),
            const SizedBox(height: 51), // 150 - 65 - 34 = 51
            // Voice Type Header
            const Text(
              'Voice Type',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.black,
                height: 1.21,
              ),
            ),
            const SizedBox(height: 18), // 190 - 150 - 22 = 18
            // Voice Options
            Column(
              children: voiceTypes.asMap().entries.map((entry) {
                int index = entry.key;
                String voiceType = entry.value;
                bool isSelected = selectedVoiceType == voiceType;

                return Padding(
                  padding: EdgeInsets.only(
                    bottom: index < voiceTypes.length - 1 ? 10 : 0,
                  ),
                  child: _buildVoiceOption(voiceType, isSelected),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVoiceOption(String voiceType, bool isSelected) {
    return GestureDetector(
      onTap: () => _onVoiceSelected(voiceType),
      child: Semantics(
        label: '$voiceType voice option',
        value: isSelected ? 'Selected' : 'Not selected',
        button: true,
        selected: isSelected,
        onTap: () => _onVoiceSelected(voiceType),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: 295,
          height: 40,
          decoration: BoxDecoration(
            color: isSelected ? Colors.black : const Color(0xFFD9D9D9),
            border: Border.all(color: const Color(0xFFB3B3B3), width: 1),
            borderRadius: BorderRadius.circular(8),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 20), // 60 - 40 = 20
              child: Text(
                voiceType,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: isSelected ? Colors.white : Colors.black,
                  height: 1.21,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
