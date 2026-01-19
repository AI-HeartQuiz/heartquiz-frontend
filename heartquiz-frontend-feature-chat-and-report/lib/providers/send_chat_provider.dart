import 'package:flutter/material.dart';

/// 백엔드 및 AI 연동 상태를 관리하는 클래스입니다.
class SendChatProvider with ChangeNotifier {
  // 전송 중인지 상태를 관리합니다.
  bool _isSending = false;
  bool get isSending => _isSending;

  /// 친구에게 질문지를 전송하는 가상 로직입니다.
  /// 나중에 실제 ApiService와 연결하면 됩니다.
  Future<bool> sendToFriend(String email) async {
    _isSending = true;
    notifyListeners(); // 화면에 "로딩 중" 상태를 알립니다.

    try {
      // 백엔드 통신을 시뮬레이션하기 위해 2초간 대기합니다.
      await Future.delayed(const Duration(seconds: 2));

      // 테스트용으로 무조건 성공(true)을 반환하게 했습니다.
      // 나중에 실제 API 결과(response.statusCode == 200 등)를 반환하세요.
      return true;
    } catch (e) {
      debugPrint("전송 에러: $e");
      return false;
    } finally {
      _isSending = false;
      notifyListeners(); // 로딩이 끝났음을 화면에 알립니다.
    }
  }
}
