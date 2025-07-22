import 'package:flutter/material.dart';

class DisplaySettingsScreen extends StatefulWidget {
  const DisplaySettingsScreen({super.key});

  @override
  State<DisplaySettingsScreen> createState() => _DisplaySettingsScreenState();
}

class _DisplaySettingsScreenState extends State<DisplaySettingsScreen> {
  bool isDarkMode = false;
  bool isHighContrastMode = false;

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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 36.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 24),
            // Display Title
            const Text(
              'Display',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 28,
                fontWeight: FontWeight.w400,
                color: Colors.black,
                height: 1.21,
              ),
            ),
            const SizedBox(height: 59), // 65 + 34 + 25 = 124 - 65 = 59
            // Dark Mode Setting
            Container(
              width: 306,
              padding: const EdgeInsets.symmetric(vertical: 11, horizontal: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Dark mode',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                      height: 1.21,
                    ),
                  ),
                  Semantics(
                    label: 'Dark mode toggle',
                    value: isDarkMode ? 'On' : 'Off',
                    onTap: () {
                      setState(() {
                        isDarkMode = !isDarkMode;
                      });
                    },
                    child: _buildCustomSwitch(isDarkMode, (value) {
                      setState(() {
                        isDarkMode = value;
                      });
                    }),
                  ),
                ],
              ),
            ),

            const SizedBox(
              height: 50,
            ), // 196 - 124 - 22 = 50 (approximate spacing)
            // High Contrast Mode Setting
            Container(
              width: 306,
              padding: const EdgeInsets.symmetric(vertical: 11, horizontal: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'High contrast mode',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                      height: 1.21,
                    ),
                  ),
                  Semantics(
                    label: 'High contrast mode toggle',
                    value: isHighContrastMode ? 'On' : 'Off',
                    onTap: () {
                      setState(() {
                        isHighContrastMode = !isHighContrastMode;
                      });
                    },
                    child: _buildCustomSwitch(isHighContrastMode, (value) {
                      setState(() {
                        isHighContrastMode = value;
                      });
                    }),
                  ),
                ],
              ),
            ),
          ],
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
}
