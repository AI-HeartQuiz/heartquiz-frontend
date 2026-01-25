/// 퀴즈 세션 목록 아이템 모델 (홈 화면용)
class QuizSessionItem {
  final String sessionId;
  final String partnerNickname; // 상대방 닉네임
  final String status; // '진행 중' 또는 '완료됨'
  // final String? title; // 선택적: 대화 제목/주제
  // final String? description; // 선택적: 대화 설명
  final DateTime? createdAt; // 생성 시간
  final DateTime? updatedAt; // 업데이트 시간

  QuizSessionItem({
    required this.sessionId,
    required this.partnerNickname,
    required this.status,
    // this.title,
    // this.description,
    this.createdAt,
    this.updatedAt,
  });

  factory QuizSessionItem.fromJson(Map<String, dynamic> json) {
    return QuizSessionItem(
      sessionId: json['sessionId']?.toString() ?? '',
      partnerNickname: json['partnerNickname'] ?? '상대방',
      status: json['status'] ?? 'ONGOING', // 'ONGOING' 또는 'COMPLETED'
      // title: json['title'],
      // description: json['description'],
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'session_id': sessionId,
    'partner_nickname': partnerNickname,
    'status': status,
    // 'title': title,
    // 'description': description,
    'created_at': createdAt?.toIso8601String(),
    'updated_at': updatedAt?.toIso8601String(),
  };

  /// 상태를 한국어로 변환
  String get statusKorean {
    switch (status) {
      case 'DRAFT':
        return '작성 중';
      case 'QUESTIONS_READY':
        return '준비 완료';
      case 'ONGOING': // [수정] 백엔드 값 (대문자)
        return '진행 중';
      case 'COMPLETED': // [수정] 백엔드 값 (대문자)
        return '완료됨';
      default:
        return status;
    }
  }

  /// 완료 여부
  bool get isCompleted {
    // [수정] 백엔드 값 (대문자) 체크
    return status == 'COMPLETED';
  }
}
