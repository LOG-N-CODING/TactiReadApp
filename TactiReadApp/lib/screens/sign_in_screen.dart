import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../services/user_session_service.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthService _authService = AuthService();
  bool _isPasswordVisible = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _signIn() async {
    if (_emailController.text.trim().isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter your email and password.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      AuthResult result = await _authService.signIn(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      if (mounted) {
        setState(() {
          _isLoading = false;
        });

        if (result.success) {
          // 로그인 성공
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(result.message), backgroundColor: Colors.green));

          // 튜토리얼 완료 여부 확인
          bool tutorialCompleted = await UserSessionService.isTutorialCompleted();

          if (tutorialCompleted) {
            // 튜토리얼 완료 - 홈 화면으로
            Navigator.pushReplacementNamed(context, '/home');
          } else {
            // 튜토리얼 미완료 - 튜토리얼 화면으로
            Navigator.pushReplacementNamed(context, '/tutorial');
          }
        } else {
          // 로그인 실패
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
          const SnackBar(
            content: Text('An error occurred during login.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Theme.of(context).appBarTheme.foregroundColor),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 41.0),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight:
                    MediaQuery.of(context).size.height -
                    MediaQuery.of(context).padding.top -
                    MediaQuery.of(context).padding.bottom -
                    kToolbarHeight -
                    MediaQuery.of(context).viewInsets.bottom -
                    40,
              ),
              child: IntrinsicHeight(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    // Title
                    Text(
                      'Sign In',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).textTheme.titleLarge?.color,
                        fontFamily: 'Inter',
                      ),
                    ),
                    const SizedBox(height: 60),

                    // Email Input
                    Container(
                      height: 56,
                      decoration: BoxDecoration(
                        color: Theme.of(context).scaffoldBackgroundColor,
                        border: Border.all(color: Theme.of(context).dividerColor),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: TextField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        style: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color),
                        decoration: InputDecoration(
                          hintText: 'Enter your email',
                          hintStyle: TextStyle(
                            color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.6),
                            fontSize: 16,
                          ),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Password Input
                    Container(
                      height: 56,
                      decoration: BoxDecoration(
                        color: Theme.of(context).scaffoldBackgroundColor,
                        border: Border.all(color: Theme.of(context).dividerColor),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: TextField(
                        controller: _passwordController,
                        obscureText: !_isPasswordVisible,
                        style: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color),
                        decoration: InputDecoration(
                          hintText: 'Enter your password',
                          hintStyle: TextStyle(
                            color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.6),
                            fontSize: 16,
                          ),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                              color: Theme.of(context).iconTheme.color?.withOpacity(0.6),
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
                    const SizedBox(height: 18),

                    // Forgot Password Link
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/forgot_password');
                        },
                        child: Text(
                          'Forgot Password?',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Inter',
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),

                    // Sign In Button
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _signIn,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).brightness == Brightness.dark
                              ? Colors.white
                              : Colors.black,
                          foregroundColor: Theme.of(context).brightness == Brightness.dark
                              ? Colors.black
                              : Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: _isLoading
                            ? SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Theme.of(context).brightness == Brightness.dark
                                        ? Colors.black
                                        : Colors.white,
                                  ),
                                ),
                              )
                            : const Text(
                                'Sign In',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'Inter',
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Create Account Link
                    Center(
                      child: GestureDetector(
                        onTap: () => Navigator.pushReplacementNamed(context, '/create_account'),
                        child: RichText(
                          text: TextSpan(
                            text: "Don't have an account? ",
                            style: TextStyle(
                              fontSize: 14,
                              color: Theme.of(
                                context,
                              ).textTheme.bodyMedium?.color?.withOpacity(0.7),
                              fontFamily: 'Inter',
                            ),
                            children: [
                              TextSpan(
                                text: 'Create Account',
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    const Spacer(),

                    // TactiRead Branding
                    Center(
                      child: Column(
                        children: [
                          Text(
                            'TactiRead',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: Theme.of(context).textTheme.titleMedium?.color,
                              fontFamily: 'Inter',
                            ),
                          ),
                          Text(
                            'Read Beyond Limits',
                            style: TextStyle(
                              fontSize: 12,
                              color: Theme.of(
                                context,
                              ).textTheme.bodyMedium?.color?.withOpacity(0.7),
                              fontFamily: 'Inter',
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
