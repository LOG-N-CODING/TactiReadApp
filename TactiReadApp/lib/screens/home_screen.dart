import 'package:flutter/material.dart';
import '../widgets/bottom_navigation_component.dart';
import '../services/user_session_service.dart';
import '../services/file_upload_service.dart';
import '../database/database_helper.dart';
import '../database/models/document_model.dart';
import '../database/models/user_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isVoiceAssistEnabled = false;
  String selectedFilter = 'All Files'; // 기본 필터를 'All Files'로 변경
  final TextEditingController _searchController = TextEditingController();
  final FileUploadService _fileUploadService = FileUploadService();
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  List<String> filterOptions = ['All Files', 'Favorites', 'Recent', 'PDF', 'Images'];
  List<Document> documentList = [];
  List<Document> filteredDocuments = [];
  User? currentUser;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _initializeScreen();
  }

  // 화면 초기화
  Future<void> _initializeScreen() async {
    await _checkAuthentication();
    if (currentUser != null) {
      await _loadDocuments();
    }
  }

  // 인증 상태 확인
  Future<void> _checkAuthentication() async {
    try {
      User? user = await UserSessionService.getCurrentUser();
      if (user != null && mounted) {
        setState(() {
          currentUser = user;
        });
      } else if (mounted) {
        // 로그인되지 않은 경우 로그인 화면으로 리다이렉트
        Navigator.pushNamed(context, '/sign_in');
      }
    } catch (e) {
      if (mounted) {
        Navigator.pushNamed(context, '/sign_in');
      }
    }
  }

  // 문서 목록 로드
  Future<void> _loadDocuments() async {
    if (currentUser == null) return;

    setState(() {
      isLoading = true;
    });

    try {
      List<Document> documents = await _databaseHelper.getDocumentsByUserId(currentUser!.id!);
      print('Number of documents loaded from DB: ${documents.length}');
      for (var doc in documents) {
        print('Document: ${doc.fileName} (ID: ${doc.id})');
      }

      setState(() {
        documentList = documents;
        filteredDocuments = List.from(documents);
        isLoading = false;
      });
      _applyFilter(selectedFilter);
    } catch (e) {
      print('Error loading documents: $e');
      setState(() {
        isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('An error occurred while loading documents: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // 문서 삭제
  Future<void> _deleteDocument(Document document) async {
    try {
      await _databaseHelper.deleteDocument(document.id!);
      await _loadDocuments(); // 목록 새로고침

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${document.fileName} has been deleted.'),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('An error occurred while deleting: ${e.toString()}'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  // 삭제 확인 다이얼로그
  void _showDeleteConfirmationDialog(Document document) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Document'),
        content: Text(
          'Are you sure you want to delete ${document.fileName}?\nThis action cannot be undone.',
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteDocument(document);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _filterFiles(String query) async {
    if (currentUser == null) return;

    setState(() {
      isLoading = true;
    });

    try {
      List<Document> searchResults;
      if (query.isEmpty) {
        searchResults = await _databaseHelper.getDocumentsByUserId(currentUser!.id!);
      } else {
        searchResults = await _databaseHelper.searchDocuments(currentUser!.id!, query);
      }

      setState(() {
        filteredDocuments = searchResults;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _showFilterMenu() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Filter Files',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).textTheme.titleLarge?.color,
                ),
              ),
              const SizedBox(height: 20),
              ...filterOptions
                  .map(
                    (option) => ListTile(
                      title: Text(option),
                      trailing: selectedFilter == option
                          ? const Icon(Icons.check, color: Colors.green)
                          : null,
                      onTap: () {
                        setState(() {
                          selectedFilter = option;
                        });
                        Navigator.pop(context);
                        _applyFilter(option);
                      },
                    ),
                  )
                  .toList(),
            ],
          ),
        );
      },
    );
  }

  void _applyFilter(String filter) async {
    if (currentUser == null) return;

    setState(() {
      isLoading = true;
      selectedFilter = filter;
    });

    try {
      List<Document> documents;
      print('Applying filter: $filter');

      switch (filter) {
        case 'PDF':
          documents = await _databaseHelper.getDocumentsByType(currentUser!.id!, 'pdf');
          break;
        case 'Images':
          documents = await _databaseHelper.getDocumentsByUserId(currentUser!.id!);
          documents = documents
              .where((doc) => ['png', 'jpg', 'jpeg'].contains(doc.fileType.toLowerCase()))
              .toList();
          break;
        case 'Recent':
          documents = await _databaseHelper.getRecentDocuments(currentUser!.id!, limit: 10);
          break;
        case 'Favorites':
          documents = await _databaseHelper.getFavoriteDocuments(currentUser!.id!);
          break;
        default: // 'All Files'
          documents = await _databaseHelper.getDocumentsByUserId(currentUser!.id!);
      }

      print('Number of documents after applying filter: ${documents.length}');

      setState(() {
        filteredDocuments = documents;
        isLoading = false;
      });
    } catch (e) {
      print('Error applying filter: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  // 파일 업로드
  Future<void> _uploadFile() async {
    setState(() {
      isLoading = true;
    });

    try {
      FileUploadResult result = await _fileUploadService.pickAndUploadFile();

      setState(() {
        isLoading = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result.message),
            backgroundColor: result.success ? Colors.green : Colors.red,
            duration: const Duration(seconds: 2),
          ),
        );

        if (result.success) {
          // Debug log added
          print('Upload successful, refreshing document list started');

          // 문서 목록 새로고침
          await _loadDocuments();

          // 필터 재적용
          _applyFilter(selectedFilter);

          print('Document list refreshed, current document count: ${filteredDocuments.length}');
        }
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('An error occurred while uploading the file: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  // 파일 선택 시 reading_screen으로 이동
  void _selectDocument(Document document) async {
    try {
      // 마지막 접근 시간 업데이트
      await _databaseHelper.updateDocumentLastAccessed(document.id!);

      if (mounted) {
        // reading_screen으로 파일 정보와 함께 이동
        Navigator.pushNamed(
          context,
          '/reading',
          arguments: {
            'document': document,
            'fileName': document.fileName,
            'filePath': document.filePath,
            'fileType': document.fileType,
          },
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('An error occurred while opening the file: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _startVoiceSearch() {
    if (isVoiceAssistEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Starting voice search...'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );
      // Here you would implement actual voice recognition
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enable Voice Assist first.'),
          backgroundColor: Colors.orange,
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 40),

            // Greeting Message
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                'Greeting message',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w400,
                  color: Theme.of(context).textTheme.titleLarge?.color,
                  height: 1.46,
                ),
                textAlign: TextAlign.center,
              ),
            ),

            const SizedBox(height: 50),

            // Search Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Container(
                height: 44,
                decoration: BoxDecoration(
                  color: const Color(0xFFEFEFEF),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    const SizedBox(width: 8),
                    const Icon(Icons.search, color: Color(0x993C3C43), size: 28),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        onChanged: _filterFiles,
                        decoration: const InputDecoration(
                          hintText: 'Search',
                          hintStyle: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w400,
                            color: Color(0x993C3C43),
                            letterSpacing: -0.024,
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.zero,
                        ),
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w400,
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.white
                              : Colors.black,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: _startVoiceSearch,
                      child: Container(
                        width: 24,
                        height: 24,
                        margin: const EdgeInsets.only(right: 8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Icon(Icons.mic, color: Colors.black, size: 16),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Document List Section
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  children: [
                    Text(
                      'Document list',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                        color: Theme.of(context).textTheme.bodyLarge?.color,
                        height: 1.46,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),

                    // Document List Container
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Theme.of(context).brightness == Brightness.dark
                            ? Theme.of(context).cardTheme.color ?? const Color(0xFF2C2C2E)
                            : Theme.of(context).cardTheme.color ?? Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(16, 16, 16, 16), // 좌우 패딩 줄임
                          child: Column(
                            children: [
                              // Filter Button
                              GestureDetector(
                                onTap: _showFilterMenu,
                                child: Container(
                                  width: 142,
                                  height: 44,
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).brightness == Brightness.dark
                                        ? const Color(0xFF3C3C3E)
                                        : Colors.white,
                                    border: Border.all(
                                      color: Theme.of(context).brightness == Brightness.dark
                                          ? const Color(0xFF48484A)
                                          : const Color(0xFFB0B0B0),
                                    ),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        selectedFilter,
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400,
                                          color: Theme.of(context).brightness == Brightness.dark
                                              ? Colors.white
                                              : Colors.black,
                                          height: 1.46,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Icon(
                                        Icons.keyboard_arrow_down,
                                        color: Theme.of(context).brightness == Brightness.dark
                                            ? Colors.white
                                            : Colors.black,
                                        size: 24,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 12),

                              // Document List
                              Expanded(
                                child: isLoading
                                    ? const Center(
                                        child: CircularProgressIndicator(color: Colors.white),
                                      )
                                    : filteredDocuments.isEmpty
                                    ? Center(
                                        child: Text(
                                          'No documents found.\nPlease tap the Upload button above to upload a file.',
                                          style: TextStyle(
                                          fontSize: 16,
                                          color: Theme.of(context).textTheme.bodyLarge?.color,
                                          height: 1.5,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      )
                                    : ListView.builder(
                                        itemCount: filteredDocuments.length,
                                        itemBuilder: (context, index) {
                                          final document = filteredDocuments[index];
                                          return _buildDocumentItem(document, index);
                                        },
                                      ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 20),

                    // Upload Button
                    GestureDetector(
                      onTap: _uploadFile,
                      child: Container(
                        width: double.infinity,
                        height: 60,
                        decoration: BoxDecoration(
                          color: Theme.of(context).brightness == Brightness.dark
                            ? const Color(0xFF1E1E1E)
                            : const Color(0xFF1976D2), // 라이트 모드에서 파란색 계열
                          borderRadius: BorderRadius.circular(5),
                          boxShadow: [
                          BoxShadow(
                            color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.white.withOpacity(0.1)
                              : const Color(0xFF1976D2).withOpacity(0.2), // 라이트 모드에서 파란색 그림자
                            blurRadius: 20,
                            offset: const Offset(0, 0),
                          ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.upload_file,
                              color: Theme.of(context).brightness == Brightness.dark
                                  ? Colors.white
                                  : Colors.white,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Upload',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Theme.of(context).brightness == Brightness.dark
                                    ? Colors.white
                                    : Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Bottom Navigation
            const BottomNavigationComponent(currentRoute: '/home'),
          ],
        ),
      ),
    );
  }

  Widget _buildDocumentItem(Document document, int index) {
    return GestureDetector(
      onTap: () => _selectDocument(document),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          color: Colors.transparent,
        ),
        child: Row(
          children: [
            // 파일 아이콘
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
              color: Theme.of(context).cardTheme.color ?? Colors.white,
              borderRadius: BorderRadius.circular(4),
              ),
              child: Icon(
              document.fileType.toLowerCase() == 'pdf'
                ? Icons.picture_as_pdf
                : (['png', 'jpg', 'jpeg'].contains(document.fileType.toLowerCase())
                  ? Icons.image
                  : Icons.insert_drive_file),
              color: Theme.of(context).iconTheme.color,
              size: 20,
              ),
            ),
            const SizedBox(width: 8),
            // 파일명 (확장된 영역)
            Expanded(
              flex: 3,
              child: Text(
              document.fileName,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: Theme.of(context).textTheme.bodyLarge?.color,
                height: 1.21,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              ),
            ),
            const SizedBox(width: 8),
            // 파일 크기
            Expanded(
              flex: 1,
              child: Text(
              '${(document.fileSize / 1024).toStringAsFixed(1)} KB',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.7),
                height: 1.21,
              ),
              textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(width: 8),
            // 삭제 버튼
            GestureDetector(
              onTap: () => _showDeleteConfirmationDialog(document),
              child: Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Icon(Icons.delete_outline, color: Colors.white, size: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
