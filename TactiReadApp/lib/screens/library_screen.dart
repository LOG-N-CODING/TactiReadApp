import 'package:flutter/material.dart';
import '../widgets/bottom_navigation_component.dart';
import '../services/user_session_service.dart';
import '../services/file_upload_service.dart';
import '../database/database_helper.dart';
import '../database/models/document_model.dart';
import '../database/models/user_model.dart';

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  String selectedFilter = 'All Files';
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

      setState(() {
        documentList = documents;
        filteredDocuments = List.from(documents);
        isLoading = false;
      });
      _applyFilter(selectedFilter);
    } catch (e) {
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
      await _loadDocuments();

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

      setState(() {
        filteredDocuments = documents;
        isLoading = false;
      });
    } catch (e) {
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
          await _loadDocuments();
          _applyFilter(selectedFilter);
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
      await _databaseHelper.updateDocumentLastAccessed(document.id!);

      if (mounted) {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Library',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: Theme.of(context).textTheme.titleLarge?.color,
            fontFamily: 'Inter',
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.add, color: Theme.of(context).iconTheme.color),
            onPressed: _uploadFile,
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 검색바
              Container(
                height: 44,
                decoration: BoxDecoration(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.grey.shade800
                      : const Color(0xFFEFEFEF),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    const SizedBox(width: 8),
                    Icon(
                      Icons.search,
                      color: Theme.of(context).iconTheme.color?.withOpacity(0.6),
                      size: 28,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        onChanged: _filterFiles,
                        decoration: InputDecoration(
                          hintText: 'Search documents...',
                          hintStyle: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w400,
                            color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.6),
                            letterSpacing: -0.024,
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.zero,
                        ),
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w400,
                          color: Theme.of(context).textTheme.bodyLarge?.color,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // 필터 및 정렬 옵션
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: _showFilterMenu,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.grey.shade800
                              : Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.filter_list,
                              size: 20,
                              color: Theme.of(context).iconTheme.color,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                selectedFilter,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Theme.of(context).textTheme.bodyMedium?.color,
                                  fontFamily: 'Inter',
                                ),
                              ),
                            ),
                            Icon(
                              Icons.keyboard_arrow_down,
                              size: 20,
                              color: Theme.of(context).iconTheme.color,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // 문서 목록
              Expanded(
                child: isLoading
                    ? Center(
                        child: CircularProgressIndicator(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      )
                    : filteredDocuments.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.library_books_outlined,
                              size: 64,
                              color: Theme.of(context).iconTheme.color?.withOpacity(0.3),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'No documents found',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                                color: Theme.of(context).textTheme.titleMedium?.color,
                                fontFamily: 'Inter',
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Tap the + button to upload a file',
                              style: TextStyle(
                                fontSize: 14,
                                color: Theme.of(
                                  context,
                                ).textTheme.bodyMedium?.color?.withOpacity(0.7),
                                fontFamily: 'Inter',
                              ),
                            ),
                          ],
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
      bottomNavigationBar: const BottomNavigationComponent(currentRoute: '/library'),
    );
  }

  Widget _buildDocumentItem(Document document, int index) {
    return GestureDetector(
      onTap: () => _selectDocument(document),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.dark
              ? Colors.grey.shade800.withOpacity(0.5)
              : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Theme.of(context).dividerColor.withOpacity(0.2)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // 문서 타입 아이콘
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    _getDocumentIcon(document.fileType),
                    size: 20,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                const SizedBox(width: 12),
                // 문서 정보
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        document.fileName,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).textTheme.titleMedium?.color,
                          fontFamily: 'Inter',
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${document.fileType.toUpperCase()} • ${(document.fileSize / 1024).toStringAsFixed(1)} KB',
                        style: TextStyle(
                          fontSize: 12,
                          color: Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.7),
                          fontFamily: 'Inter',
                        ),
                      ),
                    ],
                  ),
                ),
                // 더보기 메뉴
                IconButton(
                  icon: Icon(Icons.more_vert, color: Theme.of(context).iconTheme.color),
                  onPressed: () {
                    _showDocumentMenu(context, document);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  IconData _getDocumentIcon(String type) {
    switch (type.toLowerCase()) {
      case 'pdf':
        return Icons.picture_as_pdf;
      case 'txt':
      case 'doc':
      case 'docx':
        return Icons.description;
      case 'epub':
        return Icons.menu_book;
      case 'png':
      case 'jpg':
      case 'jpeg':
      case 'gif':
        return Icons.image;
      default:
        return Icons.insert_drive_file;
    }
  }

  void _showDocumentMenu(BuildContext context, Document document) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.play_arrow, color: Theme.of(context).iconTheme.color),
              title: Text(
                'Continue Reading',
                style: TextStyle(color: Theme.of(context).textTheme.titleMedium?.color),
              ),
              onTap: () {
                Navigator.pop(context);
                _selectDocument(document);
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.red),
              title: const Text('Delete', style: TextStyle(color: Colors.red)),
              onTap: () {
                Navigator.pop(context);
                _showDeleteConfirmationDialog(document);
              },
            ),
          ],
        ),
      ),
    );
  }
}
