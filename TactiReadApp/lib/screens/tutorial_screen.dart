import 'package:flutter/material.dart';
import '../services/user_session_service.dart';

class TutorialScreen extends StatefulWidget {
  const TutorialScreen({super.key});

  @override
  State<TutorialScreen> createState() => _TutorialScreenState();
}

class _TutorialScreenState extends State<TutorialScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  bool _showingMainTutorial = true;
  String? _selectedDetailScreen;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _showingMainTutorial
          ? _buildMainTutorialScreen()
          : _selectedDetailScreen != null
          ? _buildDetailScreen(_selectedDetailScreen!)
          : _buildMainTutorialScreen(),
    );
  }

  Widget _buildMainTutorialScreen() {
    return SafeArea(
      child: Column(
        children: [
          // 진행률 표시 (기존 유지)
          Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${_currentPage + 1} / 5',
                      style: TextStyle(
                        color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.7),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      '${((_currentPage + 1) / 5 * 100).round()}%',
                      style: TextStyle(
                        color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.7),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                LinearProgressIndicator(
                  value: (_currentPage + 1) / 5,
                  backgroundColor: Theme.of(context).brightness == Brightness.dark
                      ? Colors.grey[700]
                      : Colors.grey.shade300,
                  valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
                ),
              ],
            ),
          ),

          // 메인 콘텐츠
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 제목
                  Center(
                    child: Text(
                      'Tutorial',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w400,
                        color: Theme.of(context).textTheme.titleLarge?.color,
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // 오디오 워크스루 시각화
                  _buildAudioVisualization(),
                  const SizedBox(height: 32),

                  // Start와 Skip 버튼
                  _buildActionButtons(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAudioVisualization() {
    return Container(
      width: double.infinity,
      height: 200,
      padding: const EdgeInsets.all(20),
      child: Center(
        child: Image.asset(
          'assets/images/audio_visualization.png',
          width: 200,
          height: 200,
          fit: BoxFit.contain,
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Start 버튼
          GestureDetector(
            onTap: () {
              setState(() {
                _showingMainTutorial = false;
                _selectedDetailScreen = 'home';
                _currentPage = 0;
              });
            },
            child: Container(
              width: 127,
              height: 51,
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.grey[800]
                    : Colors.white,
                border: Border.all(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.grey[600]!
                      : const Color(0xFFB0B0B0),
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Center(
                child: Text(
                  'Start',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Theme.of(context).textTheme.bodyMedium?.color,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Skip 버튼
          GestureDetector(
            onTap: () async {
              await UserSessionService.setTutorialCompleted();
              Navigator.pushReplacementNamed(context, '/home');
            },
            child: Container(
              width: 127,
              height: 51,
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.grey[800]
                    : Colors.white,
                border: Border.all(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.grey[600]!
                      : const Color(0xFFB0B0B0),
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Center(
                child: Text(
                  'Skip',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Theme.of(context).textTheme.bodyMedium?.color,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailScreen(String screenType) {
    switch (screenType) {
      case 'home':
        return _buildHomeDetailScreen();
      case 'upload':
        return _buildUploadDetailScreen();
      case 'reading':
        return _buildReadingDetailScreen();
      case 'help':
        return _buildHelpDetailScreen();
      case 'settings':
        return _buildSettingsDetailScreen();
      default:
        return _buildHomeDetailScreen();
    }
  }

  Widget _buildHomeDetailScreen() {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(40, 60, 40, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Home & Library',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w400,
                  color: Theme.of(context).textTheme.titleLarge?.color,
                ),
              ),
              const SizedBox(height: 24),

              Text(
                'Learn how to navigate your digital library, upload files, and manage your documents effectively.',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: Theme.of(context).textTheme.bodyMedium?.color,
                  height: 1.21,
                ),
              ),
              const SizedBox(height: 24),

              // Step 1 Card
              _buildStepCard(
                'Step 1: Access Your Library',
                'Navigate to the Home tab from the bottom navigation. Here you\'ll find your document list, search functionality, and voice assist feature.',
              ),
              const SizedBox(height: 24),

              // Step 2 Card
              _buildStepCard(
                'Step 2: Upload Documents',
                'Tap the upload button to add new documents. You can upload from your device or import from cloud services. Organize files in folders for easy access.',
              ),
              const SizedBox(height: 24),

              // Step 3 Card
              _buildStepCard(
                'Step 3: Search & Organize',
                'Use the search bar to quickly find documents. Filter by favorites or categories. Use voice search for hands-free navigation.',
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _selectedDetailScreen = 'upload';
            _currentPage = 1;
          });
        },
        backgroundColor: Theme.of(context).brightness == Brightness.dark
            ? Colors.white
            : Colors.black,
        child: Icon(
          Icons.arrow_forward,
          size: 20,
          color: Theme.of(context).brightness == Brightness.dark ? Colors.black : Colors.white,
        ),
      ),
    );
  }

  Widget _buildStepCard(String title, String description) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? Colors.grey[800]
            : const Color(0xFFF2F2F2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Theme.of(context).textTheme.titleMedium?.color,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            description,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.8),
              height: 1.21,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUploadDetailScreen() {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(40, 60, 40, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'File Upload & Management',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w400,
                  color: Theme.of(context).textTheme.titleLarge?.color,
                ),
              ),
              const SizedBox(height: 24),

              Text(
                'Discover multiple ways to add documents to your library and organize them efficiently.',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: Theme.of(context).textTheme.bodyMedium?.color,
                  height: 1.21,
                ),
              ),
              const SizedBox(height: 24),

              _buildStepCard(
                'Step 1: Choose Upload Method',
                'Select from device files, camera capture, or cloud import. Multiple file formats are supported including PDF, Word, and text documents.',
              ),
              const SizedBox(height: 24),

              _buildStepCard(
                'Step 2: File Processing',
                'Files are automatically processed and converted to accessible formats. Text extraction and OCR ensure maximum compatibility.',
              ),
              const SizedBox(height: 24),

              _buildStepCard(
                'Step 3: Organization',
                'Create folders, add tags, and organize your documents. Use favorites and categories for quick access.',
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _selectedDetailScreen = 'reading';
            _currentPage = 2;
          });
        },
        backgroundColor: Theme.of(context).brightness == Brightness.dark
            ? Colors.white
            : Colors.black,
        child: Icon(
          Icons.arrow_forward,
          size: 20,
          color: Theme.of(context).brightness == Brightness.dark ? Colors.black : Colors.white,
        ),
      ),
    );
  }

  Widget _buildReadingDetailScreen() {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(40, 60, 40, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Reading & Device Control',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w400,
                  color: Theme.of(context).textTheme.titleLarge?.color,
                ),
              ),
              const SizedBox(height: 24),

              Text(
                'Master braille display connection and reading controls for optimal accessibility experience.',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: Theme.of(context).textTheme.bodyMedium?.color,
                  height: 1.21,
                ),
              ),
              const SizedBox(height: 24),

              _buildStepCard(
                'Step 1: Connect Braille Display',
                'Pair your braille display via Bluetooth. Multiple device types supported with automatic configuration.',
              ),
              const SizedBox(height: 24),

              _buildStepCard(
                'Step 2: Reading Controls',
                'Use navigation commands, adjust reading speed, and utilize voice feedback. Customize controls to your preference.',
              ),
              const SizedBox(height: 24),

              _buildStepCard(
                'Step 3: Advanced Features',
                'Access bookmarks, table of contents, and search within documents. Use annotation and note-taking features.',
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _selectedDetailScreen = 'settings';
            _currentPage = 3;
          });
        },
        backgroundColor: Theme.of(context).brightness == Brightness.dark
            ? Colors.white
            : Colors.black,
        child: Icon(
          Icons.arrow_forward,
          size: 20,
          color: Theme.of(context).brightness == Brightness.dark ? Colors.black : Colors.white,
        ),
      ),
    );
  }

  Widget _buildSettingsDetailScreen() {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(40, 60, 40, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Settings',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w400,
                  color: Theme.of(context).textTheme.titleLarge?.color,
                ),
              ),
              const SizedBox(height: 24),

              Text(
                'Customize your accessibility preferences and app behavior for the best personal experience.',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: Theme.of(context).textTheme.bodyMedium?.color,
                  height: 1.21,
                ),
              ),
              const SizedBox(height: 24),

              _buildStepCard(
                'Step 1: Accessibility Options',
                'Configure voice feedback, screen reader compatibility, and gesture controls. Adjust font sizes and contrast settings.',
              ),
              const SizedBox(height: 24),

              _buildStepCard(
                'Step 2: Reading Preferences',
                'Set default reading speed, braille table preferences, and document formatting options.',
              ),
              const SizedBox(height: 24),

              _buildStepCard(
                'Step 3: Device & Sync',
                'Manage connected devices, cloud sync preferences, and backup settings for your documents.',
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _selectedDetailScreen = 'help';
            _currentPage = 4;
          });
        },
        backgroundColor: Theme.of(context).brightness == Brightness.dark
            ? Colors.white
            : Colors.black,
        child: Icon(
          Icons.arrow_forward,
          size: 20,
          color: Theme.of(context).brightness == Brightness.dark ? Colors.black : Colors.white,
        ),
      ),
    );
  }

  Widget _buildHelpDetailScreen() {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(40, 60, 40, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Help & Support',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w400,
                  color: Theme.of(context).textTheme.titleLarge?.color,
                ),
              ),
              const SizedBox(height: 24),

              Text(
                'Access comprehensive help resources, tutorials, and support channels when you need assistance.',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: Theme.of(context).textTheme.bodyMedium?.color,
                  height: 1.21,
                ),
              ),
              const SizedBox(height: 24),

              _buildStepCard(
                'Step 1: Documentation',
                'Browse comprehensive guides, keyboard shortcuts, and troubleshooting resources. Search for specific topics.',
              ),
              const SizedBox(height: 24),

              _buildStepCard(
                'Step 2: Community Support',
                'Connect with other users, share tips, and get answers from the community forum and knowledge base.',
              ),
              const SizedBox(height: 24),

              _buildStepCard(
                'Step 3: Contact Support',
                'Get direct help from our support team via email, chat, or phone. Submit feedback and feature requests.',
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          // 튜토리얼 완료 상태 저장
          await UserSessionService.setTutorialCompleted();

          // /home 으로이동
          Navigator.pushReplacementNamed(context, '/home');

          // 튜토리얼 완료 메시지
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Tutorial completed!'), backgroundColor: Colors.green),
          );
        },
        backgroundColor: Theme.of(context).brightness == Brightness.dark
            ? Colors.white
            : Colors.black,
        label: Text(
          'DONE',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Theme.of(context).brightness == Brightness.dark ? Colors.black : Colors.white,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
