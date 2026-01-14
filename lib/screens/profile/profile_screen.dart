import 'package:flutter/material.dart';
import 'package:heartquiz/widgets/profile_widgets.dart';
import 'package:heartquiz/widgets/home_widgets.dart'; // 기존 하단바 위젯 사용

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // 하단 탭 인덱스 (내 정보는 2번으로 설정)
  int _currentTabIndex = 2;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // [위젯] 상단 헤더
            ProfileHeader(
              title: '내 정보',
              onSettingsTap: () {},
              onNotificationTap: () {},
            ),

            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // 프로필 섹션
                    Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        children: [
                          // [위젯] 아바타 및 이름
                          ProfileAvatar(
                            name: '지민',
                            bio: '매일매일 조금씩 성장하는 중 🌱',
                            onEditTap: () {},
                          ),
                          const SizedBox(height: 24),
                          // [위젯] 내 정보 수정 버튼
                          ProfileActionButton(
                            text: '내 정보 수정',
                            icon: Icons.edit_note_rounded,
                            onPressed: () {},
                          ),
                        ],
                      ),
                    ),

                    // 구분선 (HTML의 h-2 bg-background-light)
                    Container(height: 8, color: const Color(0xFFF6F7F7)),

                    // 친구 관리 섹션
                    Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            '친구 관리',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),

                          // [수정된 부분] 새로운 친구 추가 버튼 클릭 시 이동
                          FriendAddButton(
                            onPressed: () {
                              // Navigator를 사용하여 친구 검색 화면으로 이동
                              Navigator.pushNamed(context, '/friend_search');
                            },
                          ),

                          // 빈 상태 메시지
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 40.0),
                            child: Center(
                              child: Opacity(
                                opacity: 0.4,
                                child: Text(
                                  '등록된 친구가 없습니다.',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      // [기존 위젯] 하단 네비게이션 바
      bottomNavigationBar: HomeBottomNavBar(
        currentIndex: _currentTabIndex,
        onTap: (index) {
          setState(() => _currentTabIndex = index);
          if (index == 0) Navigator.pushReplacementNamed(context, '/home');
          // '분석' 탭은 아직 구현 전이므로 유지
        },
      ),
    );
  }
}
