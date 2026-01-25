import 'package:flutter/material.dart';
import 'package:heartquiz/services/auth_service.dart';
import 'package:heartquiz/models/user_model.dart';

/// 인증 관련 상태 관리 및 비즈니스 로직을 담당하는 Provider 클래스
/// AuthService를 통해 실제 API 호출을 수행하고, 화면(UI)에 상태 변화를 알립니다.
///
/// [관리하는 상태]
/// - _accessToken: 로그인/회원가입 시 받은 JWT 토큰
/// - _nickname: 현재 로그인한 사용자의 닉네임
/// - _isLoading: API 호출 중인지 여부
/// - _errorMessage: 에러 발생 시 에러 메시지
class AuthProvider with ChangeNotifier {
  // AuthService 객체를 생성하여 서버 통신을 준비합니다.
  final AuthService _authService = AuthService();

  // 내부 상태 변수들
  bool _isLoading = false; // 로딩 중인지 여부
  String? _errorMessage; // 에러 발생 시 메시지 저장
  String? _accessToken; // 로그인/회원가입 성공 시 받은 인증 토큰
  String? _nickname; // 현재 로그인한 사용자의 닉네임

  // 외부(Screen)에서 읽을 수 있도록 getter 제공
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String? get nickname => _nickname;
  String? get userNickname => _nickname; // 백엔드 친구 코드 호환성을 위한 별칭
  String? get accessToken => _accessToken;
  bool get isAuthenticated => _accessToken != null; // 로그인 여부 확인

  // ---------------------------------------------------------
  // 1. 내 정보 불러오기 (HTML의 myinformation 함수 역할)
  // ---------------------------------------------------------
  Future<bool> fetchUserProfile() async {
    // 토큰이 없으면 요청을 보낼 수 없으므로 바로 종료합니다.
    if (_accessToken == null) {
      _errorMessage = "인증 토큰이 없습니다. 다시 로그인해주세요.";
      return false;
    }

    _setLoading(true);
    _errorMessage = null;

    try {
      // 서비스 레이어를 통해 GET /api/users/me 호출
      final result = await _authService.getUserProfile(_accessToken!);

      if (result != null) {
        // HTML 로직 반영: 응답 구조가 { data: { nickname: ... } } 인지 { nickname: ... } 인지 확인
        // Map에서 데이터를 꺼낼 때는 result['key'] 형식을 사용합니다.
        final String nickname = result['data'] != null
            ? result['data']['nickname']
            : result['nickname'];

        _nickname = nickname;
        return true;
      }
      return false;
    } catch (e) {
      // 네트워크 오류나 401 에러 등이 발생한 경우
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // ---------------------------------------------------------
  // 2. 회원가입 로직
  // ---------------------------------------------------------
  Future<bool> register(String email, String password, String nickname) async {
    _setLoading(true);
    _errorMessage = null;

    try {
      final request = RegisterRequest(
        email: email,
        password: password,
        nickname: nickname,
      );

      final response = await _authService.register(request);

      if (response != null) {
        // 가입 성공 시 토큰과 닉네임을 즉시 저장합니다.
        _accessToken = response.accessToken;
        _nickname = response.nickname;
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
  // 3. 로그인 로직
  // ---------------------------------------------------------
  Future<bool> login(String email, String password) async {
    _setLoading(true);
    _errorMessage = null;

    try {
      final request = LoginRequest(email: email, password: password);
      final response = await _authService.login(request);

      if (response != null) {
        // 로그인 성공 시 토큰과 닉네임을 저장합니다.
        _accessToken = response.accessToken;
        _nickname = response.nickname;
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
  // 4. 로그아웃 로직
  // ---------------------------------------------------------
  void logout() {
    _accessToken = null;
    _nickname = null;
    _errorMessage = null;
    notifyListeners(); // 상태를 초기화하고 화면에 알립니다.
  }

  // 내부적으로 로딩 상태를 변경하고 UI에 알리는 헬퍼 함수
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
