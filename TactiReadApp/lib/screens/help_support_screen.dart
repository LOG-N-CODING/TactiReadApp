import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HelpSupportScreen extends StatefulWidget {
  const HelpSupportScreen({super.key});

  @override
  State<HelpSupportScreen> createState() => _HelpSupportScreenState();
}

class _HelpSupportScreenState extends State<HelpSupportScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    // Implement search functionality
    print('Search: $value');
  }

  void _onVoiceSearch() {
    HapticFeedback.lightImpact();
    // Implement voice search functionality
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Voice search functionality would be implemented here'), duration: Duration(seconds: 2)));
  }

  void _expandableFAQ() {
    HapticFeedback.lightImpact();
    // Navigate to FAQ screen or show expanded FAQ
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Frequently Asked Questions'),
          content: const SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Q: How do I use the reading features?', style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: 8),
                Text('A: You can access reading features through the Reading tab.'),
                SizedBox(height: 16),
                Text('Q: How do I adjust accessibility settings?', style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: 8),
                Text('A: Go to Settings > Accessibility to customize your experience.'),
                SizedBox(height: 16),
                Text('Q: How do I pair my device?', style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: 8),
                Text('A: Navigate to Settings > Device Pairing for connection options.'),
              ],
            ),
          ),
          actions: [TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Close'))],
        );
      },
    );
  }

  void _contactSupport() {
    HapticFeedback.lightImpact();
    // Show contact options
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Contact Support', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 24),
              ListTile(
                leading: const Icon(Icons.phone, color: Colors.black),
                title: const Text('Call Support'),
                subtitle: const Text('+1-800-TACTI-READ'),
                onTap: () {
                  Navigator.pop(context);
                  _makePhoneCall();
                },
              ),
              ListTile(
                leading: const Icon(Icons.email, color: Colors.black),
                title: const Text('Email Support'),
                subtitle: const Text('support@tactiread.com'),
                onTap: () {
                  Navigator.pop(context);
                  _sendEmail();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _makePhoneCall() {
    HapticFeedback.lightImpact();
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Phone call functionality would be implemented here'), duration: Duration(seconds: 2)));
  }

  void _sendEmail() {
    HapticFeedback.lightImpact();
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Email functionality would be implemented here'), duration: Duration(seconds: 2)));
  }

  void _communityResources() {
    HapticFeedback.lightImpact();
    // Navigate to community resources
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Community Resources'),
          content: const SingleChildScrollView(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [Text('• User Forums'), SizedBox(height: 8), Text('• Video Tutorials'), SizedBox(height: 8), Text('• User Guides'), SizedBox(height: 8), Text('• Accessibility Tips'), SizedBox(height: 8), Text('• Community Chat')]),
          ),
          actions: [TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Close'))],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 38.0),
                child: Column(
                  children: [
                    const SizedBox(height: 59), // 124 - 65 = 59
                    // Help & Support Title
                    const Text(
                      'Help & Support',
                      style: TextStyle(fontFamily: 'Inter', fontSize: 28, fontWeight: FontWeight.w400, color: Colors.black, height: 1.46),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 101), // 266 - 124 - 41 = 101
                    // Search Bar
                    Container(
                      width: 300,
                      height: 44,
                      decoration: BoxDecoration(color: const Color(0xFFEFEFEF), borderRadius: BorderRadius.circular(10)),
                      child: Row(
                        children: [
                          const SizedBox(width: 8),
                          // Search Icon
                          Container(width: 28, height: 28, child: const Icon(Icons.search, color: Color(0x993C3C43), size: 18)),
                          // Search Field
                          Expanded(
                            child: TextField(
                              controller: _searchController,
                              onChanged: _onSearchChanged,
                              decoration: const InputDecoration(
                                hintText: 'Search',
                                hintStyle: TextStyle(fontFamily: 'SF Pro Text', fontSize: 17, fontWeight: FontWeight.w400, color: Color(0x993C3C43), height: 1.29),
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(horizontal: 8),
                              ),
                              style: const TextStyle(fontFamily: 'SF Pro Text', fontSize: 17, fontWeight: FontWeight.w400, color: Colors.black, height: 1.29),
                            ),
                          ),
                          // Mic Icon
                          IconButton(
                            onPressed: _onVoiceSearch,
                            icon: const Icon(Icons.mic, color: Colors.black, size: 20),
                          ),
                          const SizedBox(width: 4),
                        ],
                      ),
                    ),

                    const SizedBox(height: 100), // 410 - 266 - 44 = 100
                    // Expandable FAQ
                    Semantics(
                      label: 'Expandable FAQ',
                      button: true,
                      onTap: _expandableFAQ,
                      child: GestureDetector(
                        onTap: _expandableFAQ,
                        child: Container(
                          width: 297,
                          height: 44,
                          decoration: BoxDecoration(color: const Color(0xFF4E4E4E), borderRadius: BorderRadius.circular(10)),
                          child: const Padding(
                            padding: EdgeInsets.only(left: 23, top: 13),
                            child: Text(
                              'Expandable FAQ',
                              style: TextStyle(fontFamily: 'Noto Sans', fontSize: 18, fontWeight: FontWeight.w500, color: Colors.white, height: 1.0),
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 22), // 476 - 410 - 44 = 22
                    // Contact Support Section
                    Container(
                      width: 297,
                      child: Column(
                        children: [
                          // Contact Support Header
                          Semantics(
                            label: 'Contact Support',
                            button: true,
                            onTap: _contactSupport,
                            child: GestureDetector(
                              onTap: _contactSupport,
                              child: Container(
                                width: 297,
                                height: 44,
                                decoration: BoxDecoration(color: const Color(0xFF4E4E4E), borderRadius: BorderRadius.circular(10)),
                                child: const Padding(
                                  padding: EdgeInsets.only(left: 23, top: 13),
                                  child: Text(
                                    'Contact Support',
                                    style: TextStyle(fontFamily: 'Noto Sans', fontSize: 18, fontWeight: FontWeight.w500, color: Colors.white, height: 1.0),
                                  ),
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 8),

                          // Contact Options
                          Row(
                            children: [
                              // Call Option
                              Semantics(
                                label: 'Call support',
                                button: true,
                                onTap: _makePhoneCall,
                                child: GestureDetector(
                                  onTap: _makePhoneCall,
                                  child: Row(
                                    children: [
                                      Container(width: 24, height: 24, child: const Icon(Icons.phone, color: Colors.black, size: 16)),
                                      const SizedBox(width: 12),
                                      const Text(
                                        'Call',
                                        style: TextStyle(fontFamily: 'Pretendard Variable', fontSize: 18, fontWeight: FontWeight.w500, color: Colors.black, height: 1.0),
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                              const SizedBox(width: 40),

                              // Email Option
                              Semantics(
                                label: 'Email support',
                                button: true,
                                onTap: _sendEmail,
                                child: GestureDetector(
                                  onTap: _sendEmail,
                                  child: Row(
                                    children: [
                                      Container(width: 24, height: 24, child: const Icon(Icons.email_outlined, color: Colors.black, size: 16)),
                                      const SizedBox(width: 12),
                                      const Text(
                                        'Email',
                                        style: TextStyle(fontFamily: 'Pretendard Variable', fontSize: 18, fontWeight: FontWeight.w500, color: Colors.black, height: 1.0),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 22), // 606 - 476 - 108 = 22
                    // Community Resources
                    Semantics(
                      label: 'Community resources',
                      button: true,
                      onTap: _communityResources,
                      child: GestureDetector(
                        onTap: _communityResources,
                        child: Container(
                          width: 297,
                          height: 44,
                          decoration: BoxDecoration(color: const Color(0xFF4E4E4E), borderRadius: BorderRadius.circular(10)),
                          child: const Padding(
                            padding: EdgeInsets.only(left: 23, top: 13),
                            child: Text(
                              'Community resources',
                              style: TextStyle(fontFamily: 'Noto Sans', fontSize: 18, fontWeight: FontWeight.w500, color: Colors.white, height: 1.0),
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ),

          // Bottom Navigation - Help 탭이 활성화된 상태
          Container(
            height: 83,
            child: Container(
              margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Home Tab
                      _buildNavItem('Home', false, () {
                        Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
                      }),
                      // Reading Tab
                      _buildNavItem('Reading', false, () {
                        Navigator.pushNamed(context, '/reading');
                      }),
                      // Settings Tab
                      _buildNavItem('Settings', false, () {
                        Navigator.pushNamed(context, '/settings');
                      }),
                      // Help Tab (Active)
                      _buildNavItem('Help', true, () {}),
                    ],
                  ),
                  const SizedBox(height: 15),
                  // Bottom Indicator
                  Container(
                    width: 135,
                    height: 5,
                    decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(17)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(String title, bool isActive, VoidCallback onTap) {
    return Semantics(
      label: '$title navigation tab',
      button: true,
      selected: isActive,
      onTap: onTap,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: isActive ? Colors.black : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: isActive ? null : Border.all(color: const Color(0xFFB0B0B0), width: 1),
          ),
          child: Text(
            title,
            style: TextStyle(fontFamily: 'Inter', fontSize: 16, fontWeight: FontWeight.w400, color: isActive ? Colors.white : Colors.black, height: 1.46),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
