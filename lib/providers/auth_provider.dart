import 'package:flutter/material.dart';
import 'package:heartquiz/services/auth_service.dart';
import 'package:heartquiz/models/user_model.dart';

class AuthProvider with ChangeNotifier {
  // AuthService 객체를 생성하여 서버 통신을 준비합니다.
  final AuthService _authService = AuthService();

  // 내부 상태 변수들
  bool _isLoading = false;      // 로딩 중인지 여부
  String? _errorMessage;       // 에러 발생 시 메시지 저장
  String? _accessToken;        // 로그인 성공 시 받은 토큰
  String? _userNickname;       // 로그인한 사용자의 닉네임

  // 외부(Screen)에서 읽을 수 있도록 getter 제공
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String? get userNickname => _userNickname;
  bool get isAuthenticated => _accessToken != null; // 로그인 여부 확인

  // ---------------------------------------------------------
  // 회원가입 로직
  // ---------------------------------------------------------
  Future<bool> register(String email, String password, String nickname) async {
    _setLoading(true);
    _errorMessage = null;

    try {
      // 1. 요청 모델 생성
      final request = RegisterRequest(
        email: email,
        password: password,
        nickname: nickname,
      );

      // 2. 서비스 호출하여 서버에 데이터 전송
      final response = await _authService.register(request);

      if (response != null) {
        // 성공 시 응답 데이터 저장 (필요한 경우)
        _accessToken = response.accessToken;
        _userNickname = response.userNickname;
        return true;
      }
      return false;
    } catch (e) {
      // 에러 발생 시 메시지 저장 (Exception: 문구 제거)
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // ---------------------------------------------------------
  // 로그인 로직
  // ---------------------------------------------------------
  Future<bool> login(String email, String password) async {
    _setLoading(true);
    _errorMessage = null;

    try {
      // 1. 요청 모델 생성
      final request = LoginRequest(email: email, password: password);

      // 2. 서비스 호출
      final response = await _authService.login(request);

      if (response != null) {
        // 3. 성공 시 토큰과 닉네임 저장
        _accessToken = response.accessToken;
        _userNickname = response.userNickname;
        return true;
      }
      return false;
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // ---------------------------------------------------------
  // 로그아웃 로직
  // ---------------------------------------------------------
  void logout() {
    _accessToken = null;
    _userNickname = null;
    _errorMessage = null;
    notifyListeners();
  }

  // 내부적으로 로딩 상태를 변경하고 UI에 알리는 헬퍼 함수
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners(); // 이 함수가 호출되어야 화면이 다시 그려집니다.
  }
}