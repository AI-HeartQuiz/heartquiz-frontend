import 'package:flutter/material.dart';
import 'package:heartquiz/services/friend_service.dart';
import 'package:heartquiz/models/friend_model.dart'; // UserSearchResult 모델 사용을 위해 임포트

class FriendProvider with ChangeNotifier {
  final FriendService _friendService = FriendService();

  // 상태 변수들
  List<UserSearchResult> _searchResults = []; // 검색 결과 리스트
  List<UserSearchResult> _myFriends = [];    // 실제 내 친구 리스트
  bool _isLoading = false;
  String? _errorMessage; // 에러 메시지 처리를 위한 변수 추가

  List<UserSearchResult> get searchResults => _searchResults;
  List<UserSearchResult> get myFriends => _myFriends;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // 1. 내 친구 목록 가져오기 함수
  // 앱 실행 시 또는 프로필 화면 진입 시 서버의 최신 목록을 가져옵니다.
  Future<void> fetchFriends(String token) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // 서비스 레이어의 getFriends 호출 (token 사용)
      _myFriends = await _friendService.getFriends(token);
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      _myFriends = []; // 실패 시 빈 리스트로 초기화
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // 2. 유저 검색 함수
  Future<void> searchUser(String nickname, String token) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _searchResults = await _friendService.searchUser(nickname, token);
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      _searchResults = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // 3. 친구 추가 함수
  Future<bool> addFriend(UserSearchResult user, String token) async {
    _errorMessage = null;
    try {
      final success = await _friendService.addFriend(user.nickname, token);

      if (success) {
        // 내 로컬 리스트에도 추가하여 즉시 화면 반영
        _myFriends.add(user);
        notifyListeners();
      }
      return success;
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      return false;
    }
  }
}