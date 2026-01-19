import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:heartquiz/widgets/profile_widgets.dart';
import 'package:heartquiz/widgets/home_widgets.dart';
import 'package:heartquiz/widgets/friend_widgets.dart'; // ★ FriendRequestItem 쓰려면 필수
import 'package:heartquiz/providers/auth_provider.dart';
import 'package:heartquiz/providers/friend_provider.dart';
import 'package:shared_preferences/shared_preferences.dart'; // 맨 위에 이거 임포트 필수!

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
    // 화면 켜지면 친구 목록 + 요청 목록 모두 가져오기
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadAllData();
    });
  }

  // 데이터 새로고침 함수
  Future<void> _loadAllData() async {
    // 1. Provider에 토큰이 있는지 확인
    String? token = context.read<AuthProvider>().accessToken;

    // 2. 만약 없다면? 내 폰 저장소(SharedPreferences)에서 직접 꺼내오기!
    if (token == null || token.isEmpty) {
      final prefs = await SharedPreferences.getInstance();
      token = prefs.getString('accessToken');
    }

    // 3. 토큰이 확보되었으면 데이터 가져오기 실행
    if (token != null && token.isNotEmpty) {
      // 친구 목록과 요청 목록을 한방에 가져오는 함수 호출
      if (mounted) {
        await context.read<FriendProvider>().fetchAllFriendData(token);
      }
    } else {
      print("토큰이 없어서 친구 목록을 못 가져왔어요 ㅠㅠ");
    }
  }

  // 친구 수락 버튼 눌렀을 때
  Future<void> _handleAccept(int friendshipId) async {
    final token = context.read<AuthProvider>().accessToken;
    if (token == null) return;

    // 수락 API 호출
    await context.read<FriendProvider>().acceptRequest(friendshipId, token);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('친구 요청을 수락했습니다!'),
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 1),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final friendProvider = context.watch<FriendProvider>();

    final myFriends = friendProvider.myFriends;
    final pendingRequests = friendProvider.pendingRequests; // 받은 요청 목록

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // 상단 헤더
            ProfileHeader(
              title: '내 정보',
              onSettingsTap: () {},
              onNotificationTap: () {},
            ),

            Expanded(
              child: RefreshIndicator(
                onRefresh: _loadAllData,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Column(
                    children: [
                      // 1. 프로필 정보 카드 영역
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

                      // 구분선
                      Container(height: 8, color: const Color(0xFFF6F7F7)),

                      // 2. 친구 관리 영역 (여기에 요청 + 목록 다 넣음)
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

                            FriendAddButton(
                              onPressed: () {
                                Navigator.pushNamed(
                                  context,
                                  '/friend_search',
                                ).then((_) => _loadAllData()); // 돌아왔을 때 새로고침
                              },
                            ),

                            const SizedBox(height: 24),

                            // 로딩 중일 때
                            if (friendProvider.isLoading)
                              const Center(child: CircularProgressIndicator())
                            else ...[
                              // ★ [여기!] 받은 친구 요청이 있으면 먼저 보여줌
                              if (pendingRequests.isNotEmpty) ...[
                                Row(
                                  children: [
                                    const Text(
                                      '받은 요청',
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFFF97316),
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 6,
                                        vertical: 2,
                                      ),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFF97316),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Text(
                                        '${pendingRequests.length}',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: pendingRequests.length,
                                  itemBuilder: (context, index) {
                                    final req = pendingRequests[index];
                                    return FriendRequestItem(
                                      nickname: req.senderNickname,
                                      onAccept: () =>
                                          _handleAccept(req.friendshipId),
                                    );
                                  },
                                ),
                                const SizedBox(height: 20), // 친구 목록과 간격 띄우기
                              ],

                              // ★ 내 친구 목록
                              Text(
                                '내 친구 (${myFriends.length})',
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey,
                                ),
                              ),
                              const SizedBox(height: 10),

                              if (myFriends.isEmpty)
                                const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 20.0),
                                  child: Center(
                                    child: Text(
                                      '등록된 친구가 없습니다.',
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                  ),
                                )
                              else
                                ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: myFriends.length,
                                  itemBuilder: (context, index) {
                                    final friend = myFriends[index];
                                    return ListTile(
                                      contentPadding: EdgeInsets.zero,
                                      leading: CircleAvatar(
                                        backgroundColor: const Color(
                                          0xFF12C49D,
                                        ).withOpacity(0.1),
                                        child: const Icon(
                                          Icons.person,
                                          color: Color(0xFF12C49D),
                                        ),
                                      ),
                                      title: Text(
                                        friend.nickname,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      subtitle: Text(
                                        friend.email,
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                            ],
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
