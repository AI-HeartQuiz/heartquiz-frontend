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
          _buildAvatar(leftName, const Color(0xFFE8F5E9), const Color(0xFF12C49D).withOpacity(0.6)),
          const Padding(
            padding: EdgeInsets.only(bottom: 24, left: 16, right: 16),
            child: Icon(Icons.favorite, color: Color(0xFF12C49D), size: 32),
          ),
          _buildAvatar(rightName, const Color(0xFFE3F2FD), Colors.blue.shade300),
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
              BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))
            ],
          ),
          child: Icon(Icons.person, size: 48, color: iconColor),
        ),
        const SizedBox(height: 8),
        Text(name, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey)),
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
          BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 2))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: isPartner ? const Color(0xFFF0FDF9) : const Color(0xFFF8FAFC),
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

/// 3. AI 중재 메시지 (그라데이션 카드)
class AiMediationCard extends StatelessWidget {
  final String message;

  const AiMediationCard({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 24),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF12C49D), Color(0xFF0EA685)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: const Color(0xFF12C49D).withOpacity(0.2), blurRadius: 20, offset: const Offset(0, 8))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.auto_awesome, color: Colors.white, size: 18),
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
          const SizedBox(height: 12),
          Text(
            message,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}

/// 4. 상대방의 시선 카드
class PerspectiveCard extends StatelessWidget {
  final String content;

  const PerspectiveCard({super.key, required this.content});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFF1F5F9)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(color: Color(0xFFF8FAFC), shape: BoxShape.circle),
                child: const Icon(Icons.psychology, color: Colors.grey, size: 24),
              ),
              const SizedBox(width: 12),
              const Text('상대방의 시선', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              content,
              style: const TextStyle(fontSize: 14, color: Color(0xFF475569), height: 1.6, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}