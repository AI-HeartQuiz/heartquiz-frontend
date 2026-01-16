class UserSearchResult {
  final String email;
  final String nickname;

  UserSearchResult({
    required this.email,
    required this.nickname
  });

  // 서버에서 온 JSON 데이터를 객체로 변환하는 팩토리 생성자
  factory UserSearchResult.fromJson(Map<String, dynamic> json) {
    return UserSearchResult(
      email: json['email'] ?? '',
      nickname: json['nickname'] ?? '',
    );
  }

  // 객체 데이터를 다시 JSON으로 보낼 때 (필요한 경우)
  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'nickname': nickname,
    };
  }
}