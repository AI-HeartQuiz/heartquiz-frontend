/// 알림 데이터 모델
class NotificationModel {
  final String id;
  final String type; // 'quiz_received', 'quiz_answered', etc.
  final String title;
  final String message;
  final String senderNickname;
  final String? senderAvatarColor; // 선택적
  final DateTime createdAt;
  final String? sessionId; // 질문지 관련 알림인 경우
  final bool isRead;

  NotificationModel({
    required this.id,
    required this.type,
    required this.title,
    required this.message,
    required this.senderNickname,
    this.senderAvatarColor,
    required this.createdAt,
    this.sessionId,
    this.isRead = false,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id']?.toString() ?? '',
      type: json['type'] ?? '',
      title: json['title'] ?? '',
      message: json['message'] ?? '',
      senderNickname: json['senderNickname'] ?? '',
      senderAvatarColor: json['sender_avatar_color'],
      createdAt: DateTime.parse(
        json['createdAt'] ?? DateTime.now().toIso8601String(),
      ),
      sessionId: json['sessionId']?.toString(),
      isRead: json['isRead'] ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'type': type,
    'title': title,
    'message': message,
    'sender_nickname': senderNickname,
    'sender_avatar_color': senderAvatarColor,
    'created_at': createdAt.toIso8601String(),
    'session_id': sessionId,
    'is_read': isRead,
  };

  /// 상대적으로 표시할 시간 문자열 (예: "방금 전", "5분 전")
  String get relativeTime {
    final now = DateTime.now();
    final difference = now.difference(createdAt);

    if (difference.inMinutes < 1) {
      return '방금 전';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}분 전';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}시간 전';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}일 전';
    } else {
      return '${createdAt.month}/${createdAt.day}';
    }
  }
}
