import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:heartquiz/providers/chat_session_provider.dart';
import 'package:heartquiz/providers/auth_provider.dart';

class ReportLoadingScreen extends StatefulWidget {
  final String sessionId;

  const ReportLoadingScreen({super.key, required this.sessionId});

  @override
  State<ReportLoadingScreen> createState() => _ReportLoadingScreenState();
}

class _ReportLoadingScreenState extends State<ReportLoadingScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _progressAnimation;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();

    // 5초 동안 로딩 애니메이션 진행
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    );

    _progressAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    // 애니메이션 시작
    _controller.forward();

    // 리포트 생성 시작
    _generateReport();
  }

  Future<void> _generateReport() async {
    final chatProvider = context.read<ChatSessionProvider>();
    final authProvider = context.read<AuthProvider>();
    final token = authProvider.accessToken;

    if (token == null) {
      setState(() {
        _errorMessage = '로그인이 필요합니다.';
      });
      _controller.stop();
      return;
    }

    // 세션 ID 설정
    chatProvider.setSessionId(widget.sessionId);

    try {
      // 실제 API 호출
      final report = await chatProvider.generateReport(token);

      // API 완료 후 로딩바가 100%에 도달했는지 확인
      if (report != null && mounted) {
        // 5초가 지나지 않았으면 기다림
        if (_controller.value < 1.0) {
          await _controller.animateTo(1.0);
        }

        // 다음 화면으로 이동
        if (mounted) {
          Navigator.pushReplacementNamed(context, '/report');
        }
      } else if (mounted) {
        setState(() {
          _errorMessage = chatProvider.errorMessage ?? '리포트 생성에 실패했습니다.';
        });
        _controller.stop();
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = '리포트 생성 중 오류가 발생했습니다.';
        });
        _controller.stop();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF12C49D);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // 배경 글로우 효과 (HTML의 blur-3xl 효과)
          Positioned(
            top: MediaQuery.of(context).size.height * 0.2,
            right: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                color: primaryColor.withOpacity(0.05),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            bottom: MediaQuery.of(context).size.height * 0.2,
            left: -100,
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.05),
                shape: BoxShape.circle,
              ),
            ),
          ),

          // 중앙 콘텐츠
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // 로봇 아이콘 섹션
                  _buildAnimatedRobot(primaryColor),

                  const SizedBox(height: 48),

                  // 텍스트 정보
                  const Text(
                    '두 분의 대화를 분석하여\n이해 리포트를 생성하고 있어요',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E293B),
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    '잠시만 기다려주세요!',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF64748B),
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  const SizedBox(height: 56),

                  // 에러 메시지 또는 프로그레스 바
                  if (_errorMessage != null)
                    _buildErrorSection(_errorMessage!)
                  else
                    _buildProgressBar(primaryColor),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedRobot(Color primaryColor) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // 펄스 효과 배경
        Container(
          width: 140,
          height: 140,
          decoration: BoxDecoration(
            color: primaryColor.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
        ),
        // 메인 로봇 아이콘 박스
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
            border: Border.all(color: const Color(0xFFF8FAFC), width: 4),
          ),
          child: Icon(Icons.psychology, size: 70, color: primaryColor),
        ),
        // 반짝이는 별 아이콘 (상단 우측)
        Positioned(
          top: 0,
          right: 0,
          child: _buildFloatingIcon(Icons.auto_awesome, Colors.amber, 20),
        ),
      ],
    );
  }

  Widget _buildFloatingIcon(IconData icon, Color color, double size) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10),
        ],
        border: Border.all(color: const Color(0xFFF1F5F9)),
      ),
      child: Icon(icon, color: color, size: size),
    );
  }

  Widget _buildProgressBar(Color primaryColor) {
    return AnimatedBuilder(
      animation: _progressAnimation,
      builder: (context, child) {
        final percent = (_progressAnimation.value * 100).toInt();
        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Analyzing...',
                  style: TextStyle(
                    color: primaryColor,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '$percent%',
                  style: const TextStyle(
                    color: Color(0xFF94A3B8),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Container(
              height: 10,
              width: double.infinity,
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(10),
              ),
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: _progressAnimation.value,
                child: Container(
                  decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: primaryColor.withOpacity(0.3),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              '답변을 분석하여 맞춤 리포트를 생성하고 있습니다.',
              style: TextStyle(color: Color(0xFF94A3B8), fontSize: 11),
            ),
          ],
        );
      },
    );
  }

  Widget _buildErrorSection(String errorMessage) {
    return Column(
      children: [
        Icon(Icons.error_outline, color: Colors.red.shade300, size: 48),
        const SizedBox(height: 16),
        Text(
          errorMessage,
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.red.shade600, fontSize: 14),
        ),
        const SizedBox(height: 24),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF12C49D),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ),
          child: const Text('돌아가기'),
        ),
      ],
    );
  }
}
