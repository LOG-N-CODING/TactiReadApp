import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class CreateAccountScreen extends StatefulWidget {
  const CreateAccountScreen({super.key});

  @override
  State<CreateAccountScreen> createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  final AuthService _authService = AuthService();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _agreeToTerms = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _createAccount() async {
    if (_nameController.text.trim().isEmpty ||
        _emailController.text.trim().isEmpty ||
        _passwordController.text.isEmpty ||
        _confirmPasswordController.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('모든 필드를 입력해주세요.'), backgroundColor: Colors.red));
      return;
    }

    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('비밀번호가 일치하지 않습니다.'), backgroundColor: Colors.red),
      );
      return;
    }

    if (!_agreeToTerms) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('이용약관에 동의해주세요.'), backgroundColor: Colors.red));
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      AuthResult result = await _authService.signUp(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      if (mounted) {
        setState(() {
          _isLoading = false;
        });

        if (result.success) {
          // 회원가입 성공
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(result.message), backgroundColor: Colors.green));

          // 로그인 화면으로 이동
          Navigator.pushReplacementNamed(context, '/signin');
        } else {
          // 회원가입 실패
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
          const SnackBar(content: Text('회원가입 중 오류가 발생했습니다.'), backgroundColor: Colors.red),
        );
      }
    }
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
                'Create Account',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                  fontFamily: 'Inter',
                ),
              ),
              const SizedBox(height: 60),

              // Name Input
              Container(
                height: 56,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: const Color(0xFFB0B0B0)),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    hintText: 'Enter your full name',
                    hintStyle: TextStyle(color: Color(0xFF999999), fontSize: 16),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  ),
                ),
              ),
              const SizedBox(height: 20),

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
                    hintText: 'Enter your email',
                    hintStyle: TextStyle(color: Color(0xFF999999), fontSize: 16),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Password Input
              Container(
                height: 56,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: const Color(0xFFB0B0B0)),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TextField(
                  controller: _passwordController,
                  obscureText: !_isPasswordVisible,
                  decoration: InputDecoration(
                    hintText: 'Create a password',
                    hintStyle: const TextStyle(color: Color(0xFF999999), fontSize: 16),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                        color: const Color(0xFF999999),
                      ),
                      onPressed: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Confirm Password Input
              Container(
                height: 56,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: const Color(0xFFB0B0B0)),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TextField(
                  controller: _confirmPasswordController,
                  obscureText: !_isConfirmPasswordVisible,
                  decoration: InputDecoration(
                    hintText: 'Confirm your password',
                    hintStyle: const TextStyle(color: Color(0xFF999999), fontSize: 16),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isConfirmPasswordVisible ? Icons.visibility : Icons.visibility_off,
                        color: const Color(0xFF999999),
                      ),
                      onPressed: () {
                        setState(() {
                          _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                        });
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Terms Agreement
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: Checkbox(
                      value: _agreeToTerms,
                      onChanged: (value) {
                        setState(() {
                          _agreeToTerms = value ?? false;
                        });
                      },
                      activeColor: const Color(0xFF3366CC),
                      side: const BorderSide(color: Color(0xFFB0B0B0)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _agreeToTerms = !_agreeToTerms;
                        });
                      },
                      child: RichText(
                        text: const TextSpan(
                          text: 'I agree to the ',
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF666666),
                            fontFamily: 'Inter',
                          ),
                          children: [
                            TextSpan(
                              text: 'Terms and Conditions',
                              style: TextStyle(
                                color: Color(0xFF3366CC),
                                decoration: TextDecoration.underline,
                              ),
                            ),
                            TextSpan(text: ' and '),
                            TextSpan(
                              text: 'Privacy Policy',
                              style: TextStyle(
                                color: Color(0xFF3366CC),
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // Create Account Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _createAccount,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
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
                      : const Text(
                          'Create Account',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Inter',
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 24),

              // Sign In Link
              Center(
                child: GestureDetector(
                  onTap: () => Navigator.pushReplacementNamed(context, '/sign_in'),
                  child: RichText(
                    text: const TextSpan(
                      text: 'Already have an account? ',
                      style: TextStyle(fontSize: 14, color: Color(0xFF666666), fontFamily: 'Inter'),
                      children: [
                        TextSpan(
                          text: 'Sign In',
                          style: TextStyle(color: Color(0xFF3366CC), fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
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
