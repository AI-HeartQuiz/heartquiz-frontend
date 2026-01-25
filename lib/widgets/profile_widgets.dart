import 'package:flutter/material.dart';

/// 1. 프로필 상단 헤더 (제목, 설정)
class ProfileHeader extends StatelessWidget {
  final String title;
  final VoidCallback onSettingsTap;

  const ProfileHeader({
    super.key,
    required this.title,
    required this.onSettingsTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: Colors.white,
      child: Row(
        children: [
          // 왼쪽에 설정 아이콘과 같은 너비의 빈 공간
          SizedBox(width: 48, height: 48),
          // 가운데 정렬된 타이틀
          Expanded(
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF181116),
              ),
            ),
          ),
          // 오른쪽 설정 아이콘
          IconButton(
            icon: const Icon(Icons.settings_outlined, color: Color(0xFF181116)),
            onPressed: onSettingsTap,
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
    // 리포트 스타일: 닉네임 기반으로 배경색과 아이콘 색상 결정
    final colorIndex = name.codeUnits.fold(0, (a, b) => a + b) % 7;
    final colors = [
      const Color(0xFFE8F5E9), // 초록
      const Color(0xFFE3F2FD), // 파랑
      const Color(0xFFF3E5F5), // 보라
      const Color(0xFFFFE0B2), // 주황
      const Color(0xFFE0F2F1), // 청록
      const Color(0xFFE1F5FE), // 하늘
      const Color(0xFFEDE7F6), // 연보라
    ];
    final iconColors = [
      const Color(0xFF12C49D).withOpacity(0.6), // 초록
      Colors.blue.shade300, // 파랑
      Colors.purple.shade300, // 보라
      Colors.orange.shade300, // 주황
      Colors.teal.shade300, // 청록
      Colors.cyan.shade300, // 하늘
      Colors.indigo.shade300, // 연보라
    ];
    final bgColor = colors[colorIndex];
    final iconColor = iconColors[colorIndex];

    return Column(
      children: [
        Container(
          width: 112,
          height: 112,
          decoration: BoxDecoration(
            color: bgColor,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 2),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Icon(Icons.person, size: 64, color: iconColor),
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
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: const Color(0xFF111816),
          backgroundColor: const Color(0xFFF6F7F7),
          side: const BorderSide(color: Color(0xFFF0F0F0)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 20),
            const SizedBox(width: 8),
            Text(text),
          ],
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
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF12C49D),
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.person_add_alt_1, size: 20),
            const SizedBox(width: 8),
            const Text('새로운 친구 추가'),
          ],
        ),
      ),
    );
  }
}
