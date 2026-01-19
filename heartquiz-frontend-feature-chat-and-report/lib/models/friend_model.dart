// 1. 유저 검색 결과 및 친구 목록용 모델
class UserSearchResult {
  final int id;
  final String email;
  final String nickname;

  UserSearchResult({
    required this.id,
    required this.email,
    required this.nickname,
  });

  // (1) 친구 검색 결과 (auth/search)
  factory UserSearchResult.fromJson(Map<String, dynamic> json) {
    return UserSearchResult(
      id: json['id'] ?? json['userId'] ?? 0,
      email: json['email'] ?? '',
      nickname: json['nickname'] ?? '',
    );
  }

  // (2) 친구 목록 (api/friends) - ★ 백엔드가 보내주는 이름에 맞춤
  factory UserSearchResult.fromBackendResponse(Map<String, dynamic> json) {
    return UserSearchResult(
      // id가 없으면 userId도 찾아보고, 그래도 없으면 0
      // 이렇게 하면 서버가 뭐라고 보내든 ID를 찾아냅니다.
      id: json['friendUserid'] ?? 0,
      email: json['friendemail'] ?? '',
      nickname: json['friendnickname'] ?? '',
    );
  }
}

// 2. 받은 친구 요청용 모델
class FriendRequestModel {
  final int friendshipId;
  final String senderNickname;

  FriendRequestModel({
    required this.friendshipId,
    required this.senderNickname,
  });

  factory FriendRequestModel.fromJson(Map<String, dynamic> json) {
    return FriendRequestModel(
      friendshipId: json['friendshipId'] ?? 0,
      // ★ 백엔드 DTO의 변수명(senderNickname)과 똑같이 써야 함
      senderNickname: json['senderNickname'] ?? '알 수 없음',
    );
  }
}
