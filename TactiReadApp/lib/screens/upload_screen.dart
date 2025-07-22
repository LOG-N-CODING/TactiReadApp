import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import '../widgets/bottom_navigation_component.dart';

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
            content: Text('파일 "${file.name}"이 성공적으로 선택되었습니다!'),
            backgroundColor: Colors.green,
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

  Future<void> _uploadFromDevice() async {
    await _uploadFile();
  }

  Future<void> _importFromCloud() async {
    // 클라우드 연동 기능은 향후 구현
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('클라우드 연동 기능은 준비 중입니다.'),
        backgroundColor: Colors.orange,
        duration: Duration(seconds: 2),
      ),
    );
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
                                    child: const Icon(
                                      Icons.check,
                                      size: 14,
                                      color: Colors.green,
                                    ),
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
                              onTap: _uploadFromDevice,
                              child: Container(
                                height: 44,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(color: const Color(0xFFB0B0B0)),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Center(
                                  child: Text(
                                    'Upload from Device',
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
                              onTap: _importFromCloud,
                              child: Container(
                                height: 44,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(color: const Color(0xFFB0B0B0)),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Center(
                                  child: Text(
                                    'Import from Cloud',
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
