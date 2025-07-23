import 'dart:math';
import '../database/database_helper.dart';
import '../database/models/document_model.dart';
import '../services/user_session_service.dart';

class SimpleFileService {
  static final SimpleFileService _instance = SimpleFileService._internal();
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  SimpleFileService._internal();

  factory SimpleFileService() => _instance;

  // 데모용 파일 업로드 (실제 파일 선택 없이)
  Future<FileUploadResult> simulateFileUpload() async {
    try {
      // 현재 사용자 확인
      final currentUser = await UserSessionService.getCurrentUser();
      if (currentUser == null) {
        return FileUploadResult(success: false, message: 'Login is required.');
      }

      // 업로드 시뮬레이션 (로딩 시간)
      await Future.delayed(const Duration(seconds: 1));

      // 샘플 파일들 중 랜덤 선택
      List<Map<String, dynamic>> sampleFiles = [
        {'name': 'TactiRead_Manual.pdf', 'type': 'pdf', 'size': 1024 * 500}, // 500KB
        {'name': 'Braille_Chart.png', 'type': 'png', 'size': 1024 * 200}, // 200KB
        {'name': 'Reading_Notes.txt', 'type': 'txt', 'size': 1024 * 10}, // 10KB
        {'name': 'User_Guide.docx', 'type': 'docx', 'size': 1024 * 1000}, // 1MB
        {'name': 'Device_Photo.jpg', 'type': 'jpg', 'size': 1024 * 300}, // 300KB
        {'name': 'Math_Formulas.pdf', 'type': 'pdf', 'size': 1024 * 750}, // 750KB
        {'name': 'Diagram_Example.png', 'type': 'png', 'size': 1024 * 400}, // 400KB
      ];

      final random = Random();
      final selectedFile = sampleFiles[random.nextInt(sampleFiles.length)];

      // 고유한 파일명 생성
      String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
      String filePath = '/app_documents/${timestamp}_${selectedFile['name']}';

      // 데이터베이스에 문서 정보 저장
      Document document = Document(
        userId: currentUser.id!,
        fileName: selectedFile['name'],
        filePath: filePath,
        fileType: selectedFile['type'],
        fileSize: selectedFile['size'],
        createdAt: DateTime.now(),
      );

      int documentId = await _databaseHelper.insertDocument(document);

      if (documentId > 0) {
        return FileUploadResult(
          success: true,
          message: 'File uploaded successfully.',
          document: document.copyWith(id: documentId),
        );
      } else {
        return FileUploadResult(success: false, message: 'Error occurred while saving file information.');
      }
    } catch (e) {
      return FileUploadResult(success: false, message: 'Error occurred while uploading file: ${e.toString()}');
    }
  }

  // 파일 타입별 아이콘 가져오기
  static String getFileTypeIcon(String fileType) {
    switch (fileType.toLowerCase()) {
      case 'pdf':
        return '📄';
      case 'png':
      case 'jpg':
      case 'jpeg':
        return '🖼️';
      case 'docx':
        return '📝';
      case 'txt':
        return '📋';
      default:
        return '📁';
    }
  }

  // 파일 삭제
  Future<bool> deleteFile(Document document) async {
    try {
      // 데이터베이스에서 삭제
      bool dbResult = await _databaseHelper.deleteDocument(document.id!);
      return dbResult;
    } catch (e) {
      print('File deletion error: $e');
      return false;
    }
  }
}

class FileUploadResult {
  final bool success;
  final String message;
  final Document? document;

  FileUploadResult({required this.success, required this.message, this.document});
}
