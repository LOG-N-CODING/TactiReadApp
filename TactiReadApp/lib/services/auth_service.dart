import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';
import '../database/database_helper.dart';
import '../database/models/user_model.dart';
import 'user_session_service.dart';

class AuthService {
  static final AuthService _instance = AuthService._internal();
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  User? _currentUser;

  AuthService._internal();

  factory AuthService() => _instance;

  User? get currentUser => _currentUser;
  bool get isLoggedIn => _currentUser != null;

  // 비밀번호 해시 생성
  String _hashPassword(String password, String salt) {
    var bytes = utf8.encode(password + salt);
    var digest = sha256.convert(bytes);
    return digest.toString();
  }

  // 랜덤 솔트 생성
  String _generateSalt() {
    var random = Random.secure();
    var saltBytes = List<int>.generate(32, (i) => random.nextInt(256));
    return base64.encode(saltBytes);
  }

  // 회원가입
  Future<AuthResult> signUp({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      // 이메일 형식 검증
      if (!_isValidEmail(email)) {
        return AuthResult(success: false, message: 'Please enter a valid email address.');
      }

      // 비밀번호 강도 검증
      String? passwordError = _validatePassword(password);
      if (passwordError != null) {
        return AuthResult(success: false, message: passwordError);
      }

      // 이름 검증
      if (name.trim().length < 2) {
        return AuthResult(success: false, message: 'Name must be at least 2 characters long.');
      }

      // 이메일 중복 체크
      bool emailExistsResult = await _databaseHelper.emailExists(email.toLowerCase());
      if (emailExistsResult) {
        return AuthResult(success: false, message: 'Email is already in use.');
      }

      // 비밀번호 해시화
      String salt = _generateSalt();
      String hashedPassword = _hashPassword(password, salt);
      String storedPassword = '$salt:$hashedPassword';

      // 사용자 생성
      User newUser = User(
        email: email.toLowerCase(),
        password: storedPassword,
        name: name.trim(),
        createdAt: DateTime.now(),
      );

      // 데이터베이스에 저장
      int userId = await _databaseHelper.insertUser(newUser);

      if (userId > 0) {
        // 기본 설정 생성
        await _databaseHelper.createDefaultUserSettings(userId);

        // 생성된 사용자 정보 가져오기
        _currentUser = await _databaseHelper.getUserById(userId);

        return AuthResult(success: true, message: 'Registration completed successfully.', user: _currentUser);
      } else {
        return AuthResult(success: false, message: 'An error occurred during registration.');
      }
    } catch (e) {
      print('SignUp Error: $e');
      return AuthResult(success: false, message: 'An error occurred during registration.');
    }
  }

  // 로그인
  Future<AuthResult> signIn({required String email, required String password}) async {
    try {
      // 이메일로 사용자 찾기
      User? user = await _databaseHelper.getUserByEmail(email.toLowerCase());

      if (user == null) {
        return AuthResult(success: false, message: 'Invalid email or password.');
      }

      // 비밀번호 검증
      List<String> passwordParts = user.password.split(':');
      if (passwordParts.length != 2) {
        return AuthResult(success: false, message: 'Account information is invalid.');
      }

      String salt = passwordParts[0];
      String storedHash = passwordParts[1];
      String inputHash = _hashPassword(password, salt);

      if (inputHash != storedHash) {
        return AuthResult(success: false, message: 'Invalid email or password.');
      }

      // 로그인 성공
      _currentUser = user;

      // 세션 저장
      await UserSessionService.saveLoginSession(user);

      // 마지막 로그인 시간 업데이트
      await _databaseHelper.updateLastLogin(user.id!);

      return AuthResult(success: true, message: 'Logged in successfully.', user: _currentUser);
    } catch (e) {
      print('SignIn Error: $e');
      return AuthResult(success: false, message: 'An error occurred during login.');
    }
  }

  // 로그아웃
  Future<void> logout() async {
    _currentUser = null;
    await UserSessionService.logout();
  }

  // 현재 사용자 가져오기
  User? getCurrentUser() {
    return _currentUser;
  }

  // 비밀번호 재설정
  Future<AuthResult> resetPassword({required String email, required String newPassword}) async {
    try {
      // 사용자 찾기
      User? user = await _databaseHelper.getUserByEmail(email.toLowerCase());

      if (user == null) {
        return AuthResult(success: false, message: 'No account found with that email address.');
      }

      // 새 비밀번호 검증
      String? passwordError = _validatePassword(newPassword);
      if (passwordError != null) {
        return AuthResult(success: false, message: passwordError);
      }

      // 새 비밀번호 해시화
      String salt = _generateSalt();
      String hashedPassword = _hashPassword(newPassword, salt);
      String storedPassword = '$salt:$hashedPassword';

      // 비밀번호 업데이트
      User updatedUser = user.copyWith(password: storedPassword);
      int result = await _databaseHelper.updateUser(updatedUser);

      if (result > 0) {
        return AuthResult(success: true, message: 'Password has been reset successfully.');
      } else {
        return AuthResult(success: false, message: 'An error occurred during password reset.');
      }
    } catch (e) {
      print('Reset Password Error: $e');
      return AuthResult(success: false, message: 'An error occurred during password reset.');
    }
  }

  // 로그아웃
  void signOut() {
    _currentUser = null;
  }

  // 이메일 형식 검증
  bool _isValidEmail(String email) {
    return RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$').hasMatch(email);
  }

  // 비밀번호 강도 검증
  String? _validatePassword(String password) {
    if (password.length < 6) {
      return 'Password must be at least 6 characters long.';
    }

    if (password.length > 50) {
      return 'Password must be 50 characters or less.';
    }

    // 기본적인 보안 요구사항
    bool hasLetter = password.contains(RegExp(r'[a-zA-Z]'));
    bool hasDigit = password.contains(RegExp(r'[0-9]'));

    if (!hasLetter || !hasDigit) {
      return 'Password must contain both letters and numbers.';
    }

    return null;
  }

  // 계정 삭제
  Future<AuthResult> deleteAccount() async {
    try {
      if (_currentUser == null) {
        return AuthResult(success: false, message: 'Login is required.');
      }

      int result = await _databaseHelper.deleteUser(_currentUser!.id!);

      if (result > 0) {
        _currentUser = null;
        return AuthResult(success: true, message: 'Account has been deleted successfully.');
      } else {
        return AuthResult(success: false, message: 'An error occurred during account deletion.');
      }
    } catch (e) {
      print('Delete Account Error: $e');
      return AuthResult(success: false, message: 'An error occurred during account deletion.');
    }
  }

  // 이름 검증
  String? _validateName(String name) {
    if (name.trim().isEmpty) {
      return 'Please enter your name.';
    }
    if (name.trim().length < 2) {
      return 'Name must be at least 2 characters long.';
    }
    if (name.trim().length > 50) {
      return 'Name must be 50 characters or less.';
    }
    return null;
  }

  // 사용자 이름 업데이트
  Future<AuthResult> updateUserName({required int userId, required String newName}) async {
    try {
      // 이름 검증
      String? nameError = _validateName(newName);
      if (nameError != null) {
        return AuthResult(success: false, message: nameError);
      }

      // 데이터베이스에서 이름 업데이트
      bool success = await _databaseHelper.updateUserName(userId, newName.trim());

      if (success) {
        // 현재 사용자 정보 업데이트
        if (_currentUser?.id == userId) {
          _currentUser = _currentUser!.copyWith(name: newName.trim());
        }

        return AuthResult(success: true, message: 'Name has been updated successfully.');
      } else {
        return AuthResult(success: false, message: 'Failed to update name.');
      }
    } catch (e) {
      print('Update Name Error: $e');
      return AuthResult(success: false, message: 'An error occurred during name update.');
    }
  }

  // 사용자 비밀번호 업데이트
  Future<AuthResult> updateUserPassword({required int userId, required String newPassword}) async {
    try {
      // 비밀번호 검증
      String? passwordError = _validatePassword(newPassword);
      if (passwordError != null) {
        return AuthResult(success: false, message: passwordError);
      }

      // 새 비밀번호 해시화
      String salt = _generateSalt();
      String hashedPassword = _hashPassword(newPassword, salt);
      String saltedPassword = '$salt:$hashedPassword';

      // 데이터베이스에서 비밀번호 업데이트
      bool success = await _databaseHelper.updateUserPassword(userId, saltedPassword);

      if (success) {
        return AuthResult(success: true, message: 'Password has been updated successfully.');
      } else {
        return AuthResult(success: false, message: 'Failed to update password.');
      }
    } catch (e) {
      print('Update Password Error: $e');
      return AuthResult(success: false, message: 'An error occurred during password update.');
    }
  }
}

// 인증 결과 클래스
class AuthResult {
  final bool success;
  final String message;
  final User? user;

  AuthResult({required this.success, required this.message, this.user});

  @override
  String toString() {
    return 'AuthResult{success: $success, message: $message}';
  }
}
