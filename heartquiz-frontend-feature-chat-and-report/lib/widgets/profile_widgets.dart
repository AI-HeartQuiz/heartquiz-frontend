import 'package:flutter/material.dart';

/// 1. 프로필 상단 헤더 (설정, 제목, 알림)
class ProfileHeader extends StatelessWidget {
  final String title;
  final VoidCallback onSettingsTap;
  final VoidCallback onNotificationTap;

  const ProfileHeader({
    super.key,
    required this.title,
    required this.onSettingsTap,
    required this.onNotificationTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.settings_outlined, color: Color(0xFF181116)),
            onPressed: onSettingsTap,
          ),
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF181116),
            ),
          ),
          IconButton(
            icon: const Icon(
              Icons.notifications_none_rounded,
              color: Color(0xFF181116),
            ),
            onPressed: onNotificationTap,
          ),
        ],
      ),
    );
  }
}

/// 2. 프로필 아바타 (지민 캐릭터 + 편집 버튼)
class ProfileAvatar extends StatelessWidget {
  final String name;
  final String bio;
  final VoidCallback onEditTap;

  const ProfileAvatar({
    super.key,
    required this.name,
    required this.bio,
    required this.onEditTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.bottomRight,
          children: [
            Container(
              width: 112,
              height: 112,
              decoration: BoxDecoration(
                color: Colors.pink.shade50,
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFFF6F7F7), width: 4),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Icon(
                Icons.face_3,
                size: 64,
                color: Color(0xFFF48FB1),
              ),
            ),
            GestureDetector(
              onTap: onEditTap,
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: const Color(0xFF12C49D),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: const Icon(Icons.edit, color: Colors.white, size: 16),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          name,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xFF111816),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          bio,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.grey,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

/// 3. 정보 수정 버튼 (회색 배경)
class ProfileActionButton extends StatelessWidget {
  final String text;
  final IconData icon;
  final VoidCallback onPressed;

  const ProfileActionButton({
    super.key,
    required this.text,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: OutlinedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 20),
        label: Text(text),
        style: OutlinedButton.styleFrom(
          foregroundColor: const Color(0xFF111816),
          backgroundColor: const Color(0xFFF6F7F7),
          side: const BorderSide(color: Color(0xFFF0F0F0)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
      ),
    );
  }
}

/// 4. 친구 추가 버튼 (초록색 배경)
class FriendAddButton extends StatelessWidget {
  final VoidCallback onPressed;

  const FriendAddButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: const Icon(Icons.person_add_alt_1, size: 20),
        label: const Text('새로운 친구 추가'),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF12C49D),
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
      ),
    );
  }
}
