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
          Container(
            width: 56,
            height: 56,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFE0F7FA), Color(0xFFB2EBF2)],
              ),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.face_rounded,
              color: Color(0xFF60A5FA),
              size: 36,
            ),
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
                    color: Color(0xFF886364),
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

/// 4. 받은 친구 요청 카드 (수락 버튼 포함)
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
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF7ED), // 살짝 연한 주황색 배경으로 강조
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFFFE0B2)),
      ),
      child: Row(
        children: [
          // 프로필 아이콘
          Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.person_add,
              color: Color(0xFFF97316),
              size: 20,
            ),
          ),
          const SizedBox(width: 12),

          // 텍스트
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  nickname,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF9A3412),
                  ),
                ),
                const Text(
                  '친구 요청이 왔어요!',
                  style: TextStyle(fontSize: 11, color: Color(0xFFC2410C)),
                ),
              ],
            ),
          ),

          // 수락 버튼
          ElevatedButton(
            onPressed: onAccept,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: const Color(0xFFF97316),
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              minimumSize: Size.zero,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: const BorderSide(color: Color(0xFFF97316)),
              ),
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
