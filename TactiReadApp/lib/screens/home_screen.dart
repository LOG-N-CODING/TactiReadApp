import 'package:flutter/material.dart';
import '../widgets/bottom_navigation_component.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isVoiceAssistEnabled = false;
  String selectedFilter = 'Favorites';
  final TextEditingController _searchController = TextEditingController();
  List<String> filterOptions = ['Favorites', 'Recent', 'All Files', 'PDF', 'Images'];
  List<Map<String, String>> fileList = [
    {'name': 'abcd.png', 'size': '13MB'},
    {'name': 'document.pdf', 'size': '2.5MB'},
    {'name': 'notes.txt', 'size': '1.2MB'},
    {'name': 'presentation.pptx', 'size': '8.7MB'},
    {'name': 'image.jpg', 'size': '4.3MB'},
  ];
  List<Map<String, String>> filteredFiles = [];

  @override
  void initState() {
    super.initState();
    filteredFiles = List.from(fileList);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterFiles(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredFiles = List.from(fileList);
      } else {
        filteredFiles = fileList
            .where((file) => file['name']!.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  void _showFilterMenu() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Filter Files',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 20),
              ...filterOptions.map((option) => ListTile(
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
              )).toList(),
            ],
          ),
        );
      },
    );
  }

  void _applyFilter(String filter) {
    setState(() {
      switch (filter) {
        case 'PDF':
          filteredFiles = fileList.where((file) => file['name']!.endsWith('.pdf')).toList();
          break;
        case 'Images':
          filteredFiles = fileList.where((file) => 
            file['name']!.endsWith('.png') || 
            file['name']!.endsWith('.jpg') || 
            file['name']!.endsWith('.jpeg')).toList();
          break;
        case 'Recent':
          filteredFiles = fileList.take(3).toList();
          break;
        case 'Favorites':
          filteredFiles = fileList.take(2).toList();
          break;
        default:
          filteredFiles = List.from(fileList);
      }
    });
  }

  void _startVoiceSearch() {
    if (isVoiceAssistEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('음성 검색을 시작합니다...'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );
      // Here you would implement actual voice recognition
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('먼저 Voice Assist를 활성화해주세요.'),
          backgroundColor: Colors.orange,
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 40),
            
            // Greeting Message
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 41),
              child: Text(
                'Greeting message',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w400,
                  color: Colors.black,
                  height: 1.46,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            
            const SizedBox(height: 35),
            
            // Voice Assist Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 41),
              child: Column(
                children: [
                  const Text(
                    'voice assist',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                      height: 1.46,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  
                  // Voice Assist Toggle Button
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        isVoiceAssistEnabled = !isVoiceAssistEnabled;
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(isVoiceAssistEnabled 
                            ? 'Voice Assist가 활성화되었습니다.' 
                            : 'Voice Assist가 비활성화되었습니다.'),
                          backgroundColor: isVoiceAssistEnabled ? Colors.green : Colors.grey,
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    },
                    child: Container(
                      width: 72,
                      height: 72,
                      decoration: BoxDecoration(
                        color: isVoiceAssistEnabled ? Colors.green : Colors.black,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Icon(
                          Icons.volume_up,
                          color: Colors.white,
                          size: 40,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 73),
            
            // Search Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 38),
              child: Container(
                height: 44,
                decoration: BoxDecoration(
                  color: const Color(0xFFEFEFEF),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    const SizedBox(width: 8),
                    const Icon(
                      Icons.search,
                      color: Color(0x993C3C43),
                      size: 28,
                    ),
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
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
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
                        child: const Icon(
                          Icons.mic,
                          color: Colors.black,
                          size: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 39),
            
            // Document List Section
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 41),
                child: Column(
                  children: [
                    const Text(
                      'Document list',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                        color: Colors.black,
                        height: 1.46,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    
                    // Upload Button
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, '/upload');
                      },
                      child: Container(
                        width: 141,
                        height: 44,
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(5),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 20,
                              offset: const Offset(0, 0),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.add,
                                color: Colors.black,
                                size: 24,
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              'upload',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                                height: 1.56,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    
                    // Document List Container
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
                          child: Column(
                            children: [
                              // Favorites Filter
                              GestureDetector(
                                onTap: _showFilterMenu,
                                child: Container(
                                  width: 142,
                                  height: 44,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(color: const Color(0xFFB0B0B0)),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        selectedFilter,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.black,
                                          height: 1.46,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      const Icon(
                                        Icons.keyboard_arrow_down,
                                        color: Colors.black,
                                        size: 24,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 12),
                              
                              // File List
                              Expanded(
                                child: ListView.builder(
                                  itemCount: filteredFiles.length,
                                  itemBuilder: (context, index) {
                                    final file = filteredFiles[index];
                                    return _buildFileItem(file['name']!, file['size']!, index);
                                  },
                                ),
                              ),
                            ],
                          ),
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

  Widget _buildFileItem(String fileName, String fileSize, int index) {
    return GestureDetector(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$fileName 파일을 선택했습니다.'),
            backgroundColor: Colors.blue,
            duration: const Duration(seconds: 2),
          ),
        );
        // Navigate to file viewer or perform action
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          color: Colors.transparent,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                fileName,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  height: 1.21,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Text(
              fileSize,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: Color(0xFFCBCBCB),
                height: 1.21,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
