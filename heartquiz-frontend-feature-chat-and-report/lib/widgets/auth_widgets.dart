import 'package:flutter/material.dart';

// 1. 공통 텍스트 필드 디자인 (에러 메시지 및 실시간 감지 기능 추가)
class AuthTextField extends StatefulWidget {
  final String label;
  final String hint;
  final bool isPassword;
  final IconData? icon;
  final TextEditingController? controller;
  final String? errorText; // 에러 메시지를 담을 변수
  final Function(String)? onChanged; // 글자가 바뀔 때 실행할 함수

  const AuthTextField({
    super.key,
    required this.label,
    required this.hint,
    this.isPassword = false,
    this.icon,
    this.controller,
    this.errorText,
    this.onChanged,
  });

  @override
  State<AuthTextField> createState() => _AuthTextFieldState();
}

class _AuthTextFieldState extends State<AuthTextField> {
  bool _isObscured = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            widget.label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Color(0xFF181111),
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            // 에러가 있을 때 테두리를 빨간색으로 변경
            border: Border.all(
              color: widget.errorText != null
                  ? Colors.redAccent
                  : Colors.black.withOpacity(0.05),
              width: widget.errorText != null ? 1.5 : 1,
            ),
          ),
          child: TextField(
            controller: widget.controller,
            onChanged: widget.onChanged, // 실시간 입력 감지
            obscureText: widget.isPassword ? _isObscured : false,
            decoration: InputDecoration(
              hintText: widget.hint,
              hintStyle: const TextStyle(color: Colors.black26, fontSize: 15),
              prefixIcon: widget.icon != null
                  ? Icon(widget.icon, color: Colors.grey, size: 20)
                  : null,
              suffixIcon: widget.isPassword
                  ? IconButton(
                icon: Icon(
                  _isObscured
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  color: Colors.grey,
                  size: 20,
                ),
                onPressed: () => setState(() => _isObscured = !_isObscured),
              )
                  : null,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 18,
              ),
            ),
          ),
        ),
        // 에러 메시지가 있으면 텍스트 표시
        if (widget.errorText != null)
          Padding(
            padding: const EdgeInsets.only(left: 8, top: 6),
            child: Text(
              widget.errorText!,
              style: const TextStyle(color: Colors.redAccent, fontSize: 12),
            ),
          ),
      ],
    );
  }
}

// 2. 공통 하단 버튼 디자인 (로딩 상태 처리)
class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed; // 유효성 검사 실패 시 null을 전달하여 버튼 비활성화 가능
  final bool isLoading;

  const PrimaryButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 58,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF12c49d),
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          // 버튼 비활성화 시 색상
          disabledBackgroundColor: Colors.grey.shade300,
        ),
        child: isLoading
            ? const SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(
            color: Colors.white,
            strokeWidth: 2,
          ),
        )
            : Text(
          text,
          style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}