import 'package:flutter/material.dart';
import 'package:heartquiz/widgets/auth_widgets.dart'; // 공통 위젯 불러오기

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // 장식적인 하트 아이콘들
                    Stack(
                      alignment: Alignment.center,
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          width: 120,
                          height: 120,
                          decoration: const BoxDecoration(
                            color: Color(0xFFFFF0F2),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.favorite,
                            size: 80,
                            color: Color(0xFFFF8E9E),
                          ),
                        ),
                        // 작은 장식 하트들
                        Positioned(
                          top: -5,
                          right: -5,
                          child: _buildBadgeHeart(16),
                        ),
                        Positioned(
                          bottom: 10,
                          left: -20,
                          child: _buildBadgeHeart(12),
                        ),
                      ],
                    ),
                    const SizedBox(height: 40),
                    const Text(
                      '환영해요, 사용자님!',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF181111),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      '서로의 진심을 이어주는\nHeart Quiz를 시작해보세요.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xFF886364),
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: PrimaryButton(
                text: '시작하기',
                onPressed: () {
                  // TODO: 실제 백엔드 회원가입 API 호출 로직 (Service 호출)

                  // [수정 포인트]
                  // 기존: Navigator.pushNamed(context, '/welcome');
                  // 변경: 홈 화면으로 바로 이동하며 이전 스택 제거
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/home',
                        (route) => false, // 모든 이전 화면 스택을 제거하여 뒤로가기 방지
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 작은 하트 배지 위젯
  Widget _buildBadgeHeart(double iconSize) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: const BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
      ),
      child: Icon(
        Icons.favorite,
        size: iconSize,
        color: const Color(0xFFFF8E9E),
      ),
    );
  }
}
