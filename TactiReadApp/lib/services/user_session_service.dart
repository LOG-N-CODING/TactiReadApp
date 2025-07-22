import 'package:shared_preferences/shared_preferences.dart';
import '../database/models/user_model.dart';
import '../database/database_helper.dart';

class UserSessionService {
  static const String _keyIsLoggedIn = 'is_logged_in';
  static const String _keyUserId = 'user_id';
  static const String _keyTutorialCompleted = 'tutorial_completed';

  // 로그인 상태 저장
  static Future<void> saveLoginSession(User user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyIsLoggedIn, true);
    await prefs.setInt(_keyUserId, user.id!);
  }

  // 로그아웃
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyIsLoggedIn, false);
    await prefs.remove(_keyUserId);
  }

  // 로그인 상태 확인
  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyIsLoggedIn) ?? false;
  }

  // 현재 사용자 ID 가져오기
  static Future<int?> getCurrentUserId() async {
    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool(_keyIsLoggedIn) ?? false;
    if (!isLoggedIn) return null;
    return prefs.getInt(_keyUserId);
  }

  // 현재 사용자 정보 가져오기
  static Future<User?> getCurrentUser() async {
    final userId = await getCurrentUserId();
    if (userId == null) return null;

    final dbHelper = DatabaseHelper();
    return await dbHelper.getUserById(userId);
  }

  // 튜토리얼 완료 상태 저장
  static Future<void> setTutorialCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyTutorialCompleted, true);
  }

  // 튜토리얼 완료 여부 확인
  static Future<bool> isTutorialCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyTutorialCompleted) ?? false;
  }

  // 모든 데이터 초기화 (앱 재설치 시나 테스트용)
  static Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
