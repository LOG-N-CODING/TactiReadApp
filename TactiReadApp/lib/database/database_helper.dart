import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'models/user_model.dart';
import 'models/document_model.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  DatabaseHelper._internal();

  factory DatabaseHelper() => _instance;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'tactiread.db');

    return await openDatabase(path, version: 4, onCreate: _onCreate, onUpgrade: _onUpgrade);
  }

  Future<void> _onCreate(Database db, int version) async {
    // 사용자 테이블 생성
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        email TEXT UNIQUE NOT NULL,
        password TEXT NOT NULL,
        name TEXT NOT NULL,
        created_at TEXT NOT NULL,
        last_login_at TEXT,
        updated_at TEXT,
        is_active INTEGER NOT NULL DEFAULT 1
      )
    ''');

    // 사용자 설정 테이블 생성
    await db.execute('''
      CREATE TABLE user_settings (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER NOT NULL,
        dark_mode INTEGER NOT NULL DEFAULT 0,
        high_contrast INTEGER NOT NULL DEFAULT 0,
        voice_type TEXT NOT NULL DEFAULT 'female',
        reading_speed REAL NOT NULL DEFAULT 0.5,
        audio_cues INTEGER NOT NULL DEFAULT 1,
        double_tap_shortcuts INTEGER NOT NULL DEFAULT 1,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL,
        FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE
      )
    ''');

    // 문서 테이블 생성
    // 문서 테이블 생성
    await db.execute('''
      CREATE TABLE documents (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER NOT NULL,
        file_name TEXT NOT NULL,
        file_path TEXT NOT NULL,
        file_type TEXT NOT NULL,
        file_size INTEGER NOT NULL,
        is_favorite INTEGER NOT NULL DEFAULT 0,
        created_at TEXT NOT NULL,
        last_accessed_at TEXT,
        processing_type TEXT NOT NULL DEFAULT 'display_as_is',
        FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE
      )
    ''');

    print('Database tables created successfully');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // 향후 데이터베이스 스키마 업그레이드 시 사용
    if (oldVersion < 2) {
      // 버전 2: users 테이블에 updated_at 컬럼 추가
      await db.execute('ALTER TABLE users ADD COLUMN updated_at TEXT');
    }
    if (oldVersion < 3) {
      // 버전 3: documents 테이블 스키마 업데이트
      await db.execute('DROP TABLE IF EXISTS documents');
      await db.execute('''
        CREATE TABLE documents (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          user_id INTEGER NOT NULL,
          file_name TEXT NOT NULL,
          file_path TEXT NOT NULL,
          file_type TEXT NOT NULL,
          file_size INTEGER NOT NULL,
          is_favorite INTEGER NOT NULL DEFAULT 0,
          created_at TEXT NOT NULL,
          last_accessed_at TEXT,
          FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE
        )
      ''');
    }
    if (oldVersion < 4) {
      // 버전 4: documents 테이블에 processing_type 컬럼 추가
      await db.execute(
        'ALTER TABLE documents ADD COLUMN processing_type TEXT NOT NULL DEFAULT "display_as_is"',
      );
    }
  }

  // 사용자 관련 메서드들
  Future<int> insertUser(User user) async {
    final db = await database;
    return await db.insert('users', user.toMap());
  }

  Future<User?> getUserByEmail(String email) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'users',
      where: 'email = ? AND is_active = 1',
      whereArgs: [email],
    );

    if (maps.isNotEmpty) {
      return User.fromMap(maps.first);
    }
    return null;
  }

  Future<User?> getUserById(int id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'users',
      where: 'id = ? AND is_active = 1',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return User.fromMap(maps.first);
    }
    return null;
  }

  Future<int> updateUser(User user) async {
    final db = await database;
    return await db.update('users', user.toMap(), where: 'id = ?', whereArgs: [user.id]);
  }

  Future<int> updateLastLogin(int userId) async {
    final db = await database;
    return await db.update(
      'users',
      {'last_login_at': DateTime.now().toIso8601String()},
      where: 'id = ?',
      whereArgs: [userId],
    );
  }

  Future<int> deleteUser(int id) async {
    final db = await database;
    return await db.update('users', {'is_active': 0}, where: 'id = ?', whereArgs: [id]);
  }

  Future<bool> emailExists(String email) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'users',
      where: 'email = ? AND is_active = 1',
      whereArgs: [email],
    );
    return maps.isNotEmpty;
  }

  // 기본 사용자 설정 생성
  Future<int> createDefaultUserSettings(int userId) async {
    final db = await database;
    final now = DateTime.now().toIso8601String();

    return await db.insert('user_settings', {
      'user_id': userId,
      'dark_mode': 0,
      'high_contrast': 0,
      'voice_type': 'female',
      'reading_speed': 0.5,
      'audio_cues': 1,
      'double_tap_shortcuts': 1,
      'created_at': now,
      'updated_at': now,
    });
  }

  // 데이터베이스 닫기
  Future<void> closeDatabase() async {
    final db = await database;
    await db.close();
    _database = null;
  }

  // 개발용: 모든 데이터 삭제
  Future<void> clearAllData() async {
    final db = await database;
    await db.delete('user_settings');
    await db.delete('documents');
    await db.delete('users');
  }

  // 사용자 이름 업데이트
  Future<bool> updateUserName(int userId, String newName) async {
    try {
      final db = await database;

      final result = await db.update(
        'users',
        {'name': newName, 'updated_at': DateTime.now().toIso8601String()},
        where: 'id = ?',
        whereArgs: [userId],
      );

      return result > 0;
    } catch (e) {
      print('Update user name error: $e');
      return false;
    }
  }

  // 사용자 비밀번호 업데이트
  Future<bool> updateUserPassword(int userId, String newPassword) async {
    try {
      final db = await database;

      final result = await db.update(
        'users',
        {'password': newPassword, 'updated_at': DateTime.now().toIso8601String()},
        where: 'id = ?',
        whereArgs: [userId],
      );

      return result > 0;
    } catch (e) {
      print('Update user password error: $e');
      return false;
    }
  }

  // ===== 문서 관련 메서드들 =====

  // 문서 추가
  Future<int> insertDocument(Document document) async {
    final db = await database;
    return await db.insert('documents', document.toMap());
  }

  // 문서 업데이트
  Future<bool> updateDocument(Document document) async {
    try {
      final db = await database;
      int result = await db.update(
        'documents',
        document.toMap(),
        where: 'id = ?',
        whereArgs: [document.id],
      );
      return result > 0;
    } catch (e) {
      print('Update document error: $e');
      return false;
    }
  }

  // 사용자의 모든 문서 조회
  Future<List<Document>> getDocumentsByUserId(int userId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'documents',
      where: 'user_id = ?',
      whereArgs: [userId],
      orderBy: 'created_at DESC',
    );

    return List.generate(maps.length, (i) {
      return Document.fromMap(maps[i]);
    });
  }

  // 문서 검색 (파일명으로)
  Future<List<Document>> searchDocuments(int userId, String query) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'documents',
      where: 'user_id = ? AND file_name LIKE ?',
      whereArgs: [userId, '%$query%'],
      orderBy: 'created_at DESC',
    );

    return List.generate(maps.length, (i) {
      return Document.fromMap(maps[i]);
    });
  }

  // 파일 타입별 문서 조회
  Future<List<Document>> getDocumentsByType(int userId, String fileType) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'documents',
      where: 'user_id = ? AND file_type = ?',
      whereArgs: [userId, fileType],
      orderBy: 'created_at DESC',
    );

    return List.generate(maps.length, (i) {
      return Document.fromMap(maps[i]);
    });
  }

  // 즐겨찾기 문서 조회
  Future<List<Document>> getFavoriteDocuments(int userId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'documents',
      where: 'user_id = ? AND is_favorite = 1',
      whereArgs: [userId],
      orderBy: 'created_at DESC',
    );

    return List.generate(maps.length, (i) {
      return Document.fromMap(maps[i]);
    });
  }

  // 최근 문서 조회 (최근 접근한 순)
  Future<List<Document>> getRecentDocuments(int userId, {int limit = 10}) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'documents',
      where: 'user_id = ? AND last_accessed_at IS NOT NULL',
      whereArgs: [userId],
      orderBy: 'last_accessed_at DESC',
      limit: limit,
    );

    return List.generate(maps.length, (i) {
      return Document.fromMap(maps[i]);
    });
  }

  // 문서 즐겨찾기 토글
  Future<bool> toggleDocumentFavorite(int documentId, bool isFavorite) async {
    try {
      final db = await database;
      final result = await db.update(
        'documents',
        {'is_favorite': isFavorite ? 1 : 0},
        where: 'id = ?',
        whereArgs: [documentId],
      );
      return result > 0;
    } catch (e) {
      print('Toggle favorite error: $e');
      return false;
    }
  }

  // 문서 마지막 접근 시간 업데이트
  Future<bool> updateDocumentLastAccessed(int documentId) async {
    try {
      final db = await database;
      final result = await db.update(
        'documents',
        {'last_accessed_at': DateTime.now().toIso8601String()},
        where: 'id = ?',
        whereArgs: [documentId],
      );
      return result > 0;
    } catch (e) {
      print('Update last accessed error: $e');
      return false;
    }
  }

  // 문서 삭제
  Future<bool> deleteDocument(int documentId) async {
    try {
      final db = await database;
      final result = await db.delete('documents', where: 'id = ?', whereArgs: [documentId]);
      return result > 0;
    } catch (e) {
      print('Delete document error: $e');
      return false;
    }
  }

  // 문서 ID로 조회
  Future<Document?> getDocumentById(int documentId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'documents',
      where: 'id = ?',
      whereArgs: [documentId],
    );

    if (maps.isNotEmpty) {
      return Document.fromMap(maps.first);
    }
    return null;
  }
}
