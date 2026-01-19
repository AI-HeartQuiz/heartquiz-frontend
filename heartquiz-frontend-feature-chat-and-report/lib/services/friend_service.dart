import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:heartquiz/models/friend_model.dart';

class FriendService {
  // IP 주소는 본인 환경에 맞게 유지
  final String baseUrl = 'http://172.16.96.200:8080/api/friends';
  final String searchUrl = 'http://172.16.96.200:8080/api/auth/search';

  // 1. 유저 검색 (검색 결과에 ID가 포함되어야 함)
  Future<List<UserSearchResult>> searchUser(
    String nickname,
    String token,
  ) async {
    try {
      final response = await http.get(
        Uri.parse('$searchUrl?nickname=$nickname'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> decodedData = jsonDecode(response.body);
        final List<dynamic> userList = decodedData['data'];
        return userList.map((json) => UserSearchResult.fromJson(json)).toList();
      } else {
        throw Exception('유저 검색 실패');
      }
    } catch (e) {
      print('에러 발생: $e');
      rethrow;
    }
  }

  // 2. 친구 추가 요청 (POST /api/friends/request)
  Future<bool> requestFriend(int friendUserId, String token) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/request'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        // ★ 백엔드 DTO(FriendRequest)의 필드명인 'friendUserId'에 맞춰야 함
        body: jsonEncode({'friendUserId': friendUserId}),
      );

      return response.statusCode == 200;
    } catch (e) {
      rethrow;
    }
  }

  // 3. 내 친구 목록 조회
  Future<List<UserSearchResult>> getFriends(String token) async {
    try {
      final response = await http.get(
        Uri.parse(baseUrl),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> decodedData = jsonDecode(response.body);
        final List<dynamic> list = decodedData['data'];

        // ★ 여기가 핵심! fromJson 대신 fromBackendResponse를 써야 닉네임이 보입니다.
        return list
            .map((json) => UserSearchResult.fromBackendResponse(json))
            .toList();
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  // 4. 받은 친구 요청 목록 조회 (GET /api/friends/requests)
  Future<List<FriendRequestModel>> getPendingRequests(String token) async {
    try {
      // 1. 서버에 GET 요청을 보냅니다. "내 요청 내놔!"
      // 주소: /api/friends/get/requests (백엔드 Controller랑 일치해야 함)
      final response = await http.get(
        Uri.parse('$baseUrl/get/requests'),
        headers: {
          'Authorization': 'Bearer $token', // 내 신분증(토큰) 보여주기
          'Content-Type': 'application/json',
        },
      );

      // 2. 서버가 "OK(200)"라고 응답하면?
      if (response.statusCode == 200) {
        // 서버가 준 데이터 꾸러미(JSON)를 풉니다.
        final Map<String, dynamic> decodedData = jsonDecode(response.body);
        final List<dynamic> list = decodedData['data']; // 진짜 알맹이 데이터 리스트

        // 리스트 안에 있는 JSON 덩어리들을 하나씩 'FriendRequestModel' 객체로 변환합니다.
        return list.map((json) => FriendRequestModel.fromJson(json)).toList();
      }

      // 실패하면 빈 리스트 반환
      return [];
    } catch (e) {
      // 에러 나도 빈 리스트 반환 (앱이 죽지 않게)
      return [];
    }
  }

  // 5. 친구 요청 수락 (POST /api/friends/{friendshipId}/accept)
  Future<bool> acceptFriend(int friendshipId, String token) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/$friendshipId/accept'),
        headers: {'Authorization': 'Bearer $token'},
      );
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}
