import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../widgets/bottom_navigation_component.dart';

class HelpScreen extends StatefulWidget {
  const HelpScreen({super.key});

  @override
  State<HelpScreen> createState() => _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: Column(
                  children: [
                    const SizedBox(height: 32),
                    // Help & Support 제목
                    Text(
                      'Help & Support',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 28,
                        fontWeight: FontWeight.w400,
                        color: Theme.of(context).textTheme.titleLarge?.color,
                        height: 1.46,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    // 검색바
                    _buildSearchBar(),
                    const SizedBox(height: 24),
                    // FAQ 버튼
                    Card(
                      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      elevation: 2,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: _buildSectionButton('Expandable FAQ', onTap: () => _navigateToFAQ()),
                    ),
                    const SizedBox(height: 12),
                    // Contact Support 섹션
                    Card(
                      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      elevation: 2,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: _buildContactSupportSection(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Community resources 버튼
                    Card(
                      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      elevation: 2,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: _buildSectionButton(
                        'Community resources',
                        onTap: () => _navigateToCommunity(),
                      ),
                    ),
                    const SizedBox(height: 22),
                  ],
                ),
              ),
            ),
            // Bottom Navigation
            const BottomNavigationComponent(currentRoute: '/help'),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      width: double.infinity,
      height: 44,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFEFEFEF),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          // 검색 아이콘
          const Icon(Icons.search, size: 28, color: Color(0x993C3C43)),

          const SizedBox(width: 8),

          // 검색 입력 필드
          Expanded(
            child: TextField(
              controller: _searchController,
              style: TextStyle(
                fontFamily: 'SF Pro Text',
                fontSize: 17,
                fontWeight: FontWeight.w400,
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white
                    : Colors.black,
              ),
              decoration: const InputDecoration(
                hintText: 'Search',
                hintStyle: TextStyle(
                  fontFamily: 'SF Pro Text',
                  fontSize: 17,
                  fontWeight: FontWeight.w400,
                  color: Color(0x993C3C43),
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.zero,
              ),
              onSubmitted: (value) => _performSearch(value),
            ),
          ),

          const SizedBox(width: 8),

          // 마이크 아이콘
          GestureDetector(
            onTap: () => _startVoiceSearch(),
            child: Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Icon(Icons.mic, size: 16, color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionButton(String title, {required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 44,
        decoration: BoxDecoration(
          color: const Color(0xFF4E4E4E),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 23, top: 13),
          child: Text(
            title,
            style: const TextStyle(
              fontFamily: 'Pretendard Variable',
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.white,
              height: 1.0,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContactSupportSection() {
    return Column(
      children: [
        // Contact Support 헤더
        _buildSectionButton('Contact Support', onTap: () {}),

        const SizedBox(height: 8),

        // Call 버튼
        _buildContactButton(
          icon: Icons.phone_outlined,
          label: 'Call',
          onTap: () => _makePhoneCall(),
        ),

        const SizedBox(height: 8),

        // Email 버튼
        _buildContactButton(icon: Icons.email_outlined, label: 'Email', onTap: () => _sendEmail()),
      ],
    );
  }

  Widget _buildContactButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          children: [
            Icon(icon, size: 24, color: Theme.of(context).textTheme.bodyLarge?.color),
            const SizedBox(width: 12),
            Text(
              label,
              style: TextStyle(
                fontFamily: 'Pretendard Variable',
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).textTheme.bodyLarge?.color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 검색 기능
  void _performSearch(String query) {
    if (query.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Search: $query'),
          backgroundColor: Colors.blue,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  // 음성 검색
  void _startVoiceSearch() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Starting voice search...'),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
      ),
    );
  }

  // FAQ 페이지로 이동
  void _navigateToFAQ() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => const FAQScreen()));
  }

  // 커뮤니티 리소스 페이지로 이동
  void _navigateToCommunity() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Navigating to community resources page.'),
        backgroundColor: Colors.blue,
        duration: Duration(seconds: 2),
      ),
    );
  }

  // 전화 걸기
  void _makePhoneCall() async {
    final Uri phoneUri = Uri(scheme: 'tel', path: '+82-2-1234-5678');
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Cannot make a phone call'), backgroundColor: Colors.red),
        );
      }
    }
  }

  // 이메일 보내기
  void _sendEmail() async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: 'support@tactiread.com',
      query: 'subject=TactiRead Support Request&body=Hello,%0A%0APlease enter your inquiry.',
    );
    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Cannot open email app'), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}

// FAQ 화면
class FAQScreen extends StatefulWidget {
  const FAQScreen({super.key});

  @override
  State<FAQScreen> createState() => _FAQScreenState();
}

class _FAQScreenState extends State<FAQScreen> {
  int _selectedCategoryIndex = 0;

  final List<String> _categories = [
    'Start',
    'Document Upload',
    'Braille Reading',
    'Device Connection',
    'Settings',
    'Troubleshooting',
  ];

  final Map<String, List<Map<String, String>>> _helpContent = {
    'Start': [
      {
        'question': 'What is TactiRead?',
        'answer':
            'TactiRead is a braille reading solution for the visually impaired. It converts regular text documents into braille for reading on a braille display.',
      },
      {
        'question': 'What should I do when I first use it?',
        'answer':
            '1. Check accessibility settings\n2. Connect the braille display\n3. Try uploading your first document\n4. Learn about features through the tutorial',
      },
      {
        'question': 'What file formats are supported?',
        'answer':
            'PDF, Microsoft Word(.docx), Text files(.txt), and image-to-text extraction are supported.',
      },
    ],
    'Document Upload': [
      {
        'question': 'How do I upload a document?',
        'answer':
            '1. Tap the "Add Document" button on the home screen\n2. Choose from "Select from Files", "Capture with Camera", or "Import from Web"\n3. Once you select a file, it will be automatically converted to braille',
      },
      {
        'question': 'Can I take a picture of a document with the camera?',
        'answer':
            'Yes, you can use the camera to take a picture of a printed document, and it will extract the text using OCR technology and convert it to braille.',
      },
      {
        'question': 'Where are uploaded files stored?',
        'answer':
            'Uploaded files are securely stored in the app\'s internal storage and can be accessed anytime from My Library.',
      },
    ],
    'Braille Reading': [
      {
        'question': 'Can I adjust the reading speed?',
        'answer':
            'Yes, you can adjust the reading speed using the speed slider on the reading screen, from 10% to 100%.',
      },
      {
        'question': 'How do I add a bookmark?',
        'answer':
            'You can add a bookmark by tapping the bookmark icon at the top while reading, or by using the bookmark button at the bottom to add a bookmark at the current position.',
      },
      {
        'question': 'How do I navigate to a specific page?',
        'answer':
            'You can use the table of contents button to navigate by chapter, or use the search function to find specific text and jump to it.',
      },
    ],
    'Device Connection': [
      {
        'question': 'What braille displays are supported?',
        'answer':
            'Braille Sense, Focus Blue, BrailleNote Touch and most Bluetooth braille displays are supported.',
      },
      {
        'question': 'What should I do if the device connection fails?',
        'answer':
            '1. Check if the braille display is in pairing mode\n2. Turn Bluetooth off and on again\n3. Try refreshing the app\n4. Restart the device',
      },
      {
        'question': 'Can I check the battery status?',
        'answer':
            'Yes, you can check the battery status of the connected braille display on the device connection screen.',
      },
    ],
    'Settings': [
      {
        'question': 'How do I change accessibility settings?',
        'answer':
            'You can adjust voice guidance, large text, high contrast mode, and more in Settings > Accessibility.',
      },
      {
        'question': 'What is braille grade?',
        'answer':
            'Grade 1 represents all letters in full spelling, while Grade 2 uses contractions for more efficient reading.',
      },
      {
        'question': 'Can I back up my data?',
        'answer':
            'Yes, you can back up and restore settings, bookmarks, and reading progress to the cloud in Settings > Account.',
      },
    ],
    'Troubleshooting': [
      {
        'question': 'The app is running slowly',
        'answer':
            '1. Try closing other apps\n2. Restart the device\n3. Update the app to the latest version\n4. Check storage space',
      },
      {
        'question': 'Voice guidance is not working',
        'answer':
            'Check if voice guidance is enabled in Settings > Accessibility, and also check the device\'s accessibility settings.',
      },
      {
        'question': 'Document conversion failed',
        'answer':
            '1. Check if the file format is supported\n2. Check if the file size is not too large\n3. Check your internet connection\n4. Try again later',
      },
    ],
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('FAQ'),
        backgroundColor: Theme.of(context).brightness == Brightness.dark
            ? Colors.black
            : Colors.white,
        foregroundColor: Theme.of(context).brightness == Brightness.dark
            ? Colors.white
            : Colors.black,
      ),
      body: Column(
        children: [
          Expanded(
            child: Row(
              children: [
                // 카테고리 사이드바
                Container(
                  width: 120,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.grey.shade800
                      : Colors.grey.shade100,
                  child: ListView.builder(
                    itemCount: _categories.length,
                    itemBuilder: (context, index) {
                      final isSelected = index == _selectedCategoryIndex;
                      return Container(
                        margin: const EdgeInsets.symmetric(vertical: 2, horizontal: 4),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? (Theme.of(context).brightness == Brightness.dark
                                    ? Colors.white
                                    : Colors.black)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: ListTile(
                          dense: true,
                          title: Text(
                            _categories[index],
                            style: TextStyle(
                              fontSize: 12,
                              color: isSelected
                                  ? (Theme.of(context).brightness == Brightness.dark
                                        ? Colors.black
                                        : Colors.white)
                                  : Theme.of(context).textTheme.bodyMedium?.color,
                              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                            ),
                          ),
                          onTap: () {
                            setState(() {
                              _selectedCategoryIndex = index;
                            });
                          },
                        ),
                      );
                    },
                  ),
                ),

                // 내용 영역
                Expanded(
                  child: Column(
                    children: [
                      // 카테고리 제목
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.grey.shade800
                            : Colors.grey.shade200,
                        child: Text(
                          _categories[_selectedCategoryIndex],
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            color: Theme.of(context).textTheme.titleLarge?.color,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      // FAQ 목록
                      Expanded(
                        child: ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: _helpContent[_categories[_selectedCategoryIndex]]?.length ?? 0,
                          itemBuilder: (context, index) {
                            final item = _helpContent[_categories[_selectedCategoryIndex]]![index];
                            return _buildFAQItem(item['question']!, item['answer']!);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Bottom Navigation
          const BottomNavigationComponent(currentRoute: '/help'),
        ],
      ),
    );
  }

  Widget _buildFAQItem(String question, String answer) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: Theme.of(context).cardColor,
      child: ExpansionTile(
        title: Text(
          question,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 16,
            color: Theme.of(context).textTheme.titleMedium?.color,
          ),
        ),
        iconColor: Theme.of(context).textTheme.bodyLarge?.color,
        collapsedIconColor: Theme.of(context).textTheme.bodyLarge?.color,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                answer,
                style: TextStyle(color: Theme.of(context).textTheme.bodyMedium?.color, height: 1.5),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
