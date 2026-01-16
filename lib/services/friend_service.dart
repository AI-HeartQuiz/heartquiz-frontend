import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:heartquiz/models/friend_model.dart'; // 모델 임포트

class FriendService {
  final String baseUrl = 'http://localhost:8080/api';

  // 1. 닉네임으로 유저 검색 (GET)
  Future<List<UserSearchResult>> searchUser(String nickname, String token) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/users/search?nickname=$nickname'),
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
        final errorData = jsonDecode(response.body);
        throw Exception(errorData['error']?['message'] ?? '유저 검색에 실패했습니다.');
      }
    } catch (e) {
      rethrow;
    }
  }

  // 2. 친구 추가 요청 (POST)
  Future<bool> addFriend(String nickname, String token) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/friends'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        // 서버 API 명세에 따라 'nickname' 또는 'friendNickname' 등으로 키값을 맞춰주세요.
        body: jsonEncode({'nickname': nickname}),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      } else {
        final errorData = jsonDecode(response.body);
        throw Exception(errorData['error']?['message'] ?? '친구 추가에 실패했습니다.');
      }
    } catch (e) {
      rethrow;
    }
  }

  // 3. 내 친구 목록 가져오기 (GET)
  Future<List<UserSearchResult>> getFriends(String token) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/friends'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> decodedData = jsonDecode(response.body);
        final List<dynamic> friendList = decodedData['data'];

        // 서버에서 받은 리스트 데이터를 모델 객체 리스트로 변환
        return friendList.map((json) => UserSearchResult.fromJson(json)).toList();
      } else {
        final errorData = jsonDecode(response.body);
        throw Exception(errorData['error']?['message'] ?? '친구 목록을 가져오지 못했습니다.');
      }
    } catch (e) {
      rethrow;
    }
  }
}