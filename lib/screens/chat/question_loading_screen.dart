import 'package:flutter/material.dart';
import 'dart:async';

class QuestionLoadingScreen extends StatefulWidget {
  const QuestionLoadingScreen({super.key});

  @override
  State<QuestionLoadingScreen> createState() => _QuestionLoadingScreenState();
}

class _QuestionLoadingScreenState extends State<QuestionLoadingScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _progressAnimation;

  @override
  void initState() {
    super.initState();

    // 3초 동안 로딩 애니메이션 진행
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    _progressAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _controller.forward();

    // 로딩이 완료되면 질문 리스트 화면으로 이동
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Navigator.pushReplacementNamed(context, '/question_list');
      }
    });
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
                    '두 분을 위한 특별한 질문을\n생성하고 있어요',
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

                  // 프로그레스 바 섹션
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
          child: Icon(Icons.smart_toy, size: 70, color: primaryColor),
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
                  'Generating...',
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
                      )
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              '대화 기록을 분석하여 맞춤 질문을 만들고 있습니다.',
              style: TextStyle(color: Color(0xFF94A3B8), fontSize: 11),
            ),
          ],
        );
      },
    );
  }
}