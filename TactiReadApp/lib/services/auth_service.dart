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
        return AuthResult(success: false, message: '유효한 이메일 주소를 입력해주세요.');
      }

      // 비밀번호 강도 검증
      String? passwordError = _validatePassword(password);
      if (passwordError != null) {
        return AuthResult(success: false, message: passwordError);
      }

      // 이름 검증
      if (name.trim().length < 2) {
        return AuthResult(success: false, message: '이름은 2자 이상이어야 합니다.');
      }

      // 이메일 중복 체크
      bool emailExistsResult = await _databaseHelper.emailExists(email.toLowerCase());
      if (emailExistsResult) {
        return AuthResult(success: false, message: '이미 사용 중인 이메일입니다.');
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

        return AuthResult(success: true, message: '회원가입이 완료되었습니다.', user: _currentUser);
      } else {
        return AuthResult(success: false, message: '회원가입 중 오류가 발생했습니다.');
      }
    } catch (e) {
      print('SignUp Error: $e');
      return AuthResult(success: false, message: '회원가입 중 오류가 발생했습니다.');
    }
  }

  // 로그인
  Future<AuthResult> signIn({required String email, required String password}) async {
    try {
      // 이메일로 사용자 찾기
      User? user = await _databaseHelper.getUserByEmail(email.toLowerCase());

      if (user == null) {
        return AuthResult(success: false, message: '이메일 또는 비밀번호가 올바르지 않습니다.');
      }

      // 비밀번호 검증
      List<String> passwordParts = user.password.split(':');
      if (passwordParts.length != 2) {
        return AuthResult(success: false, message: '계정 정보에 오류가 있습니다.');
      }

      String salt = passwordParts[0];
      String storedHash = passwordParts[1];
      String inputHash = _hashPassword(password, salt);

      if (inputHash != storedHash) {
        return AuthResult(success: false, message: '이메일 또는 비밀번호가 올바르지 않습니다.');
      }

      // 로그인 성공
      _currentUser = user;

      // 세션 저장
      await UserSessionService.saveLoginSession(user);

      // 마지막 로그인 시간 업데이트
      await _databaseHelper.updateLastLogin(user.id!);

      return AuthResult(success: true, message: '로그인되었습니다.', user: _currentUser);
    } catch (e) {
      print('SignIn Error: $e');
      return AuthResult(success: false, message: '로그인 중 오류가 발생했습니다.');
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
        return AuthResult(success: false, message: '해당 이메일로 등록된 계정을 찾을 수 없습니다.');
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
        return AuthResult(success: true, message: '비밀번호가 재설정되었습니다.');
      } else {
        return AuthResult(success: false, message: '비밀번호 재설정 중 오류가 발생했습니다.');
      }
    } catch (e) {
      print('Reset Password Error: $e');
      return AuthResult(success: false, message: '비밀번호 재설정 중 오류가 발생했습니다.');
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
      return '비밀번호는 6자 이상이어야 합니다.';
    }

    if (password.length > 50) {
      return '비밀번호는 50자 이하여야 합니다.';
    }

    // 기본적인 보안 요구사항
    bool hasLetter = password.contains(RegExp(r'[a-zA-Z]'));
    bool hasDigit = password.contains(RegExp(r'[0-9]'));

    if (!hasLetter || !hasDigit) {
      return '비밀번호는 영문자와 숫자를 포함해야 합니다.';
    }

    return null;
  }

  // 계정 삭제
  Future<AuthResult> deleteAccount() async {
    try {
      if (_currentUser == null) {
        return AuthResult(success: false, message: '로그인이 필요합니다.');
      }

      int result = await _databaseHelper.deleteUser(_currentUser!.id!);

      if (result > 0) {
        _currentUser = null;
        return AuthResult(success: true, message: '계정이 삭제되었습니다.');
      } else {
        return AuthResult(success: false, message: '계정 삭제 중 오류가 발생했습니다.');
      }
    } catch (e) {
      print('Delete Account Error: $e');
      return AuthResult(success: false, message: '계정 삭제 중 오류가 발생했습니다.');
    }
  }

  // 이름 검증
  String? _validateName(String name) {
    if (name.trim().isEmpty) {
      return '이름을 입력해주세요.';
    }
    if (name.trim().length < 2) {
      return '이름은 최소 2자 이상이어야 합니다.';
    }
    if (name.trim().length > 50) {
      return '이름은 50자를 초과할 수 없습니다.';
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

        return AuthResult(success: true, message: '이름이 성공적으로 업데이트되었습니다.');
      } else {
        return AuthResult(success: false, message: '이름 업데이트에 실패했습니다.');
      }
    } catch (e) {
      print('Update Name Error: $e');
      return AuthResult(success: false, message: '이름 업데이트 중 오류가 발생했습니다.');
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
        return AuthResult(success: true, message: '비밀번호가 성공적으로 업데이트되었습니다.');
      } else {
        return AuthResult(success: false, message: '비밀번호 업데이트에 실패했습니다.');
      }
    } catch (e) {
      print('Update Password Error: $e');
      return AuthResult(success: false, message: '비밀번호 업데이트 중 오류가 발생했습니다.');
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
