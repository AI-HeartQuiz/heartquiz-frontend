import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:heartquiz/widgets/friend_widgets.dart';
import 'package:heartquiz/providers/friend_provider.dart';
import 'package:heartquiz/models/friend_model.dart';

class FriendSearchScreen extends StatefulWidget {
  const FriendSearchScreen({super.key});

  @override
  State<FriendSearchScreen> createState() => _FriendSearchScreenState();
}

class _FriendSearchScreenState extends State<FriendSearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _hasSearched = false;

  // 검색 실행 함수 (서버와 통신)
  Future<void> _handleSearch(String query) async {
    // 1. 검색어가 비어있으면 초기화
    if (query.trim().isEmpty) {
      setState(() {
        _hasSearched = false;
      });
      return;
    }

    // 2. 키보드 내리기
    FocusScope.of(context).unfocus();

    setState(() {
      _hasSearched = true;
    });

    // 3. 토큰 가져오기
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('accessToken') ?? '';

    if (token.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('로그인 정보가 없습니다. 다시 로그인해주세요.')),
        );
      }
      return;
    }

    // 4. Provider를 통해 서버에 검색 요청
    if (mounted) {
      await Provider.of<FriendProvider>(
        context,
        listen: false,
      ).searchUser(query, token);
    }
  }

  @override
  void dispose() {
    _searchController.dispose(); // 컨트롤러 메모리 해제
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Provider의 상태를 지켜보다가 데이터가 바뀌면 화면을 다시 그림
    final friendProvider = Provider.of<FriendProvider>(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF6F7F7),
      body: SafeArea(
        child: Column(
          children: [
            // 상단 헤더
            FriendSearchHeader(
              title: '친구 추가',
              onBackTap: () => Navigator.pop(context),
            ),

            // 검색바 영역
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: FriendSearchBar(
                hintText: '닉네임을 입력해 주세요',
                controller: _searchController,
                onSubmitted: _handleSearch,
              ),
            ),

            // 결과 리스트 영역
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 4, bottom: 16),
                      child: Text(
                        '검색 결과',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF9CA3AF),
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),

                    // 조건별 UI 렌더링
                    Expanded(child: _buildSearchResultContent(friendProvider)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 검색 결과 내용을 그리는 위젯
  Widget _buildSearchResultContent(FriendProvider provider) {
    // 1. 로딩 중이면 로딩 표시
    if (provider.isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: Color(0xFF12C49D)),
      );
    }

    // 2. 아직 검색 안 했으면 안내 문구
    if (!_hasSearched) {
      return const Center(
        child: Text(
          '친구의 닉네임을 검색해보세요.',
          style: TextStyle(color: Colors.grey, fontSize: 14),
        ),
      );
    }

    // 3. 에러가 났으면 에러 메시지 표시
    if (provider.errorMessage != null) {
      return Center(
        child: Text(
          provider.errorMessage!,
          style: const TextStyle(color: Colors.redAccent),
        ),
      );
    }

    // 4. 검색 결과가 없으면
    if (provider.searchResults.isEmpty) {
      return const Center(
        child: Text(
          '검색 결과가 없습니다.',
          style: TextStyle(color: Colors.grey, fontSize: 14),
        ),
      );
    }

    // 5. 검색 결과가 있을 때 (리스트 뷰)
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      itemCount: provider.searchResults.length,
      itemBuilder: (context, index) {
        final UserSearchResult user = provider.searchResults[index];

        return FriendSearchResultCard(
          name: user.nickname,
          email: user.email,
          onAddTap: () {
            _addFriend(user);
          },
        );
      },
    );
  }

  // 친구 추가 버튼 눌렀을 때 실행할 함수
  Future<void> _addFriend(UserSearchResult user) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('accessToken') ?? '';

    if (!mounted) return;

    // Provider의 requestFriend 호출
    final success = await Provider.of<FriendProvider>(
      context,
      listen: false,
    ).requestFriend(user.id, token);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            success ? '${user.nickname}님이 친구로 추가되었습니다.' : '친구 추가 실패',
          ),
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }
}
