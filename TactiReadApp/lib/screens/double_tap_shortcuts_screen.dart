import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DoubleTapShortcutsScreen extends StatefulWidget {
  const DoubleTapShortcutsScreen({super.key});

  @override
  State<DoubleTapShortcutsScreen> createState() => _DoubleTapShortcutsScreenState();
}

class _DoubleTapShortcutsScreenState extends State<DoubleTapShortcutsScreen> {
  bool isDoubleTapEnabled = true; // Default to enabled

  @override
  void initState() {
    super.initState();
    _loadDoubleTapSetting();
  }

  void _loadDoubleTapSetting() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      isDoubleTapEnabled = prefs.getBool('isDoubleTapEnabled') ?? true;
    });
  }

  void _onDoubleTapToggled(bool value) async {
    setState(() {
      isDoubleTapEnabled = value;
    });

    // Save setting
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDoubleTapEnabled', value);

    // 햅틱 피드백
    HapticFeedback.selectionClick();

    // 토글 상태 변경에 대한 확인 메시지
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(value ? 'Double-tap shortcuts enabled' : 'Double-tap shortcuts disabled'),
        duration: const Duration(milliseconds: 800),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
      ),
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 35.0), // 35px based on Figma
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
              // Double-tap Shortcuts Title
              const Text(
                'Double-tap Shortcuts',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 28,
                  fontWeight: FontWeight.w400,
                  color: Colors.black,
                  height: 1.21,
                ),
              ),
              const SizedBox(height: 32), // 131 - 65 - 34 = 32
              // Main Double-tap Toggle Setting
              Container(
                width: 306,
                padding: const EdgeInsets.symmetric(vertical: 11, horizontal: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Container(
                        width: 213,
                        height: 52,
                        child: const Text(
                          'Double-tap to start/pause reading',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                            color: Colors.black,
                            height: 1.21,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Semantics(
                      label: 'Double-tap shortcuts toggle',
                      value: isDoubleTapEnabled ? 'On' : 'Off',
                      onTap: () => _onDoubleTapToggled(!isDoubleTapEnabled),
                      child: _buildCustomSwitch(isDoubleTapEnabled, _onDoubleTapToggled),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // Information Section
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey[200]!),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.info_outline, size: 20, color: Colors.grey[600]),
                        const SizedBox(width: 8),
                        Text(
                          'About Double-tap Shortcuts',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey[800],
                            height: 1.21,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Double-tap shortcuts allow you to quickly control reading functions with simple gestures. These work anywhere on the reading screen.',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey[600],
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCustomSwitch(bool value, ValueChanged<bool> onChanged) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: Container(
        width: 60,
        height: 30,
        padding: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(32),

          color: value ? Colors.black : Colors.grey,
        ),
        child: AnimatedAlign(
          duration: const Duration(milliseconds: 200),
          alignment: value ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 2,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
