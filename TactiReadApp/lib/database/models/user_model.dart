class User {
  final int? id;
  final String email;
  final String password; // 해시된 비밀번호
  final String name;
  final DateTime createdAt;
  final DateTime? lastLoginAt;
  final DateTime? updatedAt;
  final bool isActive;

  User({
    this.id,
    required this.email,
    required this.password,
    required this.name,
    required this.createdAt,
    this.lastLoginAt,
    this.updatedAt,
    this.isActive = true,
  });

  // SQLite로부터 데이터를 읽어올 때 사용
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      email: map['email'],
      password: map['password'],
      name: map['name'],
      createdAt: DateTime.parse(map['created_at']),
      lastLoginAt: map['last_login_at'] != null ? DateTime.parse(map['last_login_at']) : null,
      updatedAt: map['updated_at'] != null ? DateTime.parse(map['updated_at']) : null,
      isActive: map['is_active'] == 1,
    );
  }

  // SQLite에 저장할 때 사용
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'password': password,
      'name': name,
      'created_at': createdAt.toIso8601String(),
      'last_login_at': lastLoginAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'is_active': isActive ? 1 : 0,
    };
  }

  // 비밀번호 검증용
  User copyWith({
    int? id,
    String? email,
    String? password,
    String? name,
    DateTime? createdAt,
    DateTime? lastLoginAt,
    DateTime? updatedAt,
    bool? isActive,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      password: password ?? this.password,
      name: name ?? this.name,
      createdAt: createdAt ?? this.createdAt,
      lastLoginAt: lastLoginAt ?? this.lastLoginAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isActive: isActive ?? this.isActive,
    );
  }

  @override
  String toString() {
    return 'User{id: $id, email: $email, name: $name, isActive: $isActive}';
  }
}
