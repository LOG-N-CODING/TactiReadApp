import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../database/models/user_model.dart';
import '../services/auth_service.dart';
import '../services/user_session_service.dart';

class UpdateProfileScreen extends StatefulWidget {
  const UpdateProfileScreen({super.key});

  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _passwordController = TextEditingController();
  final AuthService _authService = AuthService();

  bool _isLoading = false;
  bool _obscurePassword = true;

  // User data
  User? _currentUser;
  String _userEmail = '';

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  // 현재 사용자 데이터 로드
  Future<void> _loadUserData() async {
    try {
      User? user = await UserSessionService.getCurrentUser();
      if (user != null && mounted) {
        setState(() {
          _currentUser = user;
          _userEmail = user.email;
          _nameController.text = user.name;
        });
      } else {
        // 사용자 정보가 없으면 로그인 화면으로
        Navigator.pushReplacementNamed(context, '/sign_in');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('사용자 정보를 불러오는 중 오류가 발생했습니다.'), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _updateProfile() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_currentUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('사용자 정보를 찾을 수 없습니다.'), backgroundColor: Colors.red),
      );
      return;
    }

    HapticFeedback.lightImpact();

    setState(() {
      _isLoading = true;
    });

    try {
      // 이름 업데이트
      AuthResult nameResult = await _authService.updateUserName(
        userId: _currentUser!.id!,
        newName: _nameController.text.trim(),
      );

      if (!nameResult.success) {
        throw Exception(nameResult.message);
      }

      // 비밀번호 업데이트 (비어있지 않은 경우만)
      if (_passwordController.text.isNotEmpty) {
        AuthResult passwordResult = await _authService.updateUserPassword(
          userId: _currentUser!.id!,
          newPassword: _passwordController.text,
        );

        if (!passwordResult.success) {
          throw Exception(passwordResult.message);
        }
      }

      // 사용자 정보 다시 로드
      await _loadUserData();

      setState(() {
        _isLoading = false;
      });

      // 성공 메시지 표시
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('프로필이 성공적으로 업데이트되었습니다!'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );

        // 비밀번호 필드 초기화
        _passwordController.clear();

        // 이전 화면으로 돌아가기
        Navigator.pop(context, true);
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('프로필 업데이트 중 오류가 발생했습니다: ${e.toString()}'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  String? _validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Name is required';
    }
    if (value.trim().length < 2) {
      return 'Name must be at least 2 characters';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return null; // Password is optional for profile update
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
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
          padding: const EdgeInsets.symmetric(horizontal: 40.0),
          child: Form(
            key: _formKey,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight:
                    MediaQuery.of(context).size.height -
                    MediaQuery.of(context).padding.top -
                    kToolbarHeight,
              ),
              child: IntrinsicHeight(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 24),
                    // Profile Title
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
                    const SizedBox(height: 56),

                    // Form Fields Container
                    Container(
                      width: 307,
                      padding: const EdgeInsets.fromLTRB(6, 24, 6, 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Email Label and Field (Read Only)
                          const Text(
                            'Email',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                              height: 1.21,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            width: double.infinity,
                            height: 50,
                            decoration: BoxDecoration(
                              color: const Color(0xFFF2F2F2),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: const Color(0xFFCCCCCC), width: 1),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
                              child: Text(
                                _userEmail,
                                style: const TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  color: Color(0xFF999999),
                                  height: 1.21,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 17),

                          // Name Label and Field
                          const Text(
                            'Name',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                              height: 1.21,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Semantics(
                            label: 'Name input field',
                            textField: true,
                            child: TextFormField(
                              controller: _nameController,
                              validator: _validateName,
                              decoration: InputDecoration(
                                hintText: 'Enter your name',
                                hintStyle: const TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  color: Color(0xFFB3B3B3),
                                  height: 1.21,
                                ),
                                filled: true,
                                fillColor: Colors.white,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: const BorderSide(color: Color(0xFFB3B3B3), width: 1),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: const BorderSide(color: Color(0xFFB3B3B3), width: 1),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: const BorderSide(color: Colors.black, width: 2),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: const BorderSide(color: Colors.red, width: 1),
                                ),
                                focusedErrorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: const BorderSide(color: Colors.red, width: 2),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 15,
                                ),
                              ),
                              style: const TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                color: Colors.black,
                                height: 1.21,
                              ),
                            ),
                          ),

                          const SizedBox(height: 17),

                          // Password Label and Field
                          const Text(
                            'Password',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                              height: 1.21,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Semantics(
                            label: 'Password input field, optional',
                            textField: true,
                            obscured: _obscurePassword,
                            child: TextFormField(
                              controller: _passwordController,
                              validator: _validatePassword,
                              obscureText: _obscurePassword,
                              decoration: InputDecoration(
                                hintText: 'Enter new password',
                                hintStyle: const TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  color: Color(0xFFB3B3B3),
                                  height: 1.21,
                                ),
                                filled: true,
                                fillColor: Colors.white,
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscurePassword ? Icons.visibility_off : Icons.visibility,
                                    color: const Color(0xFFB3B3B3),
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _obscurePassword = !_obscurePassword;
                                    });
                                    HapticFeedback.lightImpact();
                                  },
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: const BorderSide(color: Color(0xFFB3B3B3), width: 1),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: const BorderSide(color: Color(0xFFB3B3B3), width: 1),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: const BorderSide(color: Colors.black, width: 2),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: const BorderSide(color: Colors.red, width: 1),
                                ),
                                focusedErrorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: const BorderSide(color: Colors.red, width: 2),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 15,
                                ),
                              ),
                              style: const TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                color: Colors.black,
                                height: 1.21,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const Spacer(),

                    // Update Button
                    Semantics(
                      label: 'Update profile button',
                      button: true,
                      onTap: _isLoading ? null : _updateProfile,
                      child: Container(
                        width: 295,
                        height: 50,
                        child: Material(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(8),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(8),
                            onTap: _isLoading ? null : _updateProfile,
                            child: Center(
                              child: _isLoading
                                  ? const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : const Text(
                                      'Update',
                                      style: TextStyle(
                                        fontFamily: 'Inter',
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                        height: 1.21,
                                      ),
                                    ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 38),
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
