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
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 39),
                child: Column(
                  children: [
                    const SizedBox(height: 65),

                    // Help & Support 제목
                    const Text(
                      'Help & Support',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 28,
                        fontWeight: FontWeight.w400,
                        color: Colors.black,
                        height: 1.46,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 98),

                    // 검색바
                    _buildSearchBar(),

                    const SizedBox(height: 100),

                    // Expandable FAQ 버튼
                    _buildSectionButton('Expandable FAQ', onTap: () => _navigateToFAQ()),

                    const SizedBox(height: 22),

                    // Contact Support 섹션
                    _buildContactSupportSection(),

                    const SizedBox(height: 152),

                    // Community resources 버튼
                    _buildSectionButton('Community resources', onTap: () => _navigateToCommunity()),

                    const SizedBox(height: 30),
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
              style: const TextStyle(
                fontFamily: 'SF Pro Text',
                fontSize: 17,
                fontWeight: FontWeight.w400,
                color: Colors.black,
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
            Icon(icon, size: 24, color: Colors.black),
            const SizedBox(width: 12),
            Text(
              label,
              style: const TextStyle(
                fontFamily: 'Pretendard Variable',
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.black,
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
          content: Text('검색: $query'),
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
        content: Text('음성 검색을 시작합니다...'),
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
        content: Text('커뮤니티 리소스 페이지로 이동합니다.'),
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
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('전화를 걸 수 없습니다.'), backgroundColor: Colors.red));
      }
    }
  }

  // 이메일 보내기
  void _sendEmail() async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: 'support@tactiread.com',
      query: 'subject=TactiRead 지원 요청&body=안녕하세요,%0A%0A문의 내용을 입력해 주세요.',
    );
    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('이메일 앱을 열 수 없습니다.'), backgroundColor: Colors.red),
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

  final List<String> _categories = ['시작하기', '문서 업로드', '점자 읽기', '디바이스 연결', '설정', '문제 해결'];

  final Map<String, List<Map<String, String>>> _helpContent = {
    '시작하기': [
      {
        'question': 'TactiRead는 무엇인가요?',
        'answer': 'TactiRead는 시각장애인을 위한 점자 독서 솔루션입니다. 일반 텍스트 문서를 점자로 변환하여 점자 디스플레이로 읽을 수 있게 해줍니다.',
      },
      {
        'question': '처음 사용할 때 무엇을 해야 하나요?',
        'answer':
            '1. 접근성 설정을 확인하세요\n2. 점자 디스플레이를 연결하세요\n3. 첫 번째 문서를 업로드해보세요\n4. 튜토리얼을 통해 기능을 익혀보세요',
      },
      {
        'question': '어떤 파일 형식을 지원하나요?',
        'answer': 'PDF, Microsoft Word(.docx), 텍스트 파일(.txt), 그리고 이미지에서 텍스트 추출을 지원합니다.',
      },
    ],
    '문서 업로드': [
      {
        'question': '문서를 어떻게 업로드하나요?',
        'answer':
            '1. 홈 화면의 "문서 추가" 버튼을 누르세요\n2. "파일에서 선택", "카메라로 촬영", "웹에서 가져오기" 중 선택하세요\n3. 파일을 선택하면 자동으로 점자로 변환됩니다',
      },
      {
        'question': '카메라로 문서를 촬영할 수 있나요?',
        'answer': '네, 카메라를 사용해 인쇄된 문서를 촬영하면 OCR 기술을 통해 텍스트를 추출하고 점자로 변환합니다.',
      },
      {
        'question': '업로드한 파일은 어디에 저장되나요?',
        'answer': '업로드한 파일은 앱 내부 저장소에 안전하게 보관되며, 내 서재에서 언제든지 접근할 수 있습니다.',
      },
    ],
    '점자 읽기': [
      {
        'question': '점자 읽기 속도를 조절할 수 있나요?',
        'answer': '네, 읽기 화면에서 속도 슬라이더를 사용하여 10%부터 100%까지 조절할 수 있습니다.',
      },
      {
        'question': '북마크는 어떻게 추가하나요?',
        'answer': '읽기 중에 상단의 북마크 아이콘을 누르거나, 하단의 북마크 버튼을 사용하여 현재 위치에 북마크를 추가할 수 있습니다.',
      },
      {
        'question': '특정 페이지로 이동하려면?',
        'answer': '목차 버튼을 눌러 챕터별로 이동하거나, 검색 기능을 사용하여 특정 텍스트를 찾아 이동할 수 있습니다.',
      },
    ],
    '디바이스 연결': [
      {
        'question': '지원하는 점자 디스플레이는?',
        'answer': 'Braille Sense, Focus Blue, BrailleNote Touch 등 대부분의 블루투스 점자 디스플레이를 지원합니다.',
      },
      {
        'question': '디바이스 연결이 안 될 때는?',
        'answer':
            '1. 점자 디스플레이가 페어링 모드인지 확인하세요\n2. 블루투스를 껐다가 다시 켜보세요\n3. 앱에서 새로고침을 눌러보세요\n4. 디바이스를 재시작해보세요',
      },
      {
        'question': '배터리 상태를 확인할 수 있나요?',
        'answer': '네, 연결된 점자 디스플레이의 배터리 상태를 디바이스 연결 화면에서 확인할 수 있습니다.',
      },
    ],
    '설정': [
      {
        'question': '접근성 설정은 어떻게 변경하나요?',
        'answer': '설정 > 접근성에서 음성 안내, 큰 텍스트, 고대비 모드 등을 조절할 수 있습니다.',
      },
      {
        'question': '점자 등급이란 무엇인가요?',
        'answer': 'Grade 1은 전체 철자법으로 모든 글자를 표기하고, Grade 2는 단축 표기법으로 더 효율적인 읽기가 가능합니다.',
      },
      {
        'question': '데이터를 백업할 수 있나요?',
        'answer': '네, 설정 > 계정에서 설정, 북마크, 읽기 진행률을 클라우드에 백업하고 복원할 수 있습니다.',
      },
    ],
    '문제 해결': [
      {
        'question': '앱이 느리게 동작해요',
        'answer': '1. 다른 앱들을 종료해보세요\n2. 기기를 재시작해보세요\n3. 앱을 최신 버전으로 업데이트하세요\n4. 저장 공간을 확인해보세요',
      },
      {
        'question': '음성 안내가 작동하지 않아요',
        'answer': '설정 > 접근성에서 음성 안내가 켜져 있는지 확인하고, 기기의 접근성 설정도 확인해보세요.',
      },
      {
        'question': '문서 변환이 실패해요',
        'answer':
            '1. 파일 형식이 지원되는지 확인하세요\n2. 파일 크기가 너무 크지 않은지 확인하세요\n3. 인터넷 연결을 확인하세요\n4. 잠시 후 다시 시도해보세요',
      },
    ],
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FAQ'),
        backgroundColor: Colors.blue.shade600,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Expanded(
            child: Row(
              children: [
                // 카테고리 사이드바
                Container(
                  width: 120,
                  color: Colors.grey.shade100,
                  child: ListView.builder(
                    itemCount: _categories.length,
                    itemBuilder: (context, index) {
                      final isSelected = index == _selectedCategoryIndex;
                      return Container(
                        margin: const EdgeInsets.symmetric(vertical: 2, horizontal: 4),
                        decoration: BoxDecoration(
                          color: isSelected ? Colors.blue.shade600 : Colors.transparent,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: ListTile(
                          dense: true,
                          title: Text(
                            _categories[index],
                            style: TextStyle(
                              fontSize: 12,
                              color: isSelected ? Colors.white : Colors.grey.shade700,
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
                        color: Colors.blue.shade50,
                        child: Text(
                          _categories[_selectedCategoryIndex],
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            color: Colors.blue.shade700,
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
      child: ExpansionTile(
        title: Text(question, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16)),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(answer, style: TextStyle(color: Colors.grey.shade700, height: 1.5)),
            ),
          ),
        ],
      ),
    );
  }
}
