import 'package:flutter/material.dart';

/// 1. 친구 추가 상단 헤더
class FriendSearchHeader extends StatelessWidget {
  final String title;
  final VoidCallback onBackTap;

  const FriendSearchHeader({
    super.key,
    required this.title,
    required this.onBackTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Color(0xFFF9FAFB))),
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(
              Icons.chevron_left,
              color: Color(0xFF111816),
              size: 32,
            ),
            onPressed: onBackTap,
          ),
          Expanded(
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF111816),
              ),
            ),
          ),
          const SizedBox(width: 48),
        ],
      ),
    );
  }
}

/// 2. 친구 검색바
class FriendSearchBar extends StatelessWidget {
  final String hintText;
  final TextEditingController? controller;
  final Function(String)? onSubmitted;
  final Function(String)? onChanged;

  const FriendSearchBar({
    super.key,
    required this.hintText,
    this.controller,
    this.onSubmitted,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52,
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(16),
      ),
      child: TextField(
        controller: controller,
        onSubmitted: onSubmitted,
        onChanged: onChanged,
        textInputAction: TextInputAction.search,
        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(color: Color(0xFF9CA3AF), fontSize: 14),
          prefixIcon: const Icon(
            Icons.search,
            color: Color(0xFF9CA3AF),
            size: 22,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 15),
        ),
      ),
    );
  }
}

/// 3. 친구 검색 결과 카드
class FriendSearchResultCard extends StatelessWidget {
  final String name;
  final String email;
  final VoidCallback onAddTap;

  const FriendSearchResultCard({
    super.key,
    required this.name,
    required this.email,
    required this.onAddTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
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
          // 리포트 스타일: 닉네임 기반으로 배경색과 아이콘 색상 결정
          Builder(
            builder: (context) {
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

              return Container(
            width: 56,
            height: 56,
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
                child: Icon(Icons.person, color: iconColor, size: 36),
              );
            },
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  email,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF6B7280),
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: onAddTap,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF12C49D),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
            child: const Text('추가'),
          ),
        ],
      ),
    );
  }
}

/// 4. 친구 요청 아이템 (받은 요청 목록용)
class FriendRequestItem extends StatelessWidget {
  final String nickname;
  final VoidCallback onAccept;

  const FriendRequestItem({
    super.key,
    required this.nickname,
    required this.onAccept,
  });

  @override
  Widget build(BuildContext context) {
    // 닉네임 기반 색상 결정
    final colorIndex = nickname.codeUnits.fold(0, (a, b) => a + b) % 7;
    final colors = [
      const Color(0xFFE8F5E9),
      const Color(0xFFE3F2FD),
      const Color(0xFFF3E5F5),
      const Color(0xFFFFE0B2),
      const Color(0xFFE0F2F1),
      const Color(0xFFE1F5FE),
      const Color(0xFFEDE7F6),
    ];
    final iconColors = [
      const Color(0xFF12C49D).withOpacity(0.6),
      Colors.blue.shade300,
      Colors.purple.shade300,
      Colors.orange.shade300,
      Colors.teal.shade300,
      Colors.cyan.shade300,
      Colors.indigo.shade300,
    ];

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF7ED),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFF97316).withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: colors[colorIndex],
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2),
            ),
            child: Icon(Icons.person, color: iconColors[colorIndex], size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              nickname,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
            ),
          ),
          ElevatedButton(
            onPressed: onAccept,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFF97316),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              minimumSize: Size.zero,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              elevation: 0,
            ),
            child: const Text(
              '수락',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
