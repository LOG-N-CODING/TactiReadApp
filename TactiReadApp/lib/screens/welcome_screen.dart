import 'package:flutter/material.dart';
import '../widgets/bottom_navigation_component.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 41),
            child: Column(
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * 0.1),
                // TactiRead 제목
                Text(
                  'TactiRead',
                  style: TextStyle(
                    fontSize: 44,
                    fontWeight: FontWeight.w400,
                    color: Theme.of(context).textTheme.titleLarge?.color,
                    height: 1.46,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 8),
                // Read Beyond Limits 부제목
                Text(
                  'Read Beyond Limits',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w400,
                    color: Theme.of(context).textTheme.titleMedium?.color,
                    height: 1.46,
                  ),
                  textAlign: TextAlign.center,
                ),

                SizedBox(height: MediaQuery.of(context).size.height * 0.08),
                // Sign In 버튼
                GestureDetector(
                  onTap: () => Navigator.pushNamed(context, '/sign_in'),
                  child: Container(
                    width: 286,
                    height: 51,
                    decoration: BoxDecoration(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      border: Border.all(color: Theme.of(context).dividerColor),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Center(
                      child: Text(
                        'Sign In',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: Theme.of(context).textTheme.bodyLarge?.color,
                          height: 1.46,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 16),
                // Create Account 버튼
                GestureDetector(
                  onTap: () => Navigator.pushNamed(context, '/create_account'),
                  child: Container(
                    width: 286,
                    height: 51,
                    decoration: BoxDecoration(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      border: Border.all(color: Theme.of(context).dividerColor),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Center(
                      child: Text(
                        'Create Account',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: Theme.of(context).textTheme.bodyLarge?.color,
                          height: 1.46,
                        ),
                      ),
                    ),
                  ),
                ),

                SizedBox(height: MediaQuery.of(context).size.height * 0.06),
              ],
            ),
          ),
        ),
        bottomNavigationBar: BottomNavigationComponent(currentRoute: '/welcome'),
      ),
    );
  }
}
