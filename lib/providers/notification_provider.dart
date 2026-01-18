import 'package:flutter/material.dart';
import 'package:heartquiz/services/notification_service.dart';
import 'package:heartquiz/models/notification_model.dart';

/// 알림 관련 상태 관리 및 비즈니스 로직을 담당하는 Provider 클래스
/// NotificationService를 통해 실제 API 호출을 수행하고, 화면(UI)에 상태 변화를 알립니다.
class NotificationProvider with ChangeNotifier {
  final NotificationService _notificationService = NotificationService();

  List<NotificationModel> _notifications = [];
  bool _isLoading = false;
  String? _errorMessage;
  int _unreadCount = 0;

  List<NotificationModel> get notifications => _notifications;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  int get unreadCount => _unreadCount;
  bool get hasUnreadNotifications => _unreadCount > 0;

  /// 알림 목록 가져오기 함수
  /// 
  /// [내부 동작]
  /// 1. NotificationService가 GET /api/notifications API를 호출하여 알림 목록 조회
  /// 2. 받은 알림 목록을 _notifications에 저장
  /// 3. 읽지 않은 알림 개수를 계산하여 _unreadCount에 저장
  /// 
  /// [사용 시점] 알림 화면에서 알림 목록을 표시할 때
  Future<void> fetchNotifications(String token) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _notifications = await _notificationService.getNotifications(token);
      _unreadCount = _notifications.where((n) => !n.isRead).length;
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      _notifications = [];
      _unreadCount = 0;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// 알림 읽음 처리 함수
  /// 
  /// [내부 동작]
  /// 1. NotificationService가 PATCH /api/notifications/{notificationId}/read API를 호출
  /// 2. 성공 시 로컬 _notifications 리스트에서 해당 알림의 isRead를 true로 업데이트
  /// 3. 읽지 않은 알림 개수를 재계산하여 _unreadCount 업데이트
  /// 
  /// [사용 시점] 사용자가 알림을 클릭했을 때 자동으로 호출되어 읽음 처리
  /// 
  /// [반환값] 성공 시 true, 실패 시 false
  Future<bool> markAsRead(String notificationId, String token) async {
    try {
      final success = await _notificationService.markAsRead(notificationId, token);
      if (success) {
        final index = _notifications.indexWhere((n) => n.id == notificationId);
        if (index >= 0) {
          _notifications[index] = NotificationModel(
            id: _notifications[index].id,
            type: _notifications[index].type,
            title: _notifications[index].title,
            message: _notifications[index].message,
            senderNickname: _notifications[index].senderNickname,
            senderAvatarColor: _notifications[index].senderAvatarColor,
            createdAt: _notifications[index].createdAt,
            sessionId: _notifications[index].sessionId,
            isRead: true,
          );
          _unreadCount = _notifications.where((n) => !n.isRead).length;
          notifyListeners();
        }
      }
      return success;
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      notifyListeners();
      return false;
    }
  }

  /// 모든 알림 읽음 처리 함수
  /// 
  /// [내부 동작]
  /// 1. NotificationService가 PATCH /api/notifications/read-all API를 호출
  /// 2. 성공 시 로컬 _notifications 리스트의 모든 알림의 isRead를 true로 업데이트
  /// 3. _unreadCount를 0으로 설정
  /// 
  /// [사용 시점] 사용자가 "모두 읽음" 버튼을 클릭했을 때
  /// 
  /// [반환값] 성공 시 true, 실패 시 false
  Future<bool> markAllAsRead(String token) async {
    try {
      final success = await _notificationService.markAllAsRead(token);
      if (success) {
        _notifications = _notifications.map((n) => NotificationModel(
          id: n.id,
          type: n.type,
          title: n.title,
          message: n.message,
          senderNickname: n.senderNickname,
          senderAvatarColor: n.senderAvatarColor,
          createdAt: n.createdAt,
          sessionId: n.sessionId,
          isRead: true,
        )).toList();
        _unreadCount = 0;
        notifyListeners();
      }
      return success;
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      notifyListeners();
      return false;
    }
  }

  /// 알림 삭제 함수
  /// 
  /// [내부 동작]
  /// 1. NotificationService가 DELETE /api/notifications/{notificationId} API를 호출
  /// 2. 성공 시 로컬 _notifications 리스트에서 해당 알림을 제거
  /// 3. 읽지 않은 알림 개수를 재계산하여 _unreadCount 업데이트
  /// 
  /// [사용 시점] 사용자가 알림을 삭제할 때
  /// 
  /// [반환값] 성공 시 true, 실패 시 false
  Future<bool> deleteNotification(String notificationId, String token) async {
    try {
      final success = await _notificationService.deleteNotification(notificationId, token);
      if (success) {
        _notifications.removeWhere((n) => n.id == notificationId);
        _unreadCount = _notifications.where((n) => !n.isRead).length;
        notifyListeners();
      }
      return success;
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      notifyListeners();
      return false;
    }
  }

  /// 알림 목록 새로고침
  Future<void> refresh(String token) async {
    await fetchNotifications(token);
  }
}
