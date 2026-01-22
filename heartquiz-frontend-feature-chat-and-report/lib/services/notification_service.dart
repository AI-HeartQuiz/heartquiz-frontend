import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:heartquiz/models/notification_model.dart';

/// 알림 관련 API 호출을 담당하는 서비스 클래스
/// 백엔드와의 실제 HTTP 통신을 처리합니다.
class NotificationService {
  final String baseUrl = 'http://10.0.2.2:8080/api';

  /// 알림 목록 조회 API 호출
  ///
  /// [API 엔드포인트] GET /api/notifications
  /// [인증 헤더] Authorization: Bearer {token}
  /// [응답 형식] { "data": [{ ... }] } 또는 { "notifications": [{ ... }] }
  ///            각 알림 객체는 NotificationModel 형식을 따릅니다.
  /// [성공 코드] 200
  /// [실패 시] Exception을 throw하며, error.message에 에러 메시지가 포함됩니다.
  Future<List<NotificationModel>> getNotifications(String token) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/notifications'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        final List<dynamic> notifications =
            jsonData['data'] ?? jsonData['notifications'] ?? [];
        return notifications
            .map((json) => NotificationModel.fromJson(json))
            .toList();
      } else {
        final errorData = jsonDecode(response.body);
        throw Exception(errorData['error']?['message'] ?? '알림 목록 조회에 실패했습니다.');
      }
    } catch (e) {
      rethrow;
    }
  }

  /// 알림 읽음 처리 API 호출
  ///
  /// [API 엔드포인트] PATCH /api/notifications/{notificationId}/read
  /// [인증 헤더] Authorization: Bearer {token}
  /// [경로 파라미터] notificationId: 알림 ID
  /// [응답 형식] 성공 시 빈 응답 (200 또는 204)
  /// [성공 코드] 200, 204
  /// [실패 시] Exception을 throw하며, error.message에 에러 메시지가 포함됩니다.
  Future<bool> markAsRead(String notificationId, String token) async {
    try {
      final response = await http.patch(
        Uri.parse('$baseUrl/notifications/$notificationId/read'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        return true;
      } else {
        final errorData = jsonDecode(response.body);
        throw Exception(errorData['error']?['message'] ?? '알림 읽음 처리에 실패했습니다.');
      }
    } catch (e) {
      rethrow;
    }
  }

  /// 모든 알림 읽음 처리 API 호출
  ///
  /// [API 엔드포인트] PATCH /api/notifications/read-all
  /// [인증 헤더] Authorization: Bearer {token}
  /// [응답 형식] 성공 시 빈 응답 (200 또는 204)
  /// [성공 코드] 200, 204
  /// [실패 시] Exception을 throw하며, error.message에 에러 메시지가 포함됩니다.
  Future<bool> markAllAsRead(String token) async {
    try {
      final response = await http.patch(
        Uri.parse('$baseUrl/notifications/read-all'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        return true;
      } else {
        final errorData = jsonDecode(response.body);
        throw Exception(
          errorData['error']?['message'] ?? '모든 알림 읽음 처리에 실패했습니다.',
        );
      }
    } catch (e) {
      rethrow;
    }
  }

  /// 알림 삭제 API 호출
  ///
  /// [API 엔드포인트] DELETE /api/notifications/{notificationId}
  /// [인증 헤더] Authorization: Bearer {token}
  /// [경로 파라미터] notificationId: 삭제할 알림 ID
  /// [응답 형식] 성공 시 빈 응답 (200 또는 204)
  /// [성공 코드] 200, 204
  /// [실패 시] Exception을 throw하며, error.message에 에러 메시지가 포함됩니다.
  Future<bool> deleteNotification(String notificationId, String token) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/notifications/$notificationId'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        return true;
      } else {
        final errorData = jsonDecode(response.body);
        throw Exception(errorData['error']?['message'] ?? '알림 삭제에 실패했습니다.');
      }
    } catch (e) {
      rethrow;
    }
  }
}
