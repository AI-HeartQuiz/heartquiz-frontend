import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:heartquiz/providers/friend_provider.dart';
import 'package:heartquiz/providers/auth_provider.dart';
import 'package:heartquiz/providers/chat_session_provider.dart';
import 'package:heartquiz/models/friend_model.dart';

class FriendSelectScreen extends StatefulWidget {
  const FriendSelectScreen({super.key});

  @override
  State<FriendSelectScreen> createState() => _FriendSelectScreenState();
}

class _FriendSelectScreenState extends State<FriendSelectScreen> {
  int? _selectedFriendId;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // "화면 먼저 다 그리고 나서(Build 후에)" 데이터 불러오기
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadFriends();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadFriends() async {
    final friendProvider = context.read<FriendProvider>();
    final authProvider = context.read<AuthProvider>();
    final token = authProvider.accessToken;

    if (token != null) {
      await friendProvider.fetchAllFriendData(token);
    }
  }

  Future<void> _sendQuestions() async {
    if (_selectedFriendId == null) {
      _showError('친구를 선택해주세요.');
      return;
    }

    final chatProvider = context.read<ChatSessionProvider>();
    final authProvider = context.read<AuthProvider>();
    final friendProvider = context.read<FriendProvider>();
    final token = authProvider.accessToken;

    if (token == null) {
      _showError('로그인이 필요합니다.');
      return;
    }

    // 선택된 친구의 닉네임 찾기
    final selectedFriend = friendProvider.myFriends.firstWhere(
      (friend) => friend.id == _selectedFriendId,
      orElse: () => UserSearchResult(id: 0, email: '', nickname: '친구'),
    );

    final success = await chatProvider.sendQuestionsToFriend(
      _selectedFriendId!,
      token,
    );

    if (success && mounted) {
      Navigator.pushNamed(
        context,
        '/send_complete',
        arguments: selectedFriend.nickname,
      );
    } else if (mounted) {
      _showError(chatProvider.errorMessage ?? '질문지 전송에 실패했습니다.');
    }
  }

  void _showError(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message), backgroundColor: Colors.redAccent),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF12C49D);
    const Color bgColor = Color(0xFFF6F8F8);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.chevron_left,
            color: Color(0xFF181111),
            size: 30,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          '친구 선택',
          style: TextStyle(
            color: Color(0xFF181111),
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        // 우측 여백을 맞추기 위한 더미 위젯
        actions: const [SizedBox(width: 48)],
      ),
      body: Column(
        children: [
          // 1. 검색바 영역
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFE2E8F0)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.03),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: TextField(
                controller: _searchController,
                onChanged: (value) {
                  // 검색 기능은 추후 구현 가능
                  setState(() {});
                },
                decoration: const InputDecoration(
                  hintText: '이름으로 검색',
                  hintStyle: TextStyle(color: Color(0xFF94A3B8), fontSize: 14),
                  prefixIcon: Icon(
                    Icons.search,
                    color: Color(0xFF94A3B8),
                    size: 20,
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 15),
                ),
              ),
            ),
          ),

          // 2. 친구 목록 영역
          Expanded(
            child: Consumer<FriendProvider>(
              builder: (context, friendProvider, child) {
                if (friendProvider.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                final friends = friendProvider.myFriends;
                final searchText = _searchController.text.toLowerCase();
                final filteredFriends = searchText.isEmpty
                    ? friends
                    : friends
                          .where(
                            (friend) =>
                                friend.nickname.toLowerCase().contains(
                                  searchText,
                                ) ||
                                friend.email.toLowerCase().contains(searchText),
                          )
                          .toList();

                if (filteredFriends.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(40.0),
                      child: Text(
                        searchText.isEmpty ? '친구 목록이 비어있습니다.' : '검색 결과가 없습니다.',
                        style: const TextStyle(
                          color: Color(0xFF94A3B8),
                          fontSize: 14,
                        ),
                      ),
                    ),
                  );
                }

                return ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 4, bottom: 12),
                      child: Text(
                        '내 친구 목록',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF64748B),
                        ),
                      ),
                    ),
                    ...filteredFriends
                        .map((friend) => _buildFriendItem(friend, primaryColor))
                        .toList(),
                  ],
                );
              },
            ),
          ),
        ],
      ),
      // 3. 하단 고정 버튼 (그라데이션 느낌의 여백 포함)
      bottomNavigationBar: Container(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          top: 10,
          bottom: MediaQuery.of(context).padding.bottom + 16,
        ),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [bgColor.withOpacity(0.0), bgColor],
          ),
        ),
        child: Consumer<ChatSessionProvider>(
          builder: (context, chatProvider, child) => ElevatedButton(
            onPressed: chatProvider.isLoading ? null : _sendQuestions,
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 56),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 8,
              shadowColor: primaryColor.withOpacity(0.4),
            ),
            child: chatProvider.isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '질문 보내기',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 8),
                      Icon(Icons.send, size: 20),
                    ],
                  ),
          ),
        ),
      ),
    );
  }

  // 각 친구 항목 카드 위젯
  Widget _buildFriendItem(UserSearchResult friend, Color primaryColor) {
    bool isSelected = _selectedFriendId == friend.id;
    // 닉네임 첫 글자로 아이콘 색상 결정
    final colorIndex = friend.nickname.codeUnits.fold(0, (a, b) => a + b) % 7;
    final colors = [
      Colors.blue,
      Colors.orange,
      Colors.purple,
      Colors.green,
      Colors.pink,
      Colors.teal,
      Colors.indigo,
    ];
    final iconColor = colors[colorIndex];
    final backgroundColor = iconColor.shade100;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedFriendId = friend.id;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? primaryColor.withOpacity(0.4)
                : const Color(0xFFF1F5F9),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [
            if (isSelected)
              BoxShadow(
                color: primaryColor.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              )
            else
              BoxShadow(
                color: Colors.black.withOpacity(0.02),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
          ],
        ),
        child: Row(
          children: [
            // 아바타
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: backgroundColor,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.person, color: iconColor, size: 28),
            ),
            const SizedBox(width: 16),
            // 정보 (이름, 이메일)
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    friend.nickname,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    friend.email,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF64748B),
                    ),
                  ),
                ],
              ),
            ),
            // 커스텀 라디오 버튼 (체크 표시)
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: isSelected ? primaryColor : Colors.transparent,
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? primaryColor : const Color(0xFFCBD5E1),
                  width: 2,
                ),
              ),
              child: isSelected
                  ? const Icon(Icons.check, color: Colors.white, size: 16)
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
//   void _showSuccessSnackBar(BuildContext context) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: const Text('질문지가 성공적으로 전송되었습니다!'),
//         backgroundColor: const Color(0xFF12C49D),
//         behavior: SnackBarBehavior.floating,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//       ),
//     );
//     // 홈 화면으로 돌아가는 로직 등을 추가할 수 있습니다.
//   }
// }