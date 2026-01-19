import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:heartquiz/widgets/auth_widgets.dart';
import 'package:heartquiz/providers/auth_provider.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  // 1. 컨트롤러 정의: 각 입력창(TextField)에 써진 글자들을 읽어오기 위한 도구들입니다.
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _nicknameController = TextEditingController();

  // 2. 에러 상태 정의: 입력값이 규칙에 맞지 않을 때 화면에 보여줄 경고 문구를 저장합니다.
  String? _emailError;
  String? _passwordError;
  String? _confirmPasswordError;
  String? _nicknameError;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _nicknameController.dispose();
    super.dispose();
  }

  // ---------------------------------------------------------
  // 유효성 검사 로직 (Validation Functions)
  // ---------------------------------------------------------

  // 이메일 검사
  void _validateEmail(String value) {
    setState(() {
      if (value.isEmpty) {
        _emailError = "이메일을 입력해주세요.";
      } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
        _emailError = "올바른 이메일 형식이 아닙니다.";
      } else {
        _emailError = null;
      }
    });
  }

  // 비밀번호 검사: 8자 이상인지 확인
  void _validatePassword(String value) {
    setState(() {
      if (value.isEmpty) {
        _passwordError = "비밀번호를 입력해주세요.";
      } else if (value.length < 8) {
        _passwordError = "8자 이상 입력해주세요.";
      } else {
        _passwordError = null;
      }

      // [수정] 확인 칸에 이미 무언가 입력되어 있는 상태에서만 일치 여부를 실시간으로 체크합니다.
      // 이렇게 하면 처음 비밀번호를 입력할 때 확인 칸이 미리 빨개지는 것을 방지할 수 있습니다.
      if (_confirmPasswordController.text.isNotEmpty) {
        _validateConfirmPassword(_confirmPasswordController.text);
      }
    });
  }

  // 비밀번호 확인 검사: 비밀번호 입력창에 쓴 글자와 똑같은지 비교
  void _validateConfirmPassword(String value) {
    setState(() {
      if (value.isEmpty) {
        // [수정] 입력하는 도중 지워서 비워졌을 때는 에러를 보여주지 않거나,
        // 필요한 경우에만 에러를 띄웁니다. 여기서는 비어있으면 에러를 지워줍니다.
        _confirmPasswordError = null;
      } else if (value != _passwordController.text) {
        _confirmPasswordError = "비밀번호가 일치하지 않습니다.";
      } else {
        _confirmPasswordError = null;
      }
    });
  }

  // 닉네임 검사: 비어있지만 않으면 통과
  void _validateNickname(String value) {
    setState(() {
      if (value.trim().isEmpty) {
        _nicknameError = "닉네임을 입력해주세요.";
      } else {
        _nicknameError = null;
      }
    });
  }

  // 4. 게이트키퍼(Getter): 모든 입력창이 규칙에 맞고 값이 채워졌을 때 true
  bool get _isFormValid {
    return _emailError == null &&
        _passwordError == null &&
        _confirmPasswordError == null &&
        _nicknameError == null &&
        _emailController.text.isNotEmpty &&
        _passwordController.text.isNotEmpty &&
        _confirmPasswordController.text.isNotEmpty && // 확인 칸도 비어있으면 안 됨
        _nicknameController.text.isNotEmpty;
  }

  // 5. 가입 실행 함수
  Future<void> _handleSignUp() async {
    if (!_isFormValid) return;

    final nickname = _nicknameController.text; // 사용자가 쓴 닉네임 저장
    final authProvider = context.read<AuthProvider>();
    // 여기서 실제 API 호출이 일어납니다!
    final success = await authProvider.register(
      _emailController.text,
      _passwordController.text,
      nickname,
    );

    if (success) {
      if (mounted) {
        // 가입 성공 시 nickname을 arguments로 실어서 보냅니다.
        Navigator.pushReplacementNamed(
          context,
          '/welcome',
          arguments: nickname,
        );
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(authProvider.errorMessage ?? '가입 실패'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = context.watch<AuthProvider>().isLoading;

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

                    AuthTextField(
                      label: '이메일',
                      hint: 'example@email.com',
                      controller: _emailController,
                      errorText: _emailError,
                      onChanged: _validateEmail,
                      icon: Icons.email_outlined,
                    ),
                    const SizedBox(height: 20),
                    AuthTextField(
                      label: '비밀번호',
                      hint: '8자 이상 입력해주세요',
                      isPassword: true,
                      controller: _passwordController,
                      errorText: _passwordError,
                      onChanged: _validatePassword,
                      icon: Icons.lock_outline,
                    ),
                    const SizedBox(height: 20),
                    AuthTextField(
                      label: '비밀번호 확인',
                      hint: '비밀번호를 한번 더 입력해주세요',
                      isPassword: true,
                      controller: _confirmPasswordController,
                      errorText: _confirmPasswordError,
                      onChanged: _validateConfirmPassword,
                      icon: Icons.lock_clock_outlined,
                    ),
                    const SizedBox(height: 20),
                    AuthTextField(
                      label: '닉네임',
                      hint: '사용하실 닉네임을 입력해주세요',
                      controller: _nicknameController,
                      errorText: _nicknameError,
                      onChanged: _validateNickname,
                      icon: Icons.person_outline,
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: PrimaryButton(
                text: '가입 완료',
                isLoading: isLoading,
                onPressed: _isFormValid ? _handleSignUp : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
