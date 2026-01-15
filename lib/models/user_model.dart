// 회원가입 요청 시 보낼 데이터 모델
class RegisterRequest {
  final String email;
  final String password;
  final String nickname;

  RegisterRequest({
    required this.email,
    required this.password,
    required this.nickname,
  });
  //toJson() : 플러터의 객체는 바로 서버로 갈 수 없기 때문에 JSON(Map) 형태로 변환해주는 역할을 함
  Map<String, dynamic> toJson() => {
    'email': email,
    'password': password,
    'nickname': nickname,
  };
}

// 회원가입 성공 시 받을 응답 모델
class AuthResponse {
  final String accessToken;
  final String userNickname;

  AuthResponse({
    required this.accessToken,
    required this.userNickname,
  });
  //factory AuthResponse.fromJson() : 서버가 준 복잡한 JSON 데이터를 우리가 쓰기 편한 Dart 객체로 조립해주는 역할
  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      accessToken: json['data']['accessToken'],
      userNickname: json['data']['userNickname'],
    );
  }
}

// 로그인 요청 시 보낼 데이터 모델
class LoginRequest {
  final String email;
  final String password;

  LoginRequest({
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toJson() => {
    'email': email,
    'password': password,
  };
}