import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:heartquiz/widgets/profile_widgets.dart';
import 'package:heartquiz/widgets/home_widgets.dart';
import 'package:heartquiz/providers/auth_provider.dart';
import 'package:heartquiz/providers/friend_provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int _currentTabIndex = 2;

  @override
  void initState() {
    super.initState();
    // 화면이 켜지자마자 친구 목록을 서버에서 가져옵니다.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadFriends();
    });
  }

  Future<void> _loadFriends() async {
    final token = context.read<AuthProvider>().accessToken;
    if (token != null) {
      await context.read<FriendProvider>().fetchFriends(token);
    }
  }

  @override
  Widget build(BuildContext context) {
    // AuthProvider에서 내 정보 가져오기
    final authProvider = context.watch<AuthProvider>();
    // FriendProvider에서 친구 목록 가져오기
    final friendProvider = context.watch<FriendProvider>();

    final myFriends = friendProvider.myFriends;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            ProfileHeader(
              title: '내 정보',
              onSettingsTap: () {},
              onNotificationTap: () {},
            ),

            Expanded(
              child: RefreshIndicator(
                // 위에서 아래로 당겨서 새로고침 기능 추가
                onRefresh: _loadFriends,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          children: [
                            ProfileAvatar(
                              name: authProvider.userNickname ?? '사용자',
                              bio: '매일매일 조금씩 성장하는 중 🌱',
                              onEditTap: () {},
                            ),
                            const SizedBox(height: 24),
                            ProfileActionButton(
                              text: '내 정보 수정',
                              icon: Icons.edit_note_rounded,
                              onPressed: () {},
                            ),
                          ],
                        ),
                      ),

                      Container(height: 8, color: const Color(0xFFF6F7F7)),

                      Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              '친구 관리',
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 16),

                            FriendAddButton(
                              onPressed: () {
                                Navigator.pushNamed(context, '/friend_search');
                              },
                            ),

                            const SizedBox(height: 16),

                            // 친구 목록 표시 영역
                            if (friendProvider.isLoading)
                              const Center(child: CircularProgressIndicator())
                            else if (myFriends.isEmpty)
                              const Padding(
                                padding: EdgeInsets.symmetric(vertical: 40.0),
                                child: Center(
                                  child: Opacity(
                                    opacity: 0.4,
                                    child: Text('등록된 친구가 없습니다.', style: TextStyle(color: Colors.grey, fontSize: 14)),
                                  ),
                                ),
                              )
                            else
                            // 실제 친구 리스트 출력
                              ListView.builder(
                                shrinkWrap: true, // ScrollView 안에 있으므로 필수
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: myFriends.length,
                                itemBuilder: (context, index) {
                                  final friend = myFriends[index];
                                  return ListTile(
                                    contentPadding: EdgeInsets.zero,
                                    leading: CircleAvatar(
                                      backgroundColor: const Color(0xFF12C49D).withOpacity(0.1),
                                      child: const Icon(Icons.person, color: Color(0xFF12C49D)),
                                    ),
                                    title: Text(friend.nickname, style: const TextStyle(fontWeight: FontWeight.w600)),
                                    subtitle: Text(friend.email, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                                    trailing: const Icon(Icons.chevron_right, size: 20, color: Colors.grey),
                                    onTap: () {
                                      // 친구 상세 정보나 채팅으로 이동하는 로직 추가 가능
                                    },
                                  );
                                },
                              ),
                          ],
                        ),
                      ),
                    ],
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
          if (index == 0) Navigator.pushReplacementNamed(context, '/home');
          if (index == 1) Navigator.pushReplacementNamed(context, '/record');
          setState(() => _currentTabIndex = index);
        },
      ),
    );
  }
}