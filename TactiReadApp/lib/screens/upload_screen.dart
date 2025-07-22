import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import '../widgets/bottom_navigation_component.dart';
import '../services/file_upload_service.dart';
import '../services/user_session_service.dart';
import '../database/database_helper.dart';
import '../database/models/document_model.dart';

class UploadScreen extends StatefulWidget {
  const UploadScreen({super.key});

  @override
  State<UploadScreen> createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  bool isFileUploaded = false;
  String uploadedFileName = 'File title';
  String fileType = 'PNG';
  String? filePath;
  int? fileSize;
  String selectedProcessingType = 'display_as_is'; // 기본값: display as is

  final FileUploadService _fileUploadService = FileUploadService();
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  Future<void> _uploadFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'docx', 'txt', 'png', 'jpg', 'jpeg'],
        allowMultiple: false,
      );

      if (result != null && result.files.single.path != null) {
        PlatformFile file = result.files.first;

        setState(() {
          isFileUploaded = true;
          uploadedFileName = file.name;
          fileType = file.extension?.toUpperCase() ?? 'UNKNOWN';
          filePath = file.path;
          fileSize = file.size;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('파일 "${file.name}"이 선택되었습니다. 처리 방식을 선택해주세요.'),
            backgroundColor: Colors.blue,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('파일 선택 중 오류가 발생했습니다: $e'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  // "display as is" 처리 및 저장
  Future<void> _processDisplayAsIs() async {
    await _saveFileToDatabase('display_as_is');
  }

  // "extract text" 처리 및 저장
  Future<void> _processExtractText() async {
    await _saveFileToDatabase('extract_text');
  }

  // 파일을 데이터베이스에 저장
  Future<void> _saveFileToDatabase(String processingType) async {
    if (filePath == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('파일을 먼저 선택해주세요.'), backgroundColor: Colors.red));
      return;
    }

    try {
      // 현재 사용자 확인
      final currentUser = await UserSessionService.getCurrentUser();
      if (currentUser == null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('로그인이 필요합니다.'), backgroundColor: Colors.red));
        return;
      }

      // FileUploadService를 사용하여 실제 파일 저장
      FileUploadResult uploadResult = await _fileUploadService.pickAndUploadFile();

      if (uploadResult.success && uploadResult.document != null) {
        // processing_type 업데이트
        Document updatedDocument = uploadResult.document!.copyWith(processingType: processingType);

        // 데이터베이스 업데이트
        await _databaseHelper.updateDocument(updatedDocument);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                processingType == 'display_as_is'
                    ? '파일이 원본 형태로 저장되었습니다.'
                    : '파일이 텍스트 추출 모드로 저장되었습니다.',
              ),
              backgroundColor: Colors.green,
            ),
          );

          // 홈 화면으로 이동
          Navigator.pushReplacementNamed(context, '/home');
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('파일 저장 중 오류가 발생했습니다: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Column(
                  children: [
                    const SizedBox(height: 144),

                    // File Upload Section
                    GestureDetector(
                      onTap: _uploadFile,
                      child: Container(
                        width: 165,
                        height: 147,
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 96,
                              height: 96,
                              decoration: const BoxDecoration(
                                color: Colors.black,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.upload_outlined,
                                size: 56,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              'File Upload',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                                height: 1.0,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 36),

                    // File Details Box (only show when file is uploaded)
                    if (isFileUploaded) ...[
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: const Color(0xFFEBEBEB),
                          border: Border.all(color: const Color(0xFFD3D3D3), width: 2),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Column(
                          children: [
                            // Top section with file info
                            Padding(
                              padding: const EdgeInsets.all(24),
                              child: Row(
                                children: [
                                  // Checkbox
                                  Container(
                                    width: 20,
                                    height: 20,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(color: const Color(0xFFD3D3D3)),
                                      borderRadius: BorderRadius.circular(3),
                                    ),
                                    child: const Icon(Icons.check, size: 14, color: Colors.green),
                                  ),
                                  const SizedBox(width: 12),

                                  // File name and size
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        uploadedFileName,
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500,
                                          color: Color(0xFF505050),
                                          height: 1.0,
                                        ),
                                      ),
                                      if (fileSize != null) ...[
                                        const SizedBox(height: 4),
                                        Text(
                                          '${(fileSize! / 1024).toStringAsFixed(1)} KB',
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400,
                                            color: Color(0xFF999999),
                                            height: 1.0,
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                  const SizedBox(width: 12),

                                  // File type
                                  Text(
                                    fileType,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                      color: Color(0xFF999999),
                                      height: 1.0,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // Middle section with options
                            Padding(
                              padding: const EdgeInsets.fromLTRB(56, 0, 24, 24),
                              child: const Text(
                                'Rename\nDelete\nAssign to Folder\nEnable Audio Narration',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black,
                                  height: 1.125,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],

                    const Spacer(),

                    // Bottom buttons
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: isFileUploaded ? _processDisplayAsIs : _uploadFile,
                              child: Container(
                                height: 44,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(color: const Color(0xFFB0B0B0)),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Center(
                                  child: Text(
                                    'display as is',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.black,
                                      height: 1.21,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: GestureDetector(
                              onTap: isFileUploaded ? _processExtractText : null,
                              child: Container(
                                height: 44,
                                decoration: BoxDecoration(
                                  color: isFileUploaded ? Colors.white : Colors.grey[300],
                                  border: Border.all(color: const Color(0xFFB0B0B0)),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Center(
                                  child: Text(
                                    'extract text',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                      color: isFileUploaded ? Colors.black : Colors.grey,
                                      height: 1.21,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Bottom Navigation
            const BottomNavigationComponent(currentRoute: '/upload'),
          ],
        ),
      ),
    );
  }
}
