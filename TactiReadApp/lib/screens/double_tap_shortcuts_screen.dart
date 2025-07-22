import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DoubleTapShortcutsScreen extends StatefulWidget {
  const DoubleTapShortcutsScreen({super.key});

  @override
  State<DoubleTapShortcutsScreen> createState() =>
      _DoubleTapShortcutsScreenState();
}

class _DoubleTapShortcutsScreenState extends State<DoubleTapShortcutsScreen> {
  bool isDoubleTapEnabled = true; // Default to enabled
  bool _testAreaPressed = false; // For visual feedback

  // Double-tap shortcut options
  Map<String, bool> doubleTapShortcuts = {
    'Start/Pause Reading': true,
    'Skip to Next Section': false,
    'Go Back Section': false,
    'Increase Reading Speed': false,
    'Decrease Reading Speed': false,
  };

  void _onDoubleTapToggled(bool value) {
    setState(() {
      isDoubleTapEnabled = value;
      // If disabling double-tap, turn off all shortcuts
      if (!value) {
        doubleTapShortcuts.updateAll((key, value) => false);
      } else {
        // If enabling, restore default settings
        doubleTapShortcuts = {
          'Start/Pause Reading': true,
          'Skip to Next Section': false,
          'Go Back Section': false,
          'Increase Reading Speed': false,
          'Decrease Reading Speed': false,
        };
      }
    });

    // 햅틱 피드백
    HapticFeedback.selectionClick();

    // 토글 상태 변경에 대한 확인 메시지
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          value
              ? 'Double-tap shortcuts enabled'
              : 'Double-tap shortcuts disabled',
        ),
        duration: const Duration(milliseconds: 800),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  void _onShortcutToggled(String shortcut, bool value) {
    setState(() {
      doubleTapShortcuts[shortcut] = value;
    });

    HapticFeedback.lightImpact();

    // Show feedback for shortcut changes
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$shortcut ${value ? 'enabled' : 'disabled'}'),
        duration: const Duration(milliseconds: 600),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  void _handleTestDoubleTap() {
    HapticFeedback.mediumImpact();

    // Visual feedback
    setState(() {
      _testAreaPressed = true;
    });

    // Reset visual feedback after animation
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        setState(() {
          _testAreaPressed = false;
        });
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Row(
          children: [
            Icon(Icons.touch_app, color: Colors.white),
            SizedBox(width: 8),
            Text('Double-tap detected! 👆👆'),
          ],
        ),
        duration: Duration(milliseconds: 1200),
        behavior: SnackBarBehavior.floating,
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
          padding: const EdgeInsets.symmetric(
            horizontal: 35.0,
          ), // 35px based on Figma
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
                padding: const EdgeInsets.symmetric(
                  vertical: 11,
                  horizontal: 4,
                ),
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
                      child: _buildCustomSwitch(
                        isDoubleTapEnabled,
                        _onDoubleTapToggled,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // Additional Shortcut Options (only shown when double-tap is enabled)
              if (isDoubleTapEnabled) ...[
                Text(
                  'Additional Shortcuts',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                    height: 1.21,
                  ),
                ),
                const SizedBox(height: 16),

                ...doubleTapShortcuts.entries.map((entry) {
                  // Skip the main shortcut as it's already displayed above
                  if (entry.key == 'Start/Pause Reading')
                    return const SizedBox.shrink();

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            entry.key,
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: Colors.black,
                              height: 1.21,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Semantics(
                          label: '${entry.key} shortcut toggle',
                          value: entry.value ? 'On' : 'Off',
                          onTap: () =>
                              _onShortcutToggled(entry.key, !entry.value),
                          child: _buildSmallSwitch(
                            entry.value,
                            (value) => _onShortcutToggled(entry.key, value),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),

                const SizedBox(height: 24),

                // Test Double-tap Area
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: double.infinity,
                  height: 120,
                  decoration: BoxDecoration(
                    color: _testAreaPressed
                        ? Colors.grey[200]
                        : Colors.grey[100],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: _testAreaPressed
                          ? Colors.grey[400]!
                          : Colors.grey[300]!,
                      width: 2,
                      style: BorderStyle.solid,
                    ),
                    boxShadow: _testAreaPressed
                        ? [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ]
                        : null,
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onDoubleTap: _handleTestDoubleTap,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            AnimatedScale(
                              scale: _testAreaPressed ? 1.2 : 1.0,
                              duration: const Duration(milliseconds: 300),
                              child: Icon(
                                Icons.touch_app,
                                size: 32,
                                color: _testAreaPressed
                                    ? Colors.grey[800]
                                    : Colors.grey[600],
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Test Double-tap',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: _testAreaPressed
                                    ? Colors.grey[800]
                                    : Colors.grey[700],
                                height: 1.21,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Double-tap this area to test',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: Colors.grey[500],
                                height: 1.21,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 32),
              ],

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
                        Icon(
                          Icons.info_outline,
                          size: 20,
                          color: Colors.grey[600],
                        ),
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
          border: Border.all(color: Colors.black, width: 1),
          color: value ? Colors.black : Colors.white,
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

  Widget _buildSmallSwitch(bool value, ValueChanged<bool> onChanged) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: Container(
        width: 50,
        height: 24,
        padding: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.grey[400]!, width: 1),
          color: value ? Colors.black : Colors.white,
        ),
        child: AnimatedAlign(
          duration: const Duration(milliseconds: 200),
          alignment: value ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            width: 16,
            height: 16,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 1,
                  offset: const Offset(0, 0.5),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
