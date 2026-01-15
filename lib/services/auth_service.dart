import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user_model.dart';

class AuthService {
  // 백엔드 주소 (에뮬레이터 사용 시 10.0.2.2 사용 권장)
  final String baseUrl = 'http://localhost:8080/api/auth';

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
}