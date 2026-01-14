import 'package:flutter/material.dart';
import 'package:heartquiz/widgets/auth_widgets.dart'; // 공통 위젯 불러오기
import 'package:heartquiz/widgets/app_logo.dart'; // 로고 위젯 불러오기

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Column(
              children: [
                const HeartQuizLogo(size: 80), // 분리한 로고 위젯 사용
                const SizedBox(height: 24),
                const Text(
                  'Heart Quiz',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
                const Text(
                  '서로를 더 깊이 알아가는 시간',
                  style: TextStyle(fontSize: 14, color: Color(0xFF886364)),
                ),
                const SizedBox(height: 48),

                // 공통 위젯 사용: 코드가 매우 간결해짐
                const AuthTextField(
                  label: '이메일',
                  hint: 'example@email.com',
                  icon: Icons.mail_outline,
                ),
                const SizedBox(height: 16),
                const AuthTextField(
                  label: '비밀번호',
                  hint: '••••••••',
                  icon: Icons.lock_outline,
                  isPassword: true,
                ),

                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {},
                    child: const Text(
                      '비밀번호를 잊으셨나요?',
                      style: TextStyle(color: Colors.grey, fontSize: 13),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // 공통 버튼 사용
                PrimaryButton(
                  text: '로그인',
                  onPressed: () {
                    // pushReplacementNamed를 사용하여 홈 화면으로 이동합니다.
                    // 이렇게 하면 로그인을 한 뒤 '뒤로가기'를 눌러도 다시 로그인창이 나오지 않아요.
                    Navigator.pushReplacementNamed(context, '/home');
                  },
                ),

                const SizedBox(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      '계정이 없으신가요?',
                      style: TextStyle(color: Colors.grey),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pushNamed(context, '/signup'),
                      child: const Text(
                        '회원가입',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
