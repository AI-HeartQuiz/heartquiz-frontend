import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:heartquiz/widgets/notification_widgets.dart';
import 'package:heartquiz/models/notification_model.dart';
import 'package:heartquiz/providers/notification_provider.dart';
import 'package:heartquiz/providers/auth_provider.dart';
import 'package:heartquiz/providers/chat_session_provider.dart';
import 'package:heartquiz/screens/chat/b_answer_screen.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  Future<void> _loadNotifications() async {
    final notificationProvider = context.read<NotificationProvider>();
    final authProvider = context.read<AuthProvider>();
    final token = authProvider.accessToken;

    if (token != null) {
      await notificationProvider.fetchNotifications(token);
    }
  }

  Future<void> _handleNotificationTap(NotificationModel notification) async {
    final notificationProvider = context.read<NotificationProvider>();
    final authProvider = context.read<AuthProvider>();
    final chatProvider = context.read<ChatSessionProvider>();
    final token = authProvider.accessToken;

    if (token == null) return;

    // sessionId가 없으면 처리 불가
    if (notification.sessionId == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('세션 정보가 없습니다.'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
      return;
    }

    // 알림 읽음 처리
    if (!notification.isRead) {
      await notificationProvider.markAsRead(notification.id, token);
    }

    // 1. 세션 정보 최신으로 가져오기
    final sessionInfo = await chatProvider.fetchSessionInfo(
      notification.sessionId!,
      token,
    );

    if (sessionInfo == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '세션 정보를 불러오는데 실패했습니다: ${chatProvider.errorMessage ?? '알 수 없는 오류'}',
            ),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
      return;
    }

    // 2. 상태에 따라 화면 이동 분기
    if (sessionInfo.status == 'COMPLETED') {
      // 이미 완료된 세션 -> 리포트 화면으로 이동
      chatProvider.setSessionId(notification.sessionId!);
      final report = await chatProvider.generateReport(token);

      if (report != null && mounted) {
        Navigator.pushNamed(context, '/report');
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '리포트를 불러오는데 실패했습니다: ${chatProvider.errorMessage ?? '알 수 없는 오류'}',
            ),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    } else if (sessionInfo.status == 'QUESTIONS_READY' ||
        sessionInfo.status == 'ONGOING') {
      // 답변 대기 중 또는 진행 중 -> 답변 화면으로 이동
      final questionsResponse = await chatProvider.getBQuestions(
        notification.sessionId!,
        token,
      );

      if (questionsResponse != null && mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BAnswerScreen(
              sessionId: questionsResponse.sessionId,
              questions: questionsResponse.questions,
            ),
          ),
        );
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '질문지를 불러오는데 실패했습니다: ${chatProvider.errorMessage ?? '알 수 없는 오류'}',
            ),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    } else {
      // 기타 상태 (DRAFT 등)
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('아직 준비되지 않은 세션입니다. (상태: ${sessionInfo.status})'),
            backgroundColor: Colors.orange,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8F8),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF6F8F8),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.chevron_left,
            color: Color(0xFF181111),
            size: 28,
          ),
          onPressed: () => Navigator.pop(context),
          padding: EdgeInsets.zero,
        ),
        title: const Text(
          '알림',
          style: TextStyle(
            color: Color(0xFF181111),
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Consumer<NotificationProvider>(
        builder: (context, notificationProvider, child) {
          if (notificationProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (notificationProvider.errorMessage != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Colors.red.shade300,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    notificationProvider.errorMessage!,
                    style: TextStyle(color: Colors.red.shade600, fontSize: 14),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _loadNotifications,
                    child: const Text('다시 시도'),
                  ),
                ],
              ),
            );
          }

          if (notificationProvider.notifications.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.notifications_none,
                    size: 64,
                    color: Colors.grey.shade300,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '알림이 없습니다',
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: _loadNotifications,
            child: ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: notificationProvider.notifications.length,
              itemBuilder: (context, index) {
                final notification = notificationProvider.notifications[index];
                return NotificationCard(
                  notification: notification,
                  onTap: () => _handleNotificationTap(notification),
                );
              },
            ),
          );
        },
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey.shade100)),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildNavItem(Icons.home, '홈', () {
                Navigator.pushReplacementNamed(context, '/home');
              }),
              _buildNavItem(Icons.history, '기록', () {
                Navigator.pushReplacementNamed(context, '/record');
              }),
              _buildNavItem(Icons.person, '내 정보', () {
                Navigator.pushReplacementNamed(context, '/profile');
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 64,
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.grey.shade400, size: 24),
            const SizedBox(height: 1),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w500,
                color: Colors.grey.shade400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
