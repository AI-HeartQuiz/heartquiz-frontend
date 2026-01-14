class UserModel {
  final int id;
  final String email;
  final String nickname;

  UserModel({required this.id, required this.email, required this.nickname});

  // JSON 데이터를 Dart 객체로 변환하는 생성자
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      email: json['email'],
      nickname: json['nickname'],
    );
  }
}