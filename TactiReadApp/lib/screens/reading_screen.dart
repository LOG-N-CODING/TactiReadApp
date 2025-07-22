import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stts/stts.dart';

import '../database/models/document_model.dart';
import '../services/document_processing_service.dart';
import '../widgets/bottom_navigation_component.dart';

class ReadingScreen extends StatefulWidget {
  const ReadingScreen({super.key});

  @override
  State<ReadingScreen> createState() => _ReadingScreenState();
}

class _ReadingScreenState extends State<ReadingScreen> {
  double _readingSpeed = 0.3; // 0.0 to 1.0
  bool _toPixel = false; // Default to off
  bool _isReading = false; // Reading state

  // Speech recognition and TTS
  late FlutterTts _flutterTts;
  late Stt _stt;
  bool _isListening = false;
  Document? document;
  String fileName = 'File title';
  String filePath = '';
  String fileType = '';
  bool _isAudioCueEnabled = true; // Audio cue 설정
  bool _isDoubleTapEnabled = true; // Double tap 설정

  @override
  void initState() {
    super.initState();
    _initTts();
    _initSpeechRecognition();
    _loadReadingSpeed();
    _loadAudioCueSetting();
    _loadDoubleTapSetting();
  }

  // SharedPreferences에서 읽기 속도 로드
  Future<void> _loadReadingSpeed() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _readingSpeed = prefs.getDouble('reading_speed') ?? 0.3;
    });

    // TTS 속도도 함께 업데이트
    double ttsRate = 0.2 + (_readingSpeed * 0.8); // 0.2 ~ 1.0 range
    _flutterTts.setSpeechRate(ttsRate);
  }

  // SharedPreferences에 읽기 속도 저장
  Future<void> _saveReadingSpeed(double speed) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('reading_speed', speed);
  }

  // SharedPreferences에서 Audio Cue 설정 로드
  Future<void> _loadAudioCueSetting() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isAudioCueEnabled = prefs.getBool('isAudioCueEnabled') ?? true;
    });
  }

  // SharedPreferences에서 Double Tap 설정 로드
  Future<void> _loadDoubleTapSetting() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isDoubleTapEnabled = prefs.getBool('isDoubleTapEnabled') ?? true;
    });
  }

  // TTS 실행 전 Audio Cue 설정 확인하는 헬퍼 메서드
  Future<void> _speakIfEnabled(String text) async {
    if (_isAudioCueEnabled) {
      await _flutterTts.speak(text);
    }
  }

  // 더블탭으로 읽기 토글하는 메서드
  void _handleDoubleTap() {
    if (_isDoubleTapEnabled) {
      // 햅틱 피드백
      HapticFeedback.mediumImpact();
      
      // 읽기 토글
      _startReading();
      
      // 더블탭 피드백 메시지
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_isReading ? 'Double-tap: Reading started' : 'Double-tap: Reading stopped'),
          backgroundColor: _isReading ? Colors.green : Colors.orange,
          duration: const Duration(seconds: 1),
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
        ),
      );
    }
  }

  void _initTts() async {
    _flutterTts = FlutterTts();
    await _flutterTts.setLanguage("en-US"); // voice_selection_screen과 동일하게 영어로 설정
    await _flutterTts.setVolume(1.0);

    // 저장된 설정 로드
    await _loadVoiceSettings();
    await _loadReadingSpeed();
  }

  // 음성 설정 로드 (voice_selection_screen과 동일한 방식)
  Future<void> _loadVoiceSettings() async {
    final prefs = await SharedPreferences.getInstance();
    String voiceType = prefs.getString('selectedVoiceType') ?? 'Male';

    try {
      // voice_selection_screen과 동일한 로직 적용
      await _applyVoiceSettings(voiceType);
    } catch (e) {
      print('Error loading voice settings: $e');
      await _setPitchFallback(voiceType);
    }
  }

  // voice_selection_screen과 동일한 음성 설정 로직
  Future<void> _applyVoiceSettings(String voiceType) async {
    try {
      switch (voiceType) {
        case 'Male':
          // 시스템의 남성 음성 찾기
          await _findAndSetVoice('male', voiceType);
          await _flutterTts.setPitch(0.5); // voice_selection_screen과 동일
          break;
        case 'Female':
          // 시스템의 여성 음성 찾기
          await _findAndSetVoice('female', voiceType);
          await _flutterTts.setPitch(1.3); // voice_selection_screen과 동일
          break;
        case 'Robotic':
          // 기본 음성 + 로봇 효과
          await _flutterTts.setLanguage("en-US");
          await _flutterTts.setPitch(0.1); // voice_selection_screen과 동일
          await _flutterTts.setSpeechRate(0.5); // voice_selection_screen과 동일
          print('Robotic voice set: en-US with robotic effects');
          break;
      }

      // 볼륨 설정
      await _flutterTts.setVolume(1.0);
      print('Reading screen voice applied: $voiceType');
    } catch (e) {
      print('Error setting voice: $e');
      await _setPitchFallback(voiceType);
    }
  }

  // voice_selection_screen과 동일한 음성 찾기 로직
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

  // Pitch 기반 대체 설정 (voice_selection_screen과 동일)
  Future<void> _setPitchFallback(String voiceType) async {
    await _flutterTts.setLanguage("en-US");

    switch (voiceType) {
      case 'Male':
        await _flutterTts.setPitch(0.5); // voice_selection_screen과 동일
        break;
      case 'Female':
        await _flutterTts.setPitch(1.3); // voice_selection_screen과 동일
        break;
      case 'Robotic':
        await _flutterTts.setPitch(0.1); // voice_selection_screen과 동일
        break;
    }
  }

  // STTS 음성 인식 초기화
  void _initSpeechRecognition() async {
    try {
      _stt = Stt();

      // 상태 변화 리스너
      _stt.onStateChanged.listen(
        (speechState) {
          print('STT State changed: $speechState');
          setState(() {
            _isListening = speechState == SttState.start;
          });
        },
        onError: (err) {
          print('STT State error: $err');
          setState(() => _isListening = false);
        },
      );

      // 결과 리스너
      _stt.onResultChanged.listen((result) {
        // 최종 결과가 나오면 음성 명령 처리
        if (result.text.isNotEmpty && result.isFinal) {
          _processVoiceCommand(result.text);
        }
      });

      print('Speech recognition initialized');
    } catch (e) {
      print('Error initializing speech recognition: $e');
    }
  }

  // 음성 명령 처리
  void _processVoiceCommand(String command) {
    String lowerCommand = command.toLowerCase();

    if (lowerCommand.contains('next') || lowerCommand.contains('다음')) {
      _nextPage();
    } else if (lowerCommand.contains('previous') || lowerCommand.contains('이전')) {
      _previousPage();
    } else if (lowerCommand.contains('start') &&
        (lowerCommand.contains('read') || lowerCommand.contains('reading'))) {
      // "start reading" 명령어 - 실제 문서 변환 및 전송 처리
      // _startReading();
    } else if (lowerCommand.contains('read') ||
        lowerCommand.contains('red') ||
        lowerCommand.contains('reading') ||
        lowerCommand.contains('리딩') ||
        lowerCommand.contains('읽기')) {
      // 단순 "read" 명령어 - 실제 문서 변환 및 전송 처리
      _startReading();
    } else if (lowerCommand.contains('stop') || lowerCommand.contains('멈춤')) {
      _stopReading();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Voice command not recognized: $command'),
          backgroundColor: Colors.orange,
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  void _startVoiceInstructions() async {
    await _speakIfEnabled('Voice commands available: next, previous, start reading, stop');

    // 음성 안내 후 잠시 대기 후 listening 시작
    Future.delayed(const Duration(seconds: 4), () {
      if (!_isListening) {
        _startListening();
      }
    });
  }

  void _startListening() async {
    if (!_isListening) {
      try {
        // 권한 확인
        bool hasPermission = await _stt.hasPermission();
        if (!hasPermission) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Speech recognition permission required'),
              backgroundColor: Colors.red,
              duration: Duration(seconds: 3),
            ),
          );
          return;
        }

        // 음성 인식 시작
        await _stt.start();

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Listening... Say "next", "previous", "start reading", or "stop"'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 3),
          ),
        );
      } catch (e) {
        print('Error during speech recognition: $e');
        // setState(() => _isListening = false);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Speech recognition error: $e'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 3),
          ),
        );
      }
    } else {
      // 이미 listening 중이면 stop
      await _stt.stop();
    }
  }

  void _previousPage() {
    // 음성 확인 메시지
    _speakIfEnabled('Going to previous page');

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_isListening ? 'Voice Command: Previous page' : 'Previous page'),
        backgroundColor: Colors.blue,
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _nextPage() {
    // 음성 확인 메시지
    _speakIfEnabled('Going to next page');

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_isListening ? 'Voice Command: Next page' : 'Next page'),
        backgroundColor: Colors.blue,
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _onReadingSpeedChanged(double value) {
    setState(() {
      _readingSpeed = value;
    });

    // Reading speed에 따라 TTS 속도 조정
    double ttsRate = 0.2 + (_readingSpeed * 0.8); // 0.2 ~ 1.0 range
    _flutterTts.setSpeechRate(ttsRate);

    // SharedPreferences에 저장
    _saveReadingSpeed(value);

    HapticFeedback.selectionClick();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Arguments에서 파일 정보 가져오기
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    if (args != null) {
      document = args['document'] as Document?;
      fileName = args['fileName'] ?? 'File title';
      filePath = args['filePath'] ?? '';
      fileType = args['fileType'] ?? '';
    }

    // 화면으로 돌아올 때마다 설정 다시 로드
    _loadReadingSpeed();
    _loadVoiceSettings();
    _loadAudioCueSetting();
    _loadDoubleTapSetting();
  }

  // Start Reading 기능 구현
  void _startReading() {
    setState(() {
      _isReading = !_isReading;
    });

    if (_isReading) {
      // 음성 확인 메시지
      _speakIfEnabled('Starting to read document');

      // 문서가 선택된 경우 해당 문서 처리
      _processSelectedDocument();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_isListening ? 'Voice Command: Start reading' : 'Reading started'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );
    } else {
      // 읽기 중지 시 TTS도 중지
      _flutterTts.stop();
      _speakIfEnabled('Reading stopped');

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_isListening ? 'Voice Command: Stop reading' : 'Reading paused'),
          backgroundColor: Colors.orange,
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  void _processSelectedDocument() {
    if (document == null) {
      // 문서가 없을 때 샘플 텍스트로 TTS 실행
      String sampleText =
          '샘플 문서입니다. 이것은 TTS 기능 테스트를 위한 예시 텍스트입니다. 읽기 속도 조절과 음성 출력이 정상적으로 작동하는지 확인할 수 있습니다.';
      _speakExtractedText(sampleText);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('샘플 텍스트로 TTS 기능을 실행합니다.'), backgroundColor: Colors.blue),
      );
      return;
    }

    // _toPixel 토글에 따라 처리 방식 결정
    if (_toPixel) {
      _processDisplayAsIs(); // 픽셀로 전송
    } else {
      _processExtractText(); // 텍스트로 변환하여 전송
    }
  }

  // "display as is" 처리 - 실제 픽셀 데이터 변환
  void _processDisplayAsIs() async {
    if (document == null) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('원본 파일을 픽셀 데이터로 변환하여 디바이스로 전송 중...'),
        backgroundColor: Colors.blue,
        duration: Duration(seconds: 3),
      ),
    );

    try {
      final DocumentProcessingService processor = DocumentProcessingService();

      // 픽셀 모드에서도 샘플 텍스트로 TTS 실행
      String sampleText = '픽셀 모드로 문서를 표시합니다. 원본 파일의 레이아웃과 이미지가 그대로 점자 디스플레이에 표시됩니다.';
      await _speakExtractedText(sampleText);

      if (processor.isPdfFile(document!.filePath)) {
        // PDF 파일을 픽셀 데이터로 변환
        final List<List<int>> multiPagePixelData = await processor.convertPdfToPixelData(
          document!.filePath,
        );

        // 각 페이지의 픽셀 데이터를 하드웨어로 전송
        for (int i = 0; i < multiPagePixelData.length; i++) {
          _simulateHardwareTransmission(
            'PDF 페이지 ${i + 1} 픽셀 데이터 (${multiPagePixelData[i].length} pixels)',
          );
        }
      } else if (processor.isImageFile(document!.filePath)) {
        // 이미지 파일을 픽셀 데이터로 변환
        final List<int> pixelData = await processor.convertImageToPixelData(document!.filePath);
        _simulateHardwareTransmission('이미지 픽셀 데이터 (${pixelData.length} pixels)');
      } else {
        throw Exception('지원하지 않는 파일 형식입니다.');
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('픽셀 데이터 변환 및 전송이 완료되었습니다.'), backgroundColor: Colors.green),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('픽셀 데이터 변환 실패: $e'), backgroundColor: Colors.red));
    }
  }

  // "extract text" 처리 - 실제 텍스트 추출 및 브라유 변환
  void _processExtractText() async {
    if (document == null) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('텍스트 추출 및 점자로 변환하여 전송 중...'),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 3),
      ),
    );

    try {
      final DocumentProcessingService processor = DocumentProcessingService();
      String extractedText = '';

      if (processor.isPdfFile(document!.filePath)) {
        // PDF에서 텍스트 추출
        extractedText = await processor.extractTextFromPdf(document!.filePath);
      } else if (processor.isImageFile(document!.filePath)) {
        // 이미지에서 OCR로 텍스트 추출
        extractedText = await processor.extractTextFromImage(document!.filePath);
      } else {
        throw Exception('지원하지 않는 파일 형식입니다.');
      }

      if (extractedText.isEmpty) {
        throw Exception('추출할 텍스트가 없습니다.');
      }

      // TTS로 일반 텍스트 읽기 (점자 변환 전 원본 텍스트)
      await _speakExtractedText(extractedText);

      // 텍스트를 점자로 변환 (하드웨어 전송용)
      final String brailleText = processor.convertTextToBraille(extractedText);

      // 브라유 데이터를 하드웨어로 전송
      _simulateHardwareTransmission('점자 데이터 (${brailleText.length} characters)');

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('텍스트 추출 완료: ${extractedText.length} 글자가 점자로 변환되었습니다.'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('텍스트 추출 실패: $e'), backgroundColor: Colors.red));
    }
  }

  // TTS로 추출된 텍스트 읽기
  Future<void> _speakExtractedText(String text) async {
    if (text.isEmpty || !_isAudioCueEnabled) return;

    try {
      // 저장된 설정 다시 로드
      await _loadVoiceSettings();

      // 현재 읽기 속도에 맞춰 TTS 속도 설정 (로봇 음성 제외)
      final prefs = await SharedPreferences.getInstance();
      String voiceType = prefs.getString('selectedVoiceType') ?? 'Male';

      if (voiceType != 'Robotic') {
        double ttsRate = 0.2 + (_readingSpeed * 0.8); // 0.2 ~ 1.0 range
        await _flutterTts.setSpeechRate(ttsRate);
      }

      // 영어로 설정 (voice_selection_screen과 동일)
      await _flutterTts.setLanguage("en-US");

      // 텍스트가 너무 길면 문장 단위로 나누어 읽기
      List<String> sentences = _splitTextIntoSentences(text);

      for (String sentence in sentences) {
        if (_isReading && sentence.trim().isNotEmpty && _isAudioCueEnabled) {
          await _flutterTts.speak(sentence.trim());
          // 각 문장 사이에 짧은 간격
          await Future.delayed(const Duration(milliseconds: 500));
        } else {
          break; // 읽기가 중지되거나 오디오가 비활성화되면 루프 종료
        }
      }
    } catch (e) {
      print('TTS 오류: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('음성 출력 오류: $e'), backgroundColor: Colors.red));
    }
  }

  // 텍스트를 문장 단위로 분할
  List<String> _splitTextIntoSentences(String text) {
    // 한국어 문장 구분자로 분할
    List<String> sentences = text.split(RegExp(r'[.!?。？！]\s*'));

    // 빈 문장 제거 및 적절한 길이로 조정
    List<String> processedSentences = [];

    for (String sentence in sentences) {
      sentence = sentence.trim();
      if (sentence.isNotEmpty) {
        // 너무 긴 문장은 더 작은 단위로 분할 (200자 제한)
        if (sentence.length > 200) {
          List<String> chunks = _splitLongSentence(sentence, 200);
          processedSentences.addAll(chunks);
        } else {
          processedSentences.add(sentence);
        }
      }
    }

    return processedSentences;
  }

  // 긴 문장을 작은 단위로 분할
  List<String> _splitLongSentence(String sentence, int maxLength) {
    List<String> chunks = [];
    int start = 0;

    while (start < sentence.length) {
      int end = start + maxLength;
      if (end >= sentence.length) {
        chunks.add(sentence.substring(start));
        break;
      }

      // 단어 경계에서 분할하도록 조정
      int lastSpace = sentence.lastIndexOf(' ', end);
      if (lastSpace > start) {
        end = lastSpace;
      }

      chunks.add(sentence.substring(start, end));
      start = end + 1;
    }

    return chunks;
  }

  // 하드웨어 전송 시뮬레이션
  void _simulateHardwareTransmission(String dataType) {
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$dataType가 USB를 통해 하드웨어로 전송되었습니다.'),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onDoubleTap: _handleDoubleTap,
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        bottomNavigationBar: const BottomNavigationComponent(currentRoute: '/reading'),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                    const SizedBox(height: 40),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            // File title
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.25,
                              child: Text(
                                fileName,
                                style: TextStyle(
                                  fontFamily: 'Pretendard Variable',
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Theme.of(context).textTheme.bodyMedium?.color,
                                  height: 1.0,
                                ),
                                overflow: TextOverflow.ellipsis, // 넘치면 ... 표시
                                maxLines: 1, // 한 줄로 제한
                              ),
                            ),

                            const SizedBox(height: 26),

                            // Device status
                            Text(
                              'Device status',
                              style: TextStyle(
                                fontFamily: 'Pretendard Variable',
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Theme.of(context).textTheme.bodyMedium?.color,
                                height: 1.0,
                              ),
                            ),
                          ],
                        ),
                        // Start Reading button (centered)
                        Center(
                          child: GestureDetector(
                            onTap: _startReading,
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.35,
                              height: 44,
                              decoration: BoxDecoration(
                                color: _isReading 
                                    ? Colors.red 
                                    : (Theme.of(context).brightness == Brightness.dark 
                                        ? Colors.white 
                                        : Colors.black),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Center(
                                child: Text(
                                  _isReading ? 'Stop Reading' : 'Start Reading',
                                  style: TextStyle(
                                    fontFamily: 'Pretendard Variable',
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: _isReading 
                                        ? Colors.white 
                                        : (Theme.of(context).brightness == Brightness.dark 
                                            ? Colors.black 
                                            : Colors.white),
                                    height: 1.0,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 50),

                    // Start Reading button and navigation buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Previous page button
                        GestureDetector(
                          onTap: _previousPage,
                          child: Container(
                            width: 142,
                            height: 44,
                            decoration: BoxDecoration(
                              color: Theme.of(context).brightness == Brightness.dark 
                                  ? Colors.grey.shade800 
                                  : Colors.white,
                              border: Border.all(
                                color: Theme.of(context).brightness == Brightness.dark 
                                    ? Colors.grey.shade600 
                                    : const Color(0xFFB0B0B0),
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Center(
                              child: Text(
                                'Previous page',
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  color: Theme.of(context).textTheme.bodyMedium?.color,
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
                          onTap: _nextPage,
                          child: Container(
                            width: 142,
                            height: 44,
                            decoration: BoxDecoration(
                              color: Theme.of(context).brightness == Brightness.dark 
                                  ? Colors.grey.shade800 
                                  : Colors.white,
                              border: Border.all(
                                color: Theme.of(context).brightness == Brightness.dark 
                                    ? Colors.grey.shade600 
                                    : const Color(0xFFB0B0B0),
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Center(
                              child: Text(
                                'Next page',
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  color: Theme.of(context).textTheme.bodyMedium?.color,
                                  height: 1.21,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 80),

                    // Reading speed slider
                    Center(
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Reading speed',
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 18,
                                  fontWeight: FontWeight.w400,
                                  color: Theme.of(context).textTheme.bodyLarge?.color,
                                  height: 1.46,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(width: 12),
                              GestureDetector(
                                onTap: () {
                                  Navigator.pushNamed(context, '/reading-speed-control');
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).brightness == Brightness.dark 
                                        ? Colors.grey[800] 
                                        : Colors.grey[100],
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Icon(
                                    Icons.settings, 
                                    size: 20, 
                                    color: Theme.of(context).iconTheme.color,
                                  ),
                                ),
                              ),
                            ],
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
                                      color: Theme.of(context).brightness == Brightness.dark 
                                          ? Colors.white.withOpacity(0.4) 
                                          : Colors.black.withOpacity(0.4),
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
                                      color: Theme.of(context).brightness == Brightness.dark 
                                          ? Colors.white 
                                          : Colors.black,
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
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).brightness == Brightness.dark 
                                          ? Colors.white 
                                          : Colors.black,
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
                                    onChanged: _onReadingSpeedChanged,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 80),

                    // Voice guidance toggle
                    Center(
                      child: Column(
                        children: [
                          Text(
                            'graphics',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 18,
                              fontWeight: FontWeight.w400,
                              color: Theme.of(context).textTheme.bodyLarge?.color,
                              height: 1.46,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 8),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _toPixel = !_toPixel;
                              });
                            },
                            child: Container(
                              width: 120,
                              height: 60,
                              decoration: BoxDecoration(
                                color: _toPixel 
                                    ? (Theme.of(context).brightness == Brightness.dark 
                                        ? Colors.white 
                                        : Colors.black)
                                    : Colors.grey,
                                borderRadius: BorderRadius.circular(80),
                              ),
                              child: Stack(
                                children: [
                                  AnimatedPositioned(
                                    duration: const Duration(milliseconds: 200),
                                    left: _toPixel ? 68 : 8,
                                    top: 8,
                                    child: Container(
                                      width: 44,
                                      height: 44,
                                      decoration: BoxDecoration(
                                        color: _toPixel 
                                            ? (Theme.of(context).brightness == Brightness.dark 
                                                ? Colors.black 
                                                : Colors.white)
                                            : Colors.white,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            _toPixel ? 'Pixel Mode' : 'Braille Text Mode',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: _toPixel ? Colors.blue : Colors.green,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Voice Control Button
                    Center(
                      child: ElevatedButton.icon(
                        onPressed: _startVoiceInstructions,
                        icon: Icon(_isListening ? Icons.mic : Icons.mic_none),
                        label: Text(_isListening ? 'Listening...' : 'Voice Command'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _isListening ? Colors.red : Colors.blue,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                      ),
                    ),

                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ),
    ); // GestureDetector의 닫는 괄호
  }

  // TTS 읽기 중지
  void _stopReading() {
    setState(() {
      _isReading = false;
    });

    _flutterTts.stop();
    _speakIfEnabled('Reading stopped');

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Voice Command: Reading stopped'),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  void dispose() {
    // STT 리소스 정리
    _stt.dispose();

    // TTS 리소스 정리
    _flutterTts.stop();
    super.dispose();
  }
}
