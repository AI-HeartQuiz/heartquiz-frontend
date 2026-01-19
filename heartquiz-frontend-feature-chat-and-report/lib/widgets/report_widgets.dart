import 'package:flutter/material.dart';

/// 1. 상단 아바타 커플 섹션
class ReportAvatarSection extends StatelessWidget {
  final String leftName;
  final String rightName;

  const ReportAvatarSection({
    super.key,
    required this.leftName,
    required this.rightName,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 32),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          _buildAvatar(
            leftName,
            const Color(0xFFE8F5E9),
            const Color(0xFF12C49D).withOpacity(0.6),
          ),
          const Padding(
            padding: EdgeInsets.only(bottom: 24, left: 16, right: 16),
            child: Icon(Icons.favorite, color: Color(0xFF12C49D), size: 32),
          ),
          _buildAvatar(
            rightName,
            const Color(0xFFE3F2FD),
            Colors.blue.shade300,
          ),
        ],
      ),
    );
  }

  Widget _buildAvatar(String name, Color bgColor, Color iconColor) {
    return Column(
      children: [
        Container(
          width: 96,
          height: 96,
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
          child: Icon(Icons.person, size: 48, color: iconColor),
        ),
        const SizedBox(height: 8),
        Text(
          name,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}

/// 2. 속마음 카드
class InnerThoughtCard extends StatelessWidget {
  final String label;
  final String thought;
  final bool isPartner;

  const InnerThoughtCard({
    super.key,
    required this.label,
    required this.thought,
    this.isPartner = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFF1F5F9)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: isPartner
                  ? const Color(0xFFF0FDF9)
                  : const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: isPartner ? const Color(0xFF12C49D) : Colors.grey,
                letterSpacing: 0.5,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            '"$thought"',
            style: const TextStyle(
              fontSize: 15,
              color: Color(0xFF334155),
              fontWeight: FontWeight.w500,
              fontStyle: FontStyle.italic,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

/// 3. AI 중재 메시지 카드 (HTML 디자인 기준)
class AiMediationWithPerspectiveCard extends StatelessWidget {
  final String title; // mediationTitle
  final String content; // aDetailForB (A의 입장을 B에게 보여줄 내용)

  const AiMediationWithPerspectiveCard({
    super.key,
    required this.title,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF12C49D), Color(0xFF0EA685)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF12C49D).withOpacity(0.2),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        children: [
          // 배경 블러 효과
          Positioned(
            right: -24,
            bottom: -24,
            child: Container(
              width: 128,
              height: 128,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
            ),
          ),
          // 메인 컨텐츠
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // AI 중재 메시지 라벨
                Row(
                  children: [
                    const Icon(
                      Icons.auto_awesome,
                      color: Colors.white,
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'AI 중재 메시지',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.white.withOpacity(0.9),
                        letterSpacing: 1,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // AI 중재 메시지 제목
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 12),
                // 구분선
                Container(
                  height: 1,
                  width: double.infinity,
                  color: Colors.white.withOpacity(0.2),
                ),
                const SizedBox(height: 12),
                // 상세 내용 (aDetailForB)
                Text(
                  content,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.white.withOpacity(0.95),
                    height: 1.6,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// 대화 팁 섹션 위젯
class ConversationTipsSection extends StatelessWidget {
  final List<String> tips;

  const ConversationTipsSection({super.key, required this.tips});

  @override
  Widget build(BuildContext context) {
    if (tips.isEmpty) return const SizedBox.shrink();

    const Color primaryColor = Color(0xFF12C49D);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 32),
        const Row(
          children: [
            Icon(Icons.chat_bubble, color: primaryColor, size: 20),
            SizedBox(width: 8),
            Text(
              '함께 이야기해볼까요?',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ...tips.map(
          (tip) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _ConversationTipCard(tip: tip),
          ),
        ),
      ],
    );
  }
}

/// 대화 팁 개별 카드
class _ConversationTipCard extends StatelessWidget {
  final String tip;

  const _ConversationTipCard({required this.tip});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFF0FDF9),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF12C49D).withOpacity(0.1)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              tip,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF334155),
                height: 1.5,
              ),
            ),
          ),
          const SizedBox(width: 8),
          const Icon(Icons.chevron_right, color: Color(0xFF12C49D)),
        ],
      ),
    );
  }
}
