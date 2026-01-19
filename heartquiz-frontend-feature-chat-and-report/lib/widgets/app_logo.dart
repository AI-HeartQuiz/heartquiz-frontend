import 'package:flutter/material.dart';

/// 앱 전역에서 재사용할 하트 로고 위젯입니다.
/// 나중에 크기(size)만 조절해서 어디서든 쓸 수 있습니다.
class HeartQuizLogo extends StatelessWidget {
  final double size;

  const HeartQuizLogo({super.key, this.size = 144});

  @override
  Widget build(BuildContext context) {
    // Theme에서 설정한 primaryColor를 가져와서 씁니다.
    final primaryColor = Theme.of(context).primaryColor;

    return Stack(
      alignment: Alignment.center,
      children: [
        // 외곽 원형 배경
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: primaryColor.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
        ),
        // 메인 하트 박스
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(size * 0.22), // 크기에 비례한 곡률
            boxShadow: [
              BoxShadow(
                color: primaryColor.withOpacity(0.15),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Center(
            child: Icon(
              Icons.favorite,
              size: size * 0.55,
              color: const Color(0xFFF5697F), // 하트 고유색
            ),
          ),
        ),
      ],
    );
  }
}
