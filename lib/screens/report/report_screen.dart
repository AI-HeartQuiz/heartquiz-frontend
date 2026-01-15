import 'package:flutter/material.dart';
import 'package:heartquiz/widgets/report_widgets.dart';

class ReportScreen extends StatelessWidget {
  const ReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF12C49D);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1E293B)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          '우리만의 이해 리포트',
          style: TextStyle(color: Color(0xFF1E293B), fontSize: 17, fontWeight: FontWeight.bold),
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.only(left: 20, right: 20, bottom: 120),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. 아바타 커플 섹션
                const ReportAvatarSection(leftName: '지민', rightName: '민수'),

                // 2. 속마음 비교 섹션
                const InnerThoughtCard(
                  label: '지민의 속마음',
                  thought: '온전히 우리 관계에 몰입하고 대화하는 시간이 저에게는 무엇보다 소중해요.',
                  isPartner: true,
                ),
                const InnerThoughtCard(
                  label: '나의 속마음',
                  thought: '바쁜 일상 속에서도 지민이만큼은 방해받지 않는 온전한 시간을 선물해주고 싶었어요.',
                ),

                // 3. AI 중재 메시지
                const AiMediationCard(
                  message: '"민수님의 \'책임감\'과 지민님의 \'애정\'이 충돌한 순간이었어요."',
                ),

                // 4. 상대방의 시선
                const PerspectiveCard(
                  content: '지민님이 서운함을 표현한 것은 민수님을 탓하기 위해서가 아니에요. 지민님에게 대화는 단순히 정보를 나누는 것이 아니라 서로의 존재에 집중하는 \'연결의 과정\'이었기 때문이에요. 민수님이 바쁜 상황을 해결하려 노력하는 동안, 지민님은 민수님의 세계에서 자신이 잠시 잊힌 듯한 외로움을 느꼈던 것 같아요.',
                ),

                const SizedBox(height: 32),

                // 5. 함께 이야기해볼까요?
                const Row(
                  children: [
                    Icon(Icons.chat_bubble, color: primaryColor, size: 20),
                    SizedBox(width: 8),
                    Text('함께 이야기해볼까요?', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 16),
                _buildDiscussionButton(
                  "다음번에 예상치 못한 연락이 왔을 때, 서로가 불안하지 않게 상황을 공유하는 우리만의 신호를 정해볼까?",
                ),
              ],
            ),
          ),

          // 6. 하단 고정 버튼
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.only(
                left: 20, right: 20, top: 16,
                bottom: MediaQuery.of(context).padding.bottom + 16,
              ),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                border: Border(top: BorderSide(color: Colors.black.withOpacity(0.05))),
              ),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/home');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 56),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 8,
                  shadowColor: primaryColor.withOpacity(0.3),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('홈으로 돌아가기', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDiscussionButton(String text) {
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
              text,
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