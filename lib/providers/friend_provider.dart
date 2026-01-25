import 'package:flutter/material.dart';
import 'package:heartquiz/services/friend_service.dart';
import 'package:heartquiz/models/friend_model.dart';

class FriendProvider with ChangeNotifier {
  final FriendService _friendService = FriendService();

  List<UserSearchResult> _searchResults = [];
  List<UserSearchResult> _myFriends = []; // 진짜 친구 목록
  List<FriendRequestModel> _pendingRequests = []; // 받은 요청 목록

  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  List<UserSearchResult> get searchResults => _searchResults;
  List<UserSearchResult> get myFriends => _myFriends;
  List<FriendRequestModel> get pendingRequests => _pendingRequests;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // 1. 유저 검색
  Future<void> searchUser(String nickname, String token) async {
    _isLoading = true;
    notifyListeners();
    try {
      _searchResults = await _friendService.searchUser(nickname, token);
    } catch (e) {
      _searchResults = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // 2. 친구 추가 요청 보내기
  Future<bool> requestFriend(int friendUserId, String token) async {
    try {
      final success = await _friendService.requestFriend(friendUserId, token);
      return success;
    } catch (e) {
      return false;
    }
  }

  // 3. 내 친구 목록 + 요청 목록 한 번에 가져오기
  Future<void> fetchAllFriendData(String token) async {
    _isLoading = true;
    notifyListeners();
    try {
      // 두 가지 요청을 동시에 보냄
      final results = await Future.wait([
        _friendService.getFriends(token),
        _friendService.getPendingRequests(token),
      ]);

      _myFriends = results[0] as List<UserSearchResult>;
      _pendingRequests = results[1] as List<FriendRequestModel>;
    } catch (e) {
      print("친구 데이터 로드 실패: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // 4. 친구 요청 수락
  Future<void> acceptRequest(int friendshipId, String token) async {
    final success = await _friendService.acceptFriend(friendshipId, token);
    if (success) {
      // 수락 성공하면 목록 다시 불러오기
      await fetchAllFriendData(token);
    }
  }
}