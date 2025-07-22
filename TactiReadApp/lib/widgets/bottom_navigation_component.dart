import 'package:flutter/material.dart';

class BottomNavigationComponent extends StatelessWidget {
  final String? currentRoute;
  
  const BottomNavigationComponent({
    super.key,
    this.currentRoute,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 83,
      padding: const EdgeInsets.only(left: 16, right: 16, top: 12),
      child: Column(
        children: [
          Row(
            children: [
              // Home 버튼
              _buildNavButton(
                context,
                label: 'Home',
                route: '/home',
                width: 65.86,
                isActive: currentRoute == '/home',
              ),
              const Spacer(),
              // Reading 버튼
              _buildNavButton(
                context,
                label: 'Reading',
                route: '/reading',
                width: 84,
                isActive: currentRoute == '/reading',
              ),
              const Spacer(),
              // Settings 버튼
              _buildNavButton(
                context,
                label: 'Settings',
                route: '/settings',
                width: 84,
                isActive: currentRoute == '/settings',
              ),
              const Spacer(),
              // Help 버튼
              _buildNavButton(
                context,
                label: 'Help',
                route: '/help',
                width: 65.86,
                isActive: currentRoute == '/help',
              ),
            ],
          ),
          const SizedBox(height: 15),
          // 하단 바
          Container(
            width: 135,
            height: 5,
            decoration: BoxDecoration(
              color: Theme.of(context).brightness == Brightness.dark 
                  ? Colors.white 
                  : Colors.black,
              borderRadius: BorderRadius.circular(17),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavButton(
    BuildContext context, {
    required String label,
    required String route,
    required double width,
    bool isActive = false,
  }) {
    return GestureDetector(
      onTap: () {
        if (currentRoute != route) {
          Navigator.pushReplacementNamed(context, route);
        }
      },
      child: Container(
        width: width,
        height: 43,
        decoration: BoxDecoration(
          color: isActive 
              ? (Theme.of(context).brightness == Brightness.dark 
                  ? Colors.white 
                  : Colors.black)
              : (Theme.of(context).brightness == Brightness.dark 
                  ? Colors.grey.shade800 
                  : Colors.white),
          border: Border.all(
            color: isActive 
                ? (Theme.of(context).brightness == Brightness.dark 
                    ? Colors.white 
                    : Colors.black)
                : (Theme.of(context).brightness == Brightness.dark 
                    ? Colors.grey.shade600 
                    : const Color(0xFFB0B0B0)),
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: isActive 
                  ? (Theme.of(context).brightness == Brightness.dark 
                      ? Colors.black 
                      : Colors.white)
                  : (Theme.of(context).brightness == Brightness.dark 
                      ? Colors.white 
                      : Colors.black),
              fontFamily: 'Inter',
            ),
          ),
        ),
      ),
    );
  }
}
