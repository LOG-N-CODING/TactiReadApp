import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import '../database/database_helper.dart';
import '../database/models/document_model.dart';
import '../services/user_session_service.dart';

class FileUploadService {
  static final FileUploadService _instance = FileUploadService._internal();
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  FileUploadService._internal();

  factory FileUploadService() => _instance;

  // 지원되는 파일 형식
  static const List<String> supportedExtensions = ['pdf', 'png', 'jpg', 'jpeg', 'docx', 'txt'];

  // 파일 선택 및 업로드
  Future<FileUploadResult> pickAndUploadFile() async {
    try {
      // 현재 사용자 확인
      final currentUser = await UserSessionService.getCurrentUser();
      if (currentUser == null) {
        return FileUploadResult(success: false, message: '로그인이 필요합니다.');
      }

      // 파일 선택
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: supportedExtensions,
        allowMultiple: false,
      );

      if (result == null || result.files.isEmpty) {
        return FileUploadResult(success: false, message: '파일이 선택되지 않았습니다.');
      }

      PlatformFile file = result.files.first;

      // 파일 크기 확인 (최대 50MB)
      if (file.size > 50 * 1024 * 1024) {
        return FileUploadResult(success: false, message: '파일 크기가 50MB를 초과합니다.');
      }

      // 파일 확장자 확인
      String fileExtension = path.extension(file.name).toLowerCase().replaceAll('.', '');
      if (!supportedExtensions.contains(fileExtension)) {
        return FileUploadResult(success: false, message: '지원하지 않는 파일 형식입니다.');
      }

      // 앱 문서 디렉토리 가져오기
      Directory appDocDir = await getApplicationDocumentsDirectory();
      String documentsPath = path.join(appDocDir.path, 'documents');

      // 문서 디렉토리 생성
      Directory documentsDir = Directory(documentsPath);
      if (!await documentsDir.exists()) {
        await documentsDir.create(recursive: true);
      }

      // 고유한 파일명 생성 (중복 방지)
      String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
      String fileName = '${timestamp}_${file.name}';
      String filePath = path.join(documentsPath, fileName);

      // 파일 복사
      if (file.path != null) {
        File sourceFile = File(file.path!);
        File targetFile = File(filePath);
        await sourceFile.copy(filePath);
      } else if (file.bytes != null) {
        File targetFile = File(filePath);
        await targetFile.writeAsBytes(file.bytes!);
      } else {
        return FileUploadResult(success: false, message: '파일 데이터를 읽을 수 없습니다.');
      }

      // 데이터베이스에 문서 정보 저장
      Document document = Document(
        userId: currentUser.id!,
        fileName: file.name,
        filePath: filePath,
        fileType: fileExtension,
        fileSize: file.size,
        createdAt: DateTime.now(),
      );

      int documentId = await _databaseHelper.insertDocument(document);

      if (documentId > 0) {
        return FileUploadResult(
          success: true,
          message: '파일이 성공적으로 업로드되었습니다.',
          document: document.copyWith(id: documentId),
        );
      } else {
        // 업로드된 파일 삭제 (DB 저장 실패 시)
        File(filePath).deleteSync();
        return FileUploadResult(success: false, message: '파일 정보 저장 중 오류가 발생했습니다.');
      }
    } catch (e) {
      return FileUploadResult(success: false, message: '파일 업로드 중 오류가 발생했습니다: ${e.toString()}');
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

      if (dbResult) {
        // 실제 파일 삭제
        File file = File(document.filePath);
        if (await file.exists()) {
          await file.delete();
        }
        return true;
      }
      return false;
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
