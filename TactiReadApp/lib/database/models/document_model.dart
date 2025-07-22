class Document {
  final int? id;
  final int userId;
  final String fileName;
  final String filePath;
  final String fileType; // pdf, png, jpg, docx, txt
  final int fileSize; // bytes
  final bool isFavorite;
  final DateTime createdAt;
  final DateTime? lastAccessedAt;
  final String processingType; // 'display_as_is' or 'extract_text'

  Document({
    this.id,
    required this.userId,
    required this.fileName,
    required this.filePath,
    required this.fileType,
    required this.fileSize,
    this.isFavorite = false,
    required this.createdAt,
    this.lastAccessedAt,
    this.processingType = 'display_as_is', // 기본값
  });

  // SQLite로부터 데이터를 읽어올 때 사용
  factory Document.fromMap(Map<String, dynamic> map) {
    return Document(
      id: map['id'],
      userId: map['user_id'],
      fileName: map['file_name'],
      filePath: map['file_path'],
      fileType: map['file_type'],
      fileSize: map['file_size'],
      isFavorite: map['is_favorite'] == 1,
      createdAt: DateTime.parse(map['created_at']),
      lastAccessedAt: map['last_accessed_at'] != null
          ? DateTime.parse(map['last_accessed_at'])
          : null,
      processingType: map['processing_type'] ?? 'display_as_is',
    );
  }

  // SQLite에 저장할 때 사용
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'file_name': fileName,
      'file_path': filePath,
      'file_type': fileType,
      'file_size': fileSize,
      'is_favorite': isFavorite ? 1 : 0,
      'created_at': createdAt.toIso8601String(),
      'last_accessed_at': lastAccessedAt?.toIso8601String(),
      'processing_type': processingType,
    };
  }

  Document copyWith({
    int? id,
    int? userId,
    String? fileName,
    String? filePath,
    String? fileType,
    int? fileSize,
    bool? isFavorite,
    DateTime? createdAt,
    DateTime? lastAccessedAt,
    String? processingType,
  }) {
    return Document(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      fileName: fileName ?? this.fileName,
      filePath: filePath ?? this.filePath,
      fileType: fileType ?? this.fileType,
      fileSize: fileSize ?? this.fileSize,
      isFavorite: isFavorite ?? this.isFavorite,
      createdAt: createdAt ?? this.createdAt,
      lastAccessedAt: lastAccessedAt ?? this.lastAccessedAt,
      processingType: processingType ?? this.processingType,
    );
  }

  // 파일 크기를 사람이 읽기 쉬운 형태로 변환
  String get formattedFileSize {
    if (fileSize < 1024) {
      return '${fileSize}B';
    } else if (fileSize < 1024 * 1024) {
      return '${(fileSize / 1024).toStringAsFixed(1)}KB';
    } else {
      return '${(fileSize / (1024 * 1024)).toStringAsFixed(1)}MB';
    }
  }

  @override
  String toString() {
    return 'Document{id: $id, userId: $userId, fileName: $fileName, fileType: $fileType, processingType: $processingType}';
  }
}
