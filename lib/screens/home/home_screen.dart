import 'package:flutter/material.dart';
import 'package:heartquiz/widgets/home_widgets.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentTabIndex = 0;
  final String _userName = "지민";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8F8),
      body: SafeArea(
        child: Stack(
          children: [
            // 1. 메인 콘텐츠 스크롤 영역
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 상단 헤더
                HomeHeader(
                  userName: _userName,
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

                        // 대화 데이터가 없는 상태의 디자인
                        const EmptyStateView(),

                        // 하단 버튼과 겹치지 않도록 여백 확보
                        const SizedBox(height: 140),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            // 2. 하단 고정 CTA 버튼 (네비게이션 바 위쪽 배치)
            Positioned(
              bottom: 28, // HTML의 bottom-28 반영
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
      // 3. 하단 네비게이션 바 (홈, 분석, 내 정보)
      bottomNavigationBar: HomeBottomNavBar(
        currentIndex: _currentTabIndex,
        onTap: (index) {
          if (index == 2) {
            Navigator.pushNamed(context, '/profile');
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
