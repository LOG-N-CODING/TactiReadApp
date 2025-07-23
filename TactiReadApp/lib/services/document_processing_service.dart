import 'dart:io';
import 'dart:typed_data';
import 'package:image/image.dart' as img;
import 'package:syncfusion_flutter_pdf/pdf.dart' as pdf;
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart' as mlkit;

class DocumentProcessingService {
  static final DocumentProcessingService _instance = DocumentProcessingService._internal();
  factory DocumentProcessingService() => _instance;
  DocumentProcessingService._internal();

  // PDF에서 텍스트 추출
  Future<String> extractTextFromPdf(String filePath) async {
    try {
      // PDF 파일 읽기
      final File file = File(filePath);
      final Uint8List bytes = await file.readAsBytes();

      // Syncfusion PDF 라이브러리를 사용하여 텍스트 추출
      final pdf.PdfDocument document = pdf.PdfDocument(inputBytes: bytes);
      String extractedText = '';

      // 모든 페이지에서 텍스트 추출
      for (int i = 0; i < document.pages.count; i++) {
        final String pageText = pdf.PdfTextExtractor(
          document,
        ).extractText(startPageIndex: i, endPageIndex: i);
        extractedText += '$pageText\n';
      }

      document.dispose();
      return extractedText.trim();
    } catch (e) {
      throw Exception('Failed to extract text from PDF: $e');
    }
  }

  // 이미지에서 OCR로 텍스트 추출
  Future<String> extractTextFromImage(String filePath) async {
    try {
      final File imageFile = File(filePath);
      final mlkit.InputImage inputImage = mlkit.InputImage.fromFile(imageFile);

      // Google ML Kit Text Recognition 사용
      final mlkit.TextRecognizer textRecognizer = mlkit.TextRecognizer();
      final mlkit.RecognizedText recognizedText = await textRecognizer.processImage(inputImage);

      String extractedText = '';
      for (mlkit.TextBlock block in recognizedText.blocks) {
        for (mlkit.TextLine line in block.lines) {
          extractedText += '${line.text}\n';
        }
      }

      await textRecognizer.close();
      return extractedText.trim();
    } catch (e) {
      throw Exception('Failed to extract text from image: $e');
    }
  } // PDF를 이미지로 변환한 후 픽셀 데이터 생성

  Future<List<List<int>>> convertPdfToPixelData(String filePath) async {
    try {
      final File file = File(filePath);
      final Uint8List bytes = await file.readAsBytes();

      // PDF 문서 로드
      final pdf.PdfDocument document = pdf.PdfDocument(inputBytes: bytes);

      List<List<int>> allPixelData = [];

      // 각 페이지를 이미지로 변환
      for (int i = 0; i < document.pages.count; i++) {
        // PDF 페이지를 이미지로 렌더링 (간단한 방식)
        // 실제로는 더 복잡한 렌더링이 필요하지만, 시뮬레이션으로 처리
        final List<int> simulatedPixelData = _generateSimulatedPixelData(400, 600);
        allPixelData.add(simulatedPixelData);
      }

      document.dispose();
      return allPixelData;
    } catch (e) {
      throw Exception('Failed to convert PDF to pixel data: $e');
    }
  }

  // 이미지 파일을 픽셀 데이터로 변환
  Future<List<int>> convertImageToPixelData(String filePath) async {
    try {
      final File imageFile = File(filePath);
      final Uint8List bytes = await imageFile.readAsBytes();
      final img.Image? image = img.decodeImage(bytes);

      if (image == null) {
        throw Exception('Failed to decode image');
      }

      return _convertImageToPixelData(image);
    } catch (e) {
      throw Exception('Failed to convert image to pixel data: $e');
    }
  }

  // 이미지를 흑백 픽셀 데이터로 변환하는 헬퍼 메서드
  List<int> _convertImageToPixelData(img.Image image) {
    // 이미지를 그레이스케일로 변환
    final img.Image grayscale = img.grayscale(image);

    // 이미지를 적절한 크기로 리사이즈 (예: 최대 400x300)
    final img.Image resized = img.copyResize(
      grayscale,
      width: image.width > 400 ? 400 : image.width,
      height: image.height > 300 ? 300 : image.height,
    );

    List<int> pixelData = [];

    // 각 픽셀을 흑백 바이너리 데이터로 변환
    for (int y = 0; y < resized.height; y++) {
      for (int x = 0; x < resized.width; x++) {
        final img.Pixel pixel = resized.getPixel(x, y);
        // 그레이스케일 값 가져오기 (0-255)
        final int gray = pixel.r.toInt();

        // 임계값을 사용하여 흑백으로 변환 (128 이하는 검은색, 이상은 흰색)
        final int binaryValue = gray < 128 ? 1 : 0;
        pixelData.add(binaryValue);
      }
    }

    return pixelData;
  }

  // 시뮬레이션용 픽셀 데이터 생성
  List<int> _generateSimulatedPixelData(int width, int height) {
    List<int> pixelData = [];
    for (int i = 0; i < width * height; i++) {
      // 간단한 패턴 생성 (체스보드 패턴)
      final int x = i % width;
      final int y = i ~/ width;
      final int value = ((x ~/ 20) + (y ~/ 20)) % 2;
      pixelData.add(value);
    }
    return pixelData;
  }

  // 텍스트를 점자로 변환 (간단한 영어 브라유 매핑)
  String convertTextToBraille(String text) {
    // 기본적인 영어 점자 매핑
    final Map<String, String> brailleMap = {
      'a': '⠁',
      'b': '⠃',
      'c': '⠉',
      'd': '⠙',
      'e': '⠑',
      'f': '⠋',
      'g': '⠛',
      'h': '⠓',
      'i': '⠊',
      'j': '⠚',
      'k': '⠅',
      'l': '⠇',
      'm': '⠍',
      'n': '⠝',
      'o': '⠕',
      'p': '⠏',
      'q': '⠟',
      'r': '⠗',
      's': '⠎',
      't': '⠞',
      'u': '⠥',
      'v': '⠧',
      'w': '⠺',
      'x': '⠭',
      'y': '⠽',
      'z': '⠵',
      ' ': '⠀',
      '.': '⠲',
      ',': '⠂',
      '?': '⠦',
      '!': '⠖',
      ':': '⠒',
      ';': '⠆',
      '-': '⠤',
      '\'': '⠄',
      '0': '⠴',
      '1': '⠂',
      '2': '⠆',
      '3': '⠒',
      '4': '⠲',
      '5': '⠢',
      '6': '⠖',
      '7': '⠶',
      '8': '⠦',
      '9': '⠔',
    };

    String brailleText = '';
    for (int i = 0; i < text.length; i++) {
      final String char = text[i].toLowerCase();
      if (brailleMap.containsKey(char)) {
        brailleText += brailleMap[char]!;
      } else {
        // 매핑되지 않은 문자는 공백으로 처리
        brailleText += '⠀';
      }
    }

    return brailleText;
  }

  // 파일 형식 확인
  bool isPdfFile(String filePath) {
    return filePath.toLowerCase().endsWith('.pdf');
  }

  bool isImageFile(String filePath) {
    final String extension = filePath.toLowerCase();
    return extension.endsWith('.png') ||
        extension.endsWith('.jpg') ||
        extension.endsWith('.jpeg') ||
        extension.endsWith('.bmp') ||
        extension.endsWith('.gif');
  }
}

// 처리 결과를 담는 클래스
class ProcessingResult {
  final bool success;
  final String message;
  final String? extractedText;
  final String? brailleText;
  final List<int>? pixelData;
  final List<List<int>>? multiPagePixelData; // PDF의 경우 여러 페이지

  ProcessingResult({
    required this.success,
    required this.message,
    this.extractedText,
    this.brailleText,
    this.pixelData,
    this.multiPagePixelData,
  });
}
