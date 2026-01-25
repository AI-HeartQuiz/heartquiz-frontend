import 'package:flutter/material.dart';

/// 1. 기록 검색바 (onChanged 추가하여 실시간 검색 연결)
class RecordSearchBar extends StatelessWidget {
  final ValueChanged<String>? onChanged;
  final TextEditingController? controller;

  const RecordSearchBar({super.key, this.onChanged, this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      height: 48,
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(Icons.search, color: Color(0xFF9CA3AF), size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: controller,
              onChanged: onChanged,
              decoration: const InputDecoration(
                hintText: '기록 검색',
                hintStyle: TextStyle(color: Color(0xFF9CA3AF), fontSize: 15),
                border: InputBorder.none,
                isDense: true,
              ),
            ),
          ),
          // 글자가 있을 때 지우기 버튼 표시 (선택 사항)
          if (controller != null && controller!.text.isNotEmpty)
            GestureDetector(
              onTap: () {
                controller!.clear();
                if (onChanged != null) onChanged!("");
              },
              child: const Icon(
                Icons.cancel,
                color: Color(0xFFD1D5DB),
                size: 20,
              ),
            ),
        ],
      ),
    );
  }
}

/// 2. 필터 탭 위젯 (기존과 동일하지만 가독성 유지)
class RecordFilterTabs extends StatelessWidget {
  final String selectedTab;
  final Function(String) onTabChanged;

  const RecordFilterTabs({
    super.key,
    required this.selectedTab,
    required this.onTabChanged,
  });

  @override
  Widget build(BuildContext context) {
    final tabs = ['전체', '진행 중', '완료됨'];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: tabs.map((tab) {
          final isSelected = selectedTab == tab;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () => onTabChanged(tab),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFF12C49D) : Colors.white,
                  borderRadius: BorderRadius.circular(100),
                  border: Border.all(
                    color: isSelected
                        ? const Color(0xFF12C49D)
                        : const Color(0xFFE5E7EB),
                  ),
                ),
                child: Text(
                  tab,
                  style: TextStyle(
                    color: isSelected ? Colors.white : const Color(0xFF6B7280),
                    fontSize: 13,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

/// 3. 기록 데이터 모델 (리스트 관리를 위해 추가)
class RecordItem {
  final String name;
  final String title;
  final String description;
  final String status;
  final IconData avatarIcon;
  final Color avatarBgColor;
  final Color avatarIconColor;

  RecordItem({
    required this.name,
    required this.title,
    required this.description,
    required this.status,
    required this.avatarIcon,
    required this.avatarBgColor,
    required this.avatarIconColor,
  });
}

/// 4. 기록 카드 위젯
class RecordListCard extends StatelessWidget {
  final RecordItem item;

  const RecordListCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final isOngoing = item.status == '진행 중';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFF9FAFB)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // 리포트 스타일 프로필 아이콘
          Builder(
            builder: (context) {
              final colorIndex =
                  item.name.codeUnits.fold(0, (a, b) => a + b) % 7;
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
              final bgColor = colors[colorIndex];
              final iconColor = iconColors[colorIndex];

              return Container(
                width: 48,
                height: 48,
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
                child: Icon(Icons.person, color: iconColor, size: 28),
              );
            },
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      item.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF111111),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: isOngoing
                            ? const Color(0xFF12C49D).withOpacity(0.1)
                            : const Color(0xFFF3F4F6),
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Text(
                        item.status,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: isOngoing
                              ? const Color(0xFF12C49D)
                              : const Color(0xFF6B7280),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  item.title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF111111),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  item.description,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF767676),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: Color(0xFFD1D5DB), size: 20),
        ],
      ),
    );
  }
}
