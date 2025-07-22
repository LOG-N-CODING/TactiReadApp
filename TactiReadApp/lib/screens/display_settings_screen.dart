import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../services/theme_service.dart';

class DisplaySettingsScreen extends StatefulWidget {
  const DisplaySettingsScreen({super.key});

  @override
  State<DisplaySettingsScreen> createState() => _DisplaySettingsScreenState();
}

class _DisplaySettingsScreenState extends State<DisplaySettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeService>(
      builder: (context, themeService, child) {
        return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          appBar: AppBar(
            backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
            elevation: 0,
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Theme.of(context).appBarTheme.foregroundColor),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 36.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 24),
                  Text(
                    'Display Settings',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 28,
                      fontWeight: FontWeight.w400,
                      color: Theme.of(context).textTheme.titleLarge?.color,
                      height: 1.21,
                    ),
                  ),
                  const SizedBox(height: 39),

                  Container(
                    width: 306,
                    padding: const EdgeInsets.symmetric(vertical: 11, horizontal: 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Expanded(
                          child: Text(
                            'Dark mode',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 18,
                              fontWeight: FontWeight.w400,
                              height: 1.21,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Semantics(
                          label: 'Dark mode toggle',
                          value: themeService.isDarkMode ? 'On' : 'Off',
                          onTap: () => _toggleDarkMode(themeService),
                          child: _buildCustomSwitch(
                            themeService.isDarkMode,
                            () => _toggleDarkMode(themeService),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  Container(
                    width: 306,
                    padding: const EdgeInsets.symmetric(vertical: 11, horizontal: 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Expanded(
                          child: Text(
                            'High contrast mode',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 18,
                              fontWeight: FontWeight.w400,
                              height: 1.21,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Semantics(
                          label: 'High contrast mode toggle',
                          value: themeService.isHighContrast ? 'On' : 'Off',
                          onTap: () => _toggleHighContrast(themeService),
                          child: _buildCustomSwitch(
                            themeService.isHighContrast,
                            () => _toggleHighContrast(themeService),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.grey[800]
                          : Colors.grey[50],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.grey[600]!
                            : Colors.grey[200]!,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.info_outline,
                              size: 20,
                              color: Theme.of(context).brightness == Brightness.dark
                                  ? Colors.grey[400]
                                  : Colors.grey[600],
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Display Options',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                height: 1.21,
                                color: Theme.of(context).textTheme.bodyLarge?.color,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Dark mode provides a darker color scheme. High contrast mode increases contrast for better readability.',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Theme.of(context).brightness == Brightness.dark
                                ? Colors.grey[400]
                                : Colors.grey[600],
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
      },
    );
  }

  void _toggleDarkMode(ThemeService themeService) async {
    await themeService.toggleDarkMode();

    HapticFeedback.selectionClick();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(themeService.isDarkMode ? 'Dark mode enabled' : 'Dark mode disabled'),
        duration: const Duration(milliseconds: 800),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  void _toggleHighContrast(ThemeService themeService) async {
    await themeService.toggleHighContrast();

    HapticFeedback.selectionClick();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          themeService.isHighContrast ? 'High contrast enabled' : 'High contrast disabled',
        ),
        duration: const Duration(milliseconds: 800),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  Widget _buildCustomSwitch(bool value, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
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
