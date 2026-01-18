import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user_model.dart';

/// 인증 관련 API 호출을 담당하는 서비스 클래스
/// 백엔드와의 실제 HTTP 통신을 처리합니다.
class AuthService {
  // 백엔드 주소 (에뮬레이터 사용 시 10.0.2.2 사용 권장)
  final String baseUrl = 'http://172.16.96.200:8080/api/auth';

  /// 회원가입 API 호출
  ///
  /// [API 엔드포인트] POST /api/auth/register
  /// [요청 바디] { "email": string, "password": string, "nickname": string }
  /// [응답 형식] { "access_token": string, "nickname": string } 또는 { "data": { ... } }
  /// [성공 코드] 200, 201
  /// [실패 시] Exception을 throw하며, error.message에 에러 메시지가 포함됩니다.
  Future<AuthResponse?> register(RegisterRequest request) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(request.toJson()),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return AuthResponse.fromJson(jsonDecode(response.body));
      } else {
        // 실패 시 에러 메시지 추출
        final errorData = jsonDecode(response.body);
        throw Exception(errorData['error']?['message'] ?? '회원가입에 실패했습니다.');
      }
    } catch (e) {
      rethrow;
    }
  }

  /// 로그인 API 호출
  ///
  /// [API 엔드포인트] POST /api/auth/login
  /// [요청 바디] { "email": string, "password": string }
  /// [응답 형식] { "access_token": string, "nickname": string } 또는 { "data": { ... } }
  /// [성공 코드] 200
  /// [실패 시] Exception을 throw하며, error.message에 에러 메시지가 포함됩니다.
  Future<AuthResponse?> login(LoginRequest request) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(request.toJson()),
      );

      if (response.statusCode == 200) {
        return AuthResponse.fromJson(jsonDecode(response.body));
      } else {
        final errorData = jsonDecode(response.body);
        throw Exception(errorData['error']?['message'] ?? '로그인에 실패했습니다.');
      }
    } catch (e) {
      rethrow;
    }
  }

  /// 사용자 프로필 조회 API 호출
  ///
  /// [API 엔드포인트] GET /api/auth/users/me
  /// [인증 헤더] Authorization: Bearer {token}
  /// [응답 형식] { "data": { "nickname": string } } 또는 { "nickname": string }
  /// [성공 코드] 200
  /// [실패 시] Exception을 throw하며, error.message에 에러 메시지가 포함됩니다.
  ///          (401 Unauthorized 등)
  Future<Map<String, dynamic>?> getUserProfile(String token) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/users/me'),
        headers: {
          'Authorization': 'Bearer $token', // Bearer 토큰 인증
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        // 401 Unauthorized 등 에러 발생 시
        final errorData = jsonDecode(response.body);
        throw Exception(errorData['error']?['message'] ?? '정보를 가져오지 못했습니다.');
      }
    } catch (e) {
      rethrow;
    }
  }
}
