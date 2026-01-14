import 'package:flutter/material.dart';

class AuthProvider with ChangeNotifier {
  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // 로그인 로직
  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await Future.delayed(const Duration(seconds: 1)); // 백엔드 통신 시뮬레이션

      // 가짜 검증 로직 (나중에 실제 API 연동)
      if (email == "test@test.com" && password == "password123") {
        return true;
      } else {
        _errorMessage = "이메일 또는 비밀번호가 일치하지 않습니다.";
        return false;
      }
    } catch (e) {
      _errorMessage = "네트워크 오류가 발생했습니다.";
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // 회원가입 로직
  Future<bool> register(String email, String password, String nickname) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await Future.delayed(const Duration(seconds: 1));
      // 성공 가정
      return true;
    } catch (e) {
      _errorMessage = "회원가입 중 오류가 발생했습니다.";
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}