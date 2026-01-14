import 'package:flutter/material.dart';
import 'package:heartquiz/widgets/auth_widgets.dart'; // 공통 위젯 불러오기

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          '회원가입',
          style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '계정 정보를\n입력해주세요',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Heart Quiz에서 사용할 계정 정보를 설정합니다.',
                      style: TextStyle(fontSize: 15, color: Color(0xFF886364)),
                    ),
                    const SizedBox(height: 40),

                    // 공통 위젯들 나열
                    const AuthTextField(
                      label: '이메일',
                      hint: 'example@email.com',
                    ),
                    const SizedBox(height: 20),
                    const AuthTextField(
                      label: '비밀번호',
                      hint: '8자 이상 입력해주세요',
                      isPassword: true,
                    ),
                    const SizedBox(height: 20),
                    const AuthTextField(
                      label: '비밀번호 확인',
                      hint: '비밀번호를 한번 더 입력해주세요',
                      isPassword: true,
                    ),
                    const SizedBox(height: 20),
                    const AuthTextField(label: '닉네임', hint: '사용하실 닉네임을 입력해주세요'),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: PrimaryButton(
                text: '가입 완료',
                onPressed: () {
                  Navigator.pushNamed(context, '/welcome');
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
