import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final AuthService _authService = AuthService();
  final TextEditingController _emailController = TextEditingController();
  bool _isEmailSent = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _sendResetLink() async {
    if (_emailController.text.trim().isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please enter your email address.'), backgroundColor: Colors.red));
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // 실제 구현에서는 새로운 임시 비밀번호를 생성하거나
      // 비밀번호 재설정 토큰을 이메일로 보내야 합니다.
      // 여기서는 임시로 고정된 비밀번호를 사용합니다.
      AuthResult result = await _authService.resetPassword(
        email: _emailController.text.trim(),
        newPassword: 'TempPassword123!', // 실제로는 랜덤 비밀번호 생성
      );

      if (mounted) {
        setState(() {
          _isLoading = false;
        });

        if (result.success) {
          setState(() {
            _isEmailSent = true;
          });

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('A temporary password has been sent to your email. Please log in and change your password.'),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 5),
            ),
          );
        } else {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(result.message), backgroundColor: Colors.red));
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('An error occurred during password reset.'), backgroundColor: Colors.red),
        );
      }
    }
  }

  void _contactSupport() {
    // TODO: Implement contact support functionality
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Redirecting to support...')));
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
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 41.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              // Title
              const Text(
                'Forgot Password',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                  fontFamily: 'Inter',
                ),
              ),
              const SizedBox(height: 20),

              // Description
              const Text(
                "Enter your email address and we'll send you a link to reset your password.",
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFF666666),
                  height: 1.5,
                  fontFamily: 'Inter',
                ),
              ),
              const SizedBox(height: 60),

              // Email Input
              Container(
                height: 56,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: const Color(0xFFB0B0B0)),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TextField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    hintText: 'Enter your email address',
                    hintStyle: TextStyle(color: Color(0xFF999999), fontSize: 16),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Send Reset Link Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: (_isEmailSent || _isLoading) ? null : _sendResetLink,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: (_isEmailSent || _isLoading)
                        ? const Color(0xFFCCCCCC)
                        : Colors.black,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : Text(
                          _isEmailSent ? 'Email Sent' : 'Send Reset Link',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Inter',
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 40),

              // Divider
              Container(height: 1, width: double.infinity, color: const Color(0xFFE5E5E5)),
              const SizedBox(height: 40),

              // Back to Sign In Link
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const Row(
                  children: [
                    Icon(Icons.arrow_back, size: 16, color: Color(0xFF3366CC)),
                    SizedBox(width: 8),
                    Text(
                      'Back to Sign In',
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xFF3366CC),
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Inter',
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),

              // Help Text
              const Text(
                "Didn't receive the email? Check your spam folder or contact support.",
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF808080),
                  height: 1.4,
                  fontFamily: 'Inter',
                ),
              ),
              const SizedBox(height: 24),

              // Contact Support Button
              SizedBox(
                width: double.infinity,
                height: 48,
                child: OutlinedButton(
                  onPressed: _contactSupport,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF666666),
                    side: const BorderSide(color: Color(0xFFB0B0B0)),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text(
                    'Contact Support',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Inter',
                    ),
                  ),
                ),
              ),

              // Success Message (if email sent) - 더 적은 여백으로 조정
              if (_isEmailSent)
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(top: 20),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8F5E8),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFF4CAF50)),
                  ),
                  child: const Column(
                    children: [
                      Icon(Icons.check_circle, color: Color(0xFF4CAF50), size: 32),
                      SizedBox(height: 8),
                      Text(
                        'Reset link sent!',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF2E7D32),
                          fontFamily: 'Inter',
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Please check your email for further instructions.',
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF2E7D32),
                          fontFamily: 'Inter',
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
