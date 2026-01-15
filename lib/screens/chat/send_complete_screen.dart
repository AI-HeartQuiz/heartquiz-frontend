import 'package:flutter/material.dart';

class SendCompleteScreen extends StatelessWidget {
  const SendCompleteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF12C49D);
    const String partnerName = "민수";

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false, // 홈으로만 가게끔 뒤로가기 방지
        title: const Text(
          '전송 완료',
          style: TextStyle(
            color: Color(0xFF1E293B),
            fontSize: 17,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // 1. 정적 체크 아이콘 (움직임 제거)
                    _buildStaticCheck(primaryColor),

                    const SizedBox(height: 32),

                    // 2. 메시지 영역
                    const Text(
                      '전송 완료!',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      '$partnerName님에게 질문지가\n성공적으로 전달되었습니다.',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Color(0xFF64748B),
                        height: 1.5,
                      ),
                    ),

                    const SizedBox(height: 40),

                    // 3. 정보 카드
                    _buildInfoCard(primaryColor),
                  ],
                ),
              ),
            ),
          ),

          // 4. 하단 고정 버튼 (SafeArea 적용으로 기기별 하단 여백 대응)
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: ElevatedButton(
                onPressed: () {
                  // 히스토리를 모두 지우고 홈으로 이동
                  Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 56),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 0, // 깔끔하게 그림자 제거 또는 낮춤
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

  // 움직임 없는 정적인 체크 아이콘
  Widget _buildStaticCheck(Color primaryColor) {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        color: primaryColor.withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Container(
          width: 70,
          height: 70,
          decoration: BoxDecoration(
            color: primaryColor,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 3),
          ),
          child: const Icon(Icons.check, color: Colors.white, size: 35),
        ),
      ),
    );
  }

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
          Icon(Icons.mail_outline, color: primaryColor, size: 24),
          const SizedBox(width: 12),
          const Expanded(
            child: Text(
              '맞춤 질문 5개가 포함되어 있습니다.',
              style: TextStyle(color: Color(0xFF64748B), fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }
}