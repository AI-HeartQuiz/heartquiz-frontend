import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:heartquiz/widgets/home_widgets.dart';
import 'package:heartquiz/providers/auth_provider.dart';

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
    // 화면이 로드될 때 유저 정보를 가져옵니다. (HTML의 DOMContentLoaded와 동일)
    // WidgetsBinding을 사용하는 이유는 빌드 직후에 함수를 실행하기 위함입니다.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadUserInfo();
    });
  }

  Future<void> _loadUserInfo() async {
    final authProvider = context.read<AuthProvider>();

    // 서버에서 닉네임 정보를 가져옵니다.
    final success = await authProvider.fetchUserProfile();

    // 만약 토큰이 만료되었거나 에러가 발생했다면 로그인 화면으로 보냅니다.
    if (!success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(authProvider.errorMessage ?? '다시 로그인 해주세요.'))
      );
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Provider에서 실시간으로 닉네임을 감시합니다.
    final userNickname = context.watch<AuthProvider>().userNickname ?? "사용자";

    return Scaffold(
      backgroundColor: const Color(0xFFF6F8F8),
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 서버에서 가져온 닉네임을 헤더에 넘겨줍니다.
                HomeHeader(
                  userName: userNickname,
                  hasNotification: true,
                  onNotificationTap: () {},
                ),

                Expanded(
                  child: SingleChildScrollView(
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