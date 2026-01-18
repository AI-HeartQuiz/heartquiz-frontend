import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:heartquiz/widgets/report_widgets.dart';
import 'package:heartquiz/providers/chat_session_provider.dart';
import 'package:heartquiz/providers/auth_provider.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  @override
  void initState() {
    super.initState();
    _loadReport();
  }

  Future<void> _loadReport() async {
    final chatProvider = context.read<ChatSessionProvider>();
    final authProvider = context.read<AuthProvider>();
    final token = authProvider.accessToken;

    if (token == null) {
      return;
    }

    // 이미 리포트 데이터가 있으면 다시 로드하지 않음
    if (chatProvider.reportData != null) {
      return;
    }

    await chatProvider.generateReport(token);
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF12C49D);
    final chatProvider = context.watch<ChatSessionProvider>();
    final authProvider = context.watch<AuthProvider>();
    final report = chatProvider.reportData;
    final userNickname = authProvider.nickname ?? '사용자';

    // 현재 사용자가 A인지 B인지 확인
    // B인 경우: bQuestions가 있고 답변이 완료된 상태
    final isUserB =
        chatProvider.bQuestions.isNotEmpty &&
        chatProvider.areAllBAnswersComplete;

    if (chatProvider.isLoading || report == null) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          title: const Text(
            '우리만의 이해 리포트',
            style: TextStyle(
              color: Color(0xFF1E293B),
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

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
          style: TextStyle(
            color: Color(0xFF1E293B),
            fontSize: 17,
            fontWeight: FontWeight.bold,
          ),
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
                ReportAvatarSection(
                  leftName: userNickname,
                  rightName: report.partnerNickname ?? '상대방',
                ),

                // 2. 속마음 비교 섹션 (A의 속마음, B의 속마음 순서로 고정)
                // B가 볼 때: B의 속마음 → A의 속마음 순서
                // A가 볼 때: A의 속마음 → B의 속마음 순서
                if (isUserB) ...[
                  // B가 보고 있는 경우
                  InnerThoughtCard(
                    label: '${userNickname}의 속마음',
                    thought: report.bThought,
                    isPartner: false,
                  ),
                  InnerThoughtCard(
                    label: '${report.partnerNickname ?? '상대방'}의 속마음',
                    thought: report.aThought,
                    isPartner: true,
                  ),
                ] else ...[
                  // A가 보고 있는 경우
                  InnerThoughtCard(
                    label: '${userNickname}의 속마음',
                    thought: report.aThought,
                    isPartner: false,
                  ),
                  InnerThoughtCard(
                    label: '${report.partnerNickname ?? '상대방'}의 속마음',
                    thought: report.bThought,
                    isPartner: true,
                  ),
                ],

                // 3. AI 중재 메시지 카드
                // B가 볼 때: aDetailForB (A의 입장을 B에게 보여줄 내용)
                // A가 볼 때: bDetailForA (B의 입장을 A에게 보여줄 내용)
                AiMediationWithPerspectiveCard(
                  title: report.mediationTitle,
                  content: isUserB ? report.aDetailForB : report.bDetailForA,
                ),

                // 5. 대화 팁 섹션
                ConversationTipsSection(tips: report.conversationTips),
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
                left: 20,
                right: 20,
                top: 16,
                bottom: MediaQuery.of(context).padding.bottom + 16,
              ),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                border: Border(
                  top: BorderSide(color: Colors.black.withOpacity(0.05)),
                ),
              ),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/home');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 56),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 8,
                  shadowColor: primaryColor.withOpacity(0.3),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '홈으로 돌아가기',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
