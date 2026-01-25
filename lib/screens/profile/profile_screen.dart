import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:heartquiz/widgets/profile_widgets.dart';
import 'package:heartquiz/widgets/home_widgets.dart';
import 'package:heartquiz/widgets/friend_widgets.dart';
import 'package:heartquiz/providers/auth_provider.dart';
import 'package:heartquiz/providers/friend_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    // AuthProvider에서 내 정보 가져오기
    final authProvider = context.watch<AuthProvider>();
    // FriendProvider에서 친구 목록 가져오기
    final friendProvider = context.watch<FriendProvider>();

    final myFriends = friendProvider.myFriends;
    final pendingRequests = friendProvider.pendingRequests; // 받은 요청 목록

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            ProfileHeader(title: '내 정보', onSettingsTap: () {}),

            Expanded(
              child: RefreshIndicator(
                // 위에서 아래로 당겨서 새로고침 기능 추가
                onRefresh: _loadAllData,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          children: [
                            ProfileAvatar(
                              name: authProvider.nickname ?? '사용자',
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

                      // 2. 친구 관리 영역
                      Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  '친구 관리',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                TextButton.icon(
                                  onPressed: () {
                                    Navigator.pushNamed(
                                      context,
                                      '/friend_search',
                                    ).then((_) => _loadAllData());
                                  },
                                  icon: const Icon(Icons.add, size: 18),
                                  label: const Text('추가'),
                                  style: TextButton.styleFrom(
                                    foregroundColor: const Color(0xFF12C49D),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 8,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 24),

                            // 로딩 중일 때 표시
                            if (friendProvider.isLoading)
                              const Center(child: CircularProgressIndicator())
                            else ...[
                              // ★ [섹션 1] 받은 친구 요청
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
                                const SizedBox(height: 20),
                              ],

                              // ★ [섹션 2] 내 친구 목록
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
                                    final colorIndex =
                                        friend.nickname.codeUnits.fold(
                                          0,
                                          (a, b) => a + b,
                                        ) %
                                        7;
                                    final colors = [
                                      const Color(0xFFE8F5E9),
                                      const Color(0xFFE3F2FD),
                                      const Color(0xFFF3E5F5),
                                      const Color(0xFFFFE0B2),
                                      const Color(0xFFE0F2F1),
                                      const Color(0xFFE1F5FE),
                                      const Color(0xFFEDE7F6),
                                    ];
                                    final iconColors = [
                                      const Color(0xFF12C49D).withOpacity(0.6),
                                      Colors.blue.shade300,
                                      Colors.purple.shade300,
                                      Colors.orange.shade300,
                                      Colors.teal.shade300,
                                      Colors.cyan.shade300,
                                      Colors.indigo.shade300,
                                    ];

                                    return ListTile(
                                      contentPadding: EdgeInsets.zero,
                                      leading: Container(
                                        width: 40,
                                        height: 40,
                                        decoration: BoxDecoration(
                                          color: colors[colorIndex],
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: Colors.white,
                                            width: 2,
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withOpacity(
                                                0.05,
                                              ),
                                              blurRadius: 10,
                                              offset: const Offset(0, 4),
                                            ),
                                          ],
                                        ),
                                        child: Icon(
                                          Icons.person,
                                          color: iconColors[colorIndex],
                                          size: 24,
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
                                      trailing: const Icon(
                                        Icons.chevron_right,
                                        size: 20,
                                        color: Colors.grey,
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
