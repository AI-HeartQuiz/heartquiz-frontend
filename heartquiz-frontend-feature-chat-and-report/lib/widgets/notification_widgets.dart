import 'package:flutter/material.dart';
import 'package:heartquiz/models/notification_model.dart';

/// 알림 카드 위젯
class NotificationCard extends StatelessWidget {
  final NotificationModel notification;
  final VoidCallback? onTap;

  const NotificationCard({
    super.key,
    required this.notification,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // 아바타 색상 결정 (닉네임 기반 또는 저장된 색상)
    final avatarColor = _getAvatarColor(notification.senderNickname);
    final iconColor = _getIconColor(notification.senderNickname);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.transparent,
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 20,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // 아바타
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: avatarColor,
                shape: BoxShape.circle,
                border: Border.all(
                  color: const Color(0xFFF6F8F8),
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(
                Icons.face_3,
                color: iconColor,
                size: 28,
              ),
            ),
            const SizedBox(width: 16),
            // 알림 내용
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    notification.message,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF181111),
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    notification.relativeTime,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.normal,
                      color: Color(0xFF886364),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            // 화살표 아이콘
            Icon(
              Icons.chevron_right,
              color: Colors.grey.shade300,
              size: 24,
            ),
          ],
        ),
      ),
    );
  }

  Color _getAvatarColor(String nickname) {
    final colorIndex = nickname.codeUnits.fold(0, (a, b) => a + b) % 7;
    final colors = [
      Colors.pink.shade100,
      Colors.blue.shade100,
      Colors.purple.shade100,
      Colors.orange.shade100,
      Colors.green.shade100,
      Colors.teal.shade100,
      Colors.indigo.shade100,
    ];
    return colors[colorIndex];
  }

  Color _getIconColor(String nickname) {
    final colorIndex = nickname.codeUnits.fold(0, (a, b) => a + b) % 7;
    final colors = [
      Colors.pink.shade500,
      Colors.blue.shade500,
      Colors.purple.shade500,
      Colors.orange.shade500,
      Colors.green.shade500,
      Colors.teal.shade500,
      Colors.indigo.shade500,
    ];
    return colors[colorIndex];
  }
}
