import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:heartquiz/widgets/home_widgets.dart';
import 'package:heartquiz/providers/auth_provider.dart';
import 'package:heartquiz/providers/chat_session_provider.dart';
import 'package:heartquiz/providers/notification_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentTabIndex = 0;

  @override
  void initState() {
    super.initState();
    // 화면이 로드될 때 유저 정보와 세션 목록, 알림을 가져옵니다.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadUserInfo();
      _loadSessions();
      _loadNotifications();
    });
  }

  Future<void> _loadUserInfo() async {
    final authProvider = context.read<AuthProvider>();

    // 서버에서 닉네임 정보를 가져옵니다.
    final success = await authProvider.fetchUserProfile();

    // 만약 토큰이 만료되었거나 에러가 발생했다면 로그인 화면으로 보냅니다.
    if (!success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(authProvider.errorMessage ?? '다시 로그인 해주세요.')),
      );
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  Future<void> _loadSessions() async {
    final chatProvider = context.read<ChatSessionProvider>();
    final authProvider = context.read<AuthProvider>();
    final token = authProvider.accessToken;

    if (token != null) {
      await chatProvider.fetchQuizSessions(token);
    }
  }

  Future<void> _loadNotifications() async {
    final notificationProvider = context.read<NotificationProvider>();
    final authProvider = context.read<AuthProvider>();
    final token = authProvider.accessToken;

    if (token != null) {
      await notificationProvider.fetchNotifications(token);
    }
  }

  Future<void> _handleSessionTap(int sessionId, bool isCompleted) async {
    if (!isCompleted) {
      // 진행 중인 세션은 아직 리포트를 볼 수 없음
      return;
    }

    final chatProvider = context.read<ChatSessionProvider>();
    final authProvider = context.read<AuthProvider>();
    final token = authProvider.accessToken;

    if (token == null) return;

    // 세션 ID를 설정하고 리포트를 생성
    chatProvider.setSessionId(sessionId.toString());
    final report = await chatProvider.generateReport(token);

    if (report != null && mounted) {
      Navigator.pushNamed(context, '/report');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Provider에서 실시간으로 닉네임을 감시합니다.
    final nickname = context.watch<AuthProvider>().nickname ?? "사용자";

    return Scaffold(
      backgroundColor: const Color(0xFFF6F8F8),
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 서버에서 가져온 닉네임을 헤더에 넘겨줍니다.
                Consumer<NotificationProvider>(
                  builder: (context, notificationProvider, child) {
                    return HomeHeader(
                      userName: nickname,
                      hasNotification:
                          notificationProvider.hasUnreadNotifications,
                      onNotificationTap: () {
                        Navigator.pushNamed(context, '/notification');
                      },
                    );
                  },
                ),

                Expanded(
                  child: Consumer<ChatSessionProvider>(
                    builder: (context, chatProvider, child) {
                      final sessions = chatProvider.quizSessions;

                      if (chatProvider.isLoading) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (sessions.isEmpty) {
                        return SingleChildScrollView(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 8),
                              const SectionTitle(title: '진행 중인 대화'),
                              const SizedBox(height: 12),
                              const EmptyStateView(),
                              const SizedBox(height: 140),
                            ],
                          ),
                        );
                      }

                      return RefreshIndicator(
                        onRefresh: _loadSessions,
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 8),
                              const SectionTitle(title: '진행 중인 대화'),
                              const SizedBox(height: 12),
                              ...sessions.map(
                                (session) => QuizSessionCard(
                                  sessionId: session.sessionId,
                                  partnerNickname: session.partnerNickname,
                                  status: session.statusKorean,
                                  onTap: () => _handleSessionTap(
                                    session.sessionId,
                                    session.isCompleted,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 140),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),

            Positioned(
              bottom: 28,
              left: 20,
              right: 20,
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 320),
                  child: FixedBottomButton(
                    text: '새 질문지 만들기',
                    onPressed: () {
                      Navigator.pushNamed(context, '/chat');
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: HomeBottomNavBar(
        currentIndex: _currentTabIndex,
        onTap: (index) {
          if (index == 1) {
            Navigator.pushReplacementNamed(context, '/record');
          } else if (index == 2) {
            Navigator.pushReplacementNamed(context, '/profile');
          } else {
            setState(() {
              _currentTabIndex = index;
            });
          }
        },
      ),
    );
  }
}
