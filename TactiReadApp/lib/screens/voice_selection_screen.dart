import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VoiceSelectionScreen extends StatefulWidget {
  const VoiceSelectionScreen({super.key});

  @override
  State<VoiceSelectionScreen> createState() => _VoiceSelectionScreenState();
}

class _VoiceSelectionScreenState extends State<VoiceSelectionScreen> {
  String selectedVoiceType = 'Male'; // Default selection based on Figma design
  late FlutterTts _flutterTts;
  List<dynamic> availableVoices = [];
  Map<String, dynamic> selectedVoiceMap = {};

  final List<String> voiceTypes = ['Male', 'Female', 'Robotic'];

  @override
  void initState() {
    super.initState();
    _initTts();
    _loadSelectedVoice();
    _getAvailableVoices();
  }

  void _initTts() async {
    _flutterTts = FlutterTts();
    await _flutterTts.setLanguage("ko-KR");
    await _flutterTts.setSpeechRate(0.5);
    await _flutterTts.setVolume(1.0);
  }

  // 사용 가능한 음성 목록 가져오기
  Future<void> _getAvailableVoices() async {
    try {
      var voices = await _flutterTts.getVoices;
      setState(() {
        availableVoices = voices;
      });
      print('Available voices: $voices');
    } catch (e) {
      print('Error getting voices: $e');
    }
  }

  void _loadSelectedVoice() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      selectedVoiceType = prefs.getString('selectedVoiceType') ?? 'Male';
    });
  }

  void _onVoiceSelected(String voiceType) async {
    setState(() {
      selectedVoiceType = voiceType;
    });

    // Save selection
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selectedVoiceType', voiceType);

    // Apply voice settings
    await _applyVoiceSettings(voiceType);

    // Test voice
    await _testVoice(voiceType);

    // 햅틱 피드백
    HapticFeedback.selectionClick();

    // 선택된 음성에 대한 확인 메시지
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$voiceType voice selected'),
        duration: const Duration(milliseconds: 800),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  Future<void> _applyVoiceSettings(String voiceType) async {
    try {
      // 먼저 사용 가능한 음성 목록을 확인
      List<dynamic> voices = await _flutterTts.getVoices;
      print('=== Available voices on device ===');
      for (var voice in voices) {
        print('Voice: ${voice['name']}, Locale: ${voice['locale']}');
      }
      print('================================');

      switch (voiceType) {
        case 'Male':
          // 시스템의 남성 음성 찾기
          await _findAndSetVoice('male', voiceType);
          await _flutterTts.setPitch(0.5); // 약간 낮은 pitch
          break;
        case 'Female':
          // 시스템의 여성 음성 찾기
          await _findAndSetVoice('female', voiceType);
          await _flutterTts.setPitch(1.3); // 약간 높은 pitch
          break;
        case 'Robotic':
          // 기본 음성 + 로봇 효과
          await _flutterTts.setLanguage("en-US");
          await _flutterTts.setPitch(0.1); // 매우 낮은 pitch
          await _flutterTts.setSpeechRate(0.5); // 느린 속도
          print('Robotic voice set: en-US with robotic effects');
          break;
      }

      // 기본 설정
      if (voiceType != 'Robotic') {
        await _flutterTts.setSpeechRate(0.5);
      }
      await _flutterTts.setVolume(1.0);
    } catch (e) {
      print('Error setting voice: $e');
      await _setPitchFallback(voiceType);
    }
  }

  // 실제 사용 가능한 음성 찾기
  Future<void> _findAndSetVoice(String genderKeyword, String voiceType) async {
    try {
      List<dynamic> voices = await _flutterTts.getVoices;

      // 영어 음성 중에서 성별 키워드가 포함된 음성 찾기
      for (var voice in voices) {
        String voiceName = voice['name'].toString().toLowerCase();
        String locale = voice['locale'].toString();

        if (locale.startsWith('en') && voiceName.contains(genderKeyword)) {
          await _flutterTts.setVoice({"name": voice['name'], "locale": voice['locale']});
          print('$voiceType voice found and set: ${voice['name']}');
          return;
        }
      }

      // 성별 키워드를 찾지 못한 경우, 기본 영어 음성 사용
      await _flutterTts.setLanguage("en-US");
      print('$voiceType voice set to default: en-US');
    } catch (e) {
      print('Error finding voice: $e');
      await _flutterTts.setLanguage("en-US");
    }
  }

  // Pitch 기반 대체 설정 (기본 시스템 음성 사용)
  Future<void> _setPitchFallback(String voiceType) async {
    await _flutterTts.setLanguage("en-US");

    switch (voiceType) {
      case 'Male':
        await _flutterTts.setPitch(0.9); // 낮은 음조
        break;
      case 'Female':
        await _flutterTts.setPitch(1.1); // 높은 음조
        break;
      case 'Robotic':
        await _flutterTts.setPitch(0.3); // 매우 낮은 음조
        break;
    }
  }

  Future<void> _testVoice(String voiceType) async {
    String testMessage;
    switch (voiceType) {
      case 'Male':
        testMessage = 'This is a male voice speaking in English';
        break;
      case 'Female':
        testMessage = 'This is a female voice speaking in English';
        break;
      case 'Robotic':
        testMessage = 'This is a robotic voice speaking'; // 영어로 로봇 음성 테스트
        break;
      default:
        testMessage = 'Voice test';
    }

    await _flutterTts.speak(testMessage);
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
                  padding: EdgeInsets.only(bottom: index < voiceTypes.length - 1 ? 10 : 0),
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
