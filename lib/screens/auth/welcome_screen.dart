import 'package:flutter/material.dart';
import 'package:heartquiz/widgets/auth_widgets.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // 1. 이전 화면(SignUpScreen)에서 보낸 데이터를 받습니다.
    // 만약 전달된 값이 없으면 '사용자'를 기본값으로 사용합니다.
    final String nickname = ModalRoute.of(context)?.settings.arguments as String? ?? "사용자";

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

                    // 2. 받은 닉네임을 화면에 띄웁니다.
                    Text(
                      '환영해요, $nickname님!',
                      style: const TextStyle(
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
                  // 이미 가입은 SignUpScreen에서 끝났으므로 홈으로 바로 보냅니다.
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/home',
                        (route) => false,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

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