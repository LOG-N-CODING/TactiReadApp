import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ProfileSettingsScreen extends StatefulWidget {
  const ProfileSettingsScreen({super.key});

  @override
  State<ProfileSettingsScreen> createState() => _ProfileSettingsScreenState();
}

class _ProfileSettingsScreenState extends State<ProfileSettingsScreen> {
  void _updateProfile() {
    HapticFeedback.lightImpact();
    Navigator.pushNamed(context, '/update-profile');
  }

  void _deleteAccount() {
    HapticFeedback.mediumImpact();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Delete Account',
            style: TextStyle(color: Colors.red),
          ),
          content: const Text(
            'Are you sure you want to delete your account? This action cannot be undone.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Account deletion would be processed here.'),
                    backgroundColor: Colors.red,
                    duration: Duration(seconds: 2),
                  ),
                );
              },
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  void _logout() {
    HapticFeedback.lightImpact();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Logout'),
          content: const Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushNamedAndRemoveUntil(
                  '/sign_in',
                  (Route<dynamic> route) => false,
                );
              },
              child: const Text('Logout'),
            ),
          ],
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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 24),
            // Profile Title - 피그마 디자인대로 위치 조정
            const Text(
              'Profile',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 28,
                fontWeight: FontWeight.w400,
                color: Colors.black,
                height: 1.21,
              ),
            ),
            const SizedBox(height: 51), // 150 - 65 - 34 = 51
            // Update Profile Button - 피그마 색상 #F2F2F2
            Semantics(
              label: 'Update Profile',
              button: true,
              onTap: _updateProfile,
              child: Container(
                width: 295,
                height: 50,
                child: Material(
                  color: const Color(0xFFF2F2F2),
                  borderRadius: BorderRadius.circular(8),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(8),
                    onTap: _updateProfile,
                    child: const Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 20,
                      ), // 60 - 40 = 20
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Update Profile',
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
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20), // 220 - 150 - 50 = 20
            // Delete Account Button - 피그마 색상 #FFE5E5
            Semantics(
              label: 'Delete Account',
              button: true,
              onTap: _deleteAccount,
              child: Container(
                width: 295,
                height: 50,
                child: Material(
                  color: const Color(0xFFFFE5E5),
                  borderRadius: BorderRadius.circular(8),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(8),
                    onTap: _deleteAccount,
                    child: const Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 20,
                      ), // 60 - 40 = 20
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Delete Account',
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
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20), // 290 - 220 - 50 = 20
            // Logout Button - 피그마 색상 #4D4D4D, 흰색 텍스트
            Semantics(
              label: 'Logout',
              button: true,
              onTap: _logout,
              child: Container(
                width: 295,
                height: 50,
                child: Material(
                  color: const Color(0xFF4D4D4D),
                  borderRadius: BorderRadius.circular(8),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(8),
                    onTap: _logout,
                    child: const Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 20,
                      ), // 60 - 40 = 20
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Logout',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                            color: Colors.white,
                            height: 1.21,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
