import 'package:flutter/material.dart';

class SendCompleteScreen extends StatefulWidget {
  const SendCompleteScreen({super.key});

  @override
  State<SendCompleteScreen> createState() => _SendCompleteScreenState();
}

class _SendCompleteScreenState extends State<SendCompleteScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    // 체크 아이콘 주변의 펄스 애니메이션 설정
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
    const String partnerName = "민수"; // 실제 데이터 연동 가능

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false, // 전송 완료 후에는 뒤로가기를 막는 것이 일반적
        title: const Text(
          '전송 완료',
          style: TextStyle(
            color: Color(0xFF1E293B),
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Stack(
        children: [
          // 중앙 콘텐츠
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // 1. 애니메이션 체크 아이콘
                  _buildAnimatedCheck(primaryColor),

                  const SizedBox(height: 32),

                  // 2. 전송 완료 메시지
                  const Text(
                    '전송 완료!',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E293B),
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 12),
                  RichText(
                    textAlign: TextAlign.center,
                    text: const TextSpan(
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xFF64748B),
                        height: 1.5,
                        fontFamily: 'Pretendard',
                      ),
                      children: [
                        TextSpan(
                          text: partnerName,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF334155),
                          ),
                        ),
                        TextSpan(text: '님에게 질문지가\n성공적으로 전달되었습니다.'),
                      ],
                    ),
                  ),

                  const SizedBox(height: 40),

                  // 3. 알림 형태의 요약 카드
                  _buildInfoCard(primaryColor),
                ],
              ),
            ),
          ),

          // 4. 하단 홈으로 돌아가기 버튼
          Positioned(
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
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(top: BorderSide(color: Color(0xFFF8FAFC))),
              ),
              child: ElevatedButton(
                onPressed: () {
                  // 모든 스택을 비우고 홈 화면으로 이동
                  Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 56),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 8,
                  shadowColor: primaryColor.withOpacity(0.3),
                ),
                child: const Text(
                  '홈으로 돌아가기',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 펄스 애니메이션이 적용된 체크 원형 위젯
  Widget _buildAnimatedCheck(Color primaryColor) {
    return AnimatedBuilder(
      animation: _pulseController,
      builder: (context, child) {
        return Stack(
          alignment: Alignment.center,
          children: [
            // 바깥쪽 블러 효과 원
            Container(
              width: 120 + (30 * _pulseController.value),
              height: 120 + (30 * _pulseController.value),
              decoration: BoxDecoration(
                color: primaryColor.withOpacity(0.05 * (1 - _pulseController.value)),
                shape: BoxShape.circle,
              ),
            ),
            // 안쪽 펄스 원
            Container(
              width: 80 + (20 * _pulseController.value),
              height: 80 + (20 * _pulseController.value),
              decoration: BoxDecoration(
                color: primaryColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
            ),
            // 메인 체크 버튼
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: primaryColor,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: primaryColor.withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
                border: Border.all(color: Colors.white, width: 4),
              ),
              child: const Icon(Icons.check, color: Colors.white, size: 40),
            ),
          ],
        );
      },
    );
  }

  // 하단 메일 정보 카드
  Widget _buildInfoCard(Color primaryColor) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFF1F5F9)),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFFF1F5F9)),
            ),
            child: Icon(Icons.mail, color: primaryColor, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      '질문지 도착',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                    Text(
                      '방금 전',
                      style: TextStyle(color: Colors.grey.shade400, fontSize: 10),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                const Text(
                  '맞춤 질문 5개가 포함되어 있습니다.',
                  style: TextStyle(color: Color(0xFF64748B), fontSize: 12),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
    );
  }
}