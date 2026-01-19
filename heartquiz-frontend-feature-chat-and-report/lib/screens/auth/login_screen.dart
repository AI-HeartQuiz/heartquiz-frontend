import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:heartquiz/widgets/auth_widgets.dart';
import 'package:heartquiz/widgets/app_logo.dart';
import 'package:heartquiz/providers/auth_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // 사용자의 입력을 관리할 컨트롤러
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // HTML의 checkLogin() 기능을 담당하는 함수
  Future<void> _handleLogin() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    // 1. 간단한 유효성 검사 (HTML의 alert 역할)
    if (email.isEmpty) {
      _showError('이메일을 입력해주세요!');
      return;
    }
    if (password.isEmpty) {
      _showError('비밀번호를 입력해주세요!');
      return;
    }

    // 2. AuthProvider를 통한 로그인 시도
    final authProvider = context.read<AuthProvider>();
    final success = await authProvider.login(email, password);

    if (success) {
      // 로그인 성공 시 홈 화면으로 이동
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/home');
      }
    } else {
      // 로그인 실패 시 에러 메시지 표시
      if (mounted) {
        _showError(authProvider.errorMessage ?? '로그인에 실패했습니다.');
      }
    }
  }

  // 에러 메시지를 보여주는 유틸리티 함수
  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.redAccent,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // 로딩 상태 감시
    final isLoading = context.watch<AuthProvider>().isLoading;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Column(
              children: [
                const HeartQuizLogo(size: 80),
                const SizedBox(height: 24),
                const Text(
                  'HeartQuiz',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
                const Text(
                  '서로를 더 깊이 알아가는 시간',
                  style: TextStyle(fontSize: 14, color: Color(0xFF886364)),
                ),
                const SizedBox(height: 48),

                // 컨트롤러 연결
                AuthTextField(
                  label: '이메일',
                  hint: 'example@email.com',
                  icon: Icons.mail_outline,
                  controller: _emailController,
                ),
                const SizedBox(height: 16),
                AuthTextField(
                  label: '비밀번호',
                  hint: '••••••••',
                  icon: Icons.lock_outline,
                  isPassword: true,
                  controller: _passwordController,
                ),

                // Align(
                //   alignment: Alignment.centerRight,
                //   child: TextButton(
                //     onPressed: () {
                //       // 비밀번호 찾기 로직 (필요 시 구현)
                //     },
                //     child: const Text(
                //       '비밀번호를 잊으셨나요?',
                //       style: TextStyle(color: Colors.grey, fontSize: 13),
                //     ),
                //   ),
                // ),
                // const SizedBox(height: 24),

                // 로딩 상태 반영
                PrimaryButton(
                  text: '로그인',
                  isLoading: isLoading,
                  onPressed: _handleLogin,
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
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF12C49D),
                        ),
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
