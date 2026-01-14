import 'package:flutter/material.dart';

/// 1. 홈 상단 헤더 (인사말 + 하트 아이콘 + 알림)
class HomeHeader extends StatelessWidget {
  final String userName;
  final bool hasNotification;
  final VoidCallback onNotificationTap;

  const HomeHeader({
    super.key,
    required this.userName,
    required this.hasNotification,
    required this.onNotificationTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
      color: const Color(0xFFF6F8F8).withOpacity(0.95),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              // 초록색 하트 아이콘 배경
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: const Color(0xFF12C49D).withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.favorite,
                  color: Color(0xFF12C49D),
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '오늘도 반가워요',
                    style: TextStyle(
                      color: Color(0xFF886364),
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    '안녕, $userName!',
                    style: const TextStyle(
                      color: Color(0xFF181111),
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
          // 알림 아이콘
          _NotificationIcon(
            hasNotification: hasNotification,
            onTap: onNotificationTap,
          ),
        ],
      ),
    );
  }
}

/// 2. 알림 아이콘 (내부 사용용)
class _NotificationIcon extends StatelessWidget {
  final bool hasNotification;
  final VoidCallback onTap;

  const _NotificationIcon({required this.hasNotification, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        IconButton(
          icon: const Icon(
            Icons.notifications_none_rounded,
            size: 28,
            color: Color(0xFF181111),
          ),
          onPressed: onTap,
        ),
        if (hasNotification)
          Positioned(
            right: 14,
            top: 14,
            child: Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: const Color(0xFF12C49D),
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFFF6F8F8), width: 2),
              ),
            ),
          ),
      ],
    );
  }
}

/// 3. 빈 상태 뷰 (대화가 없을 때 나타나는 대시보드 형태 카드)
class EmptyStateView extends StatelessWidget {
  const EmptyStateView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 24),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.5),
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: Colors.black.withOpacity(0.05), width: 2),
      ),
      child: Column(
        children: [
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              Container(
                width: 96,
                height: 96,
                decoration: BoxDecoration(
                  color: const Color(0xFF12C49D).withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.chat_bubble_rounded,
                  size: 56,
                  color: Color(0xFF12C49D),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.sentiment_satisfied_alt_rounded,
                  color: Color(0xFF12C49D),
                  size: 24,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          const Text(
            '현재 진행 중인 대화가 없어요.\n새로운 대화를 시작해볼까요?',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFF886364),
              fontSize: 14,
              fontWeight: FontWeight.w500,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

/// 4. 하단 고정 CTA 버튼 (새 질문지 만들기용)
class FixedBottomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const FixedBottomButton({
    super.key,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        color: const Color(0xFF12C49D),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF12C49D).withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.add, color: Colors.white, size: 24),
              const SizedBox(width: 8),
              Text(
                text,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// 5. 하단 네비게이션 바 (홈, 기록, 내 정보)
class HomeBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const HomeBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.black.withOpacity(0.05))),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(0, Icons.home, Icons.home_outlined, '홈'),
          _buildNavItem(1, Icons.description, Icons.description_outlined, '기록'),
          _buildNavItem(2, Icons.person, Icons.person_outline, '내 정보'),
        ],
      ),
    );
  }

  Widget _buildNavItem(int index, IconData selectedIcon, IconData unselectedIcon, String label) {
    final isSelected = currentIndex == index;
    final color = isSelected ? const Color(0xFF12C49D) : Colors.grey.shade400;

    return GestureDetector(
      onTap: () => onTap(index),
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 80,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 선택되었을 때 FILL(채워진 아이콘)을 사용합니다.
            Icon(
                isSelected ? selectedIcon : unselectedIcon,
                color: color,
                size: 26
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 6. 섹션 타이틀
class SectionTitle extends StatelessWidget {
  final String title;
  const SectionTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w800,
          color: Color(0xFF886364),
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
