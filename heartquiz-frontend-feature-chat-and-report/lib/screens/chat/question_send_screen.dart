import 'package:flutter/material.dart';

class QuestionSendScreen extends StatefulWidget {
  const QuestionSendScreen({super.key});

  @override
  State<QuestionSendScreen> createState() => _QuestionSendScreenState();
}

class _QuestionSendScreenState extends State<QuestionSendScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    // 로봇 아이콘의 펄스(깜빡임) 효과를 위한 컨트롤러
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF12C49D);
    const Color bgColor = Color(0xFFF6F8F8);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          '질문 전송',
          style: TextStyle(
            color: Color(0xFF181111),
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Stack(
        children: [
          // 메인 콘텐츠
          SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                _buildMainCard(primaryColor),
                const SizedBox(height: 200), // 하단 버튼 공간 확보
              ],
            ),
          ),

          // 하단 고정 버튼 섹션 (카카오톡 버튼 삭제됨)
          _buildBottomActionArea(primaryColor, bgColor),
        ],
      ),
    );
  }

  // 중앙 메인 카드 위젯
  Widget _buildMainCard(Color primaryColor) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.black.withOpacity(0.05)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // 카드 상단 그래픽 영역
          Container(
            height: 160,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  const Color(0xFFDBEAFE).withOpacity(0.5),
                  primaryColor.withOpacity(0.05),
                ],
              ),
            ),
            child: Center(
              child: AnimatedBuilder(
                animation: _pulseController,
                builder: (context, child) {
                  return Container(
                    width: 96,
                    height: 96,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: primaryColor.withOpacity(0.1 * _pulseController.value),
                          blurRadius: 20 * _pulseController.value,
                          spreadRadius: 10 * _pulseController.value,
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.smart_toy,
                      size: 48,
                      color: primaryColor,
                    ),
                  );
                },
              ),
            ),
          ),
          // 카드 텍스트 영역
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                const Text(
                  '두 분을 위한 맞춤 질문이\n준비되었습니다!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E293B),
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  '대화 기록을 바탕으로 생성된 특별한 질문들이에요.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13,
                    color: Color(0xFF64748B),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 하단 전송 버튼 구역
  Widget _buildBottomActionArea(Color primaryColor, Color bgColor) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 20,
          bottom: MediaQuery.of(context).padding.bottom + 20,
        ),
        decoration: BoxDecoration(
          color: bgColor,
          border: Border(top: BorderSide(color: Colors.black.withOpacity(0.05))),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 정보 문구
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.info_outline, size: 16, color: primaryColor),
                const SizedBox(width: 8),
                const Flexible(
                  child: Text(
                    '상대방이 링크를 클릭해 답변을 마치면 알림을 보내드릴게요.',
                    style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                    overflow: TextOverflow.visible,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // 친구 목록 전송 버튼만 유지
            _buildButton(
              text: '친구 목록에서 선택하여 보내기',
              icon: Icons.contacts,
              color: primaryColor,
              textColor: Colors.white,
              onPressed: () {
                // [추가] 친구 선택 화면으로 이동
                Navigator.pushNamed(context, '/friend_select');
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildButton({
    required String text,
    required IconData icon,
    required Color color,
    required Color textColor,
    Color? borderColor,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: textColor,
          elevation: color == Colors.white ? 0 : 4,
          shadowColor: color == Colors.white ? Colors.transparent : Colors.black26,
          side: borderColor != null ? BorderSide(color: borderColor) : null,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 20),
            const SizedBox(width: 10),
            Text(
              text,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}