import 'package:flutter/material.dart';

class BottomNavigationComponent extends StatelessWidget {
  final String? currentRoute;

  const BottomNavigationComponent({super.key, this.currentRoute});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        border: Border(
          top: BorderSide(color: Theme.of(context).dividerColor.withOpacity(0.2), width: 1),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Home 버튼
          _buildNavButton(
            context,
            label: 'Home',
            icon: Icons.home_outlined,
            activeIcon: Icons.home,
            route: '/home',
            isActive: currentRoute == '/home',
          ),
          // Reading 버튼
          _buildNavButton(
            context,
            label: 'Reading',
            icon: Icons.menu_book_outlined,
            activeIcon: Icons.menu_book,
            route: '/reading',
            isActive: currentRoute == '/reading',
          ),
          // Library 버튼 (새로 추가)
          _buildNavButton(
            context,
            label: 'Library',
            icon: Icons.library_books_outlined,
            activeIcon: Icons.library_books,
            route: '/library',
            isActive: currentRoute == '/library',
          ),
          // Settings 버튼
          _buildNavButton(
            context,
            label: 'Settings',
            icon: Icons.settings_outlined,
            activeIcon: Icons.settings,
            route: '/settings',
            isActive: currentRoute == '/settings',
          ),
          // Help 버튼
          _buildNavButton(
            context,
            label: 'Help',
            icon: Icons.help_outline,
            activeIcon: Icons.help,
            route: '/help',
            isActive: currentRoute == '/help',
          ),
        ],
      ),
    );
  }

  Widget _buildNavButton(
    BuildContext context, {
    required String label,
    required IconData icon,
    required IconData activeIcon,
    required String route,
    bool isActive = false,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          if (currentRoute != route) {
            Navigator.pushReplacementNamed(context, route);
          }
        },
        child: Container(
          height: 60,
          decoration: BoxDecoration(
            color: isActive
                ? Theme.of(context).colorScheme.primary.withOpacity(0.1)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                isActive ? activeIcon : icon,
                size: 24,
                color: isActive
                    ? Theme.of(context).colorScheme.primary
                    : (Theme.of(context).brightness == Brightness.dark
                          ? Colors.white.withOpacity(0.85)
                          : Colors.grey.shade600),
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                  color: isActive
                      ? Theme.of(context).colorScheme.primary
                      : (Theme.of(context).brightness == Brightness.dark
                            ? Colors.grey.shade400
                            : Colors.grey.shade600),
                  fontFamily: 'Inter',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
