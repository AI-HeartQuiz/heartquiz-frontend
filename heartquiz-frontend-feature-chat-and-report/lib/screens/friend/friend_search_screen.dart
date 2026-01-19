import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart'; // 토큰 꺼내기용
import 'package:heartquiz/widgets/friend_widgets.dart';
import 'package:heartquiz/widgets/home_widgets.dart';
import 'package:heartquiz/providers/friend_provider.dart';
import 'package:heartquiz/models/friend_model.dart'; // UserSearchResult 모델 사용

class FriendSearchScreen extends StatefulWidget {
  const FriendSearchScreen({super.key});

  @override
  State<FriendSearchScreen> createState() => _FriendSearchScreenState();
}

class _FriendSearchScreenState extends State<FriendSearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _hasSearched = false; // 검색 시도 여부

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // ★ [핵심] 검색 실행 함수 (진짜 서버랑 통신)
  Future<void> _handleSearch(String query) async {
    // 1. 검색어가 비어있으면 초기화
    if (query.trim().isEmpty) {
      setState(() {
        _hasSearched = false;
      });
      // provider의 검색 결과도 비워주는 로직이 있다면 호출 (선택사항)
      return;
    }

    // 2. 키보드 내리기
    FocusScope.of(context).unfocus();

    setState(() {
      _hasSearched = true;
    });

    // 3. 내 폰에 저장된 토큰(Token) 꺼내기
    // (로그인할 때 SharedPreferences에 'accessToken'으로 저장했다고 가정)
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

    // 4. Provider를 불러서 서버에 검색 요청!
    if (mounted) {
      // listen: false는 함수 안에서 Provider를 부를 때 필수입니다.
      await Provider.of<FriendProvider>(
        context,
        listen: false,
      ).searchUser(query, token);
    }
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
                onSubmitted: _handleSearch, // 엔터 치면 _handleSearch 실행
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
                    Expanded(
                      // friendProvider를 넘겨줘서 상태에 따라 화면을 그림
                      child: _buildSearchResultContent(friendProvider),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      // 하단 네비게이션 바
      bottomNavigationBar: HomeBottomNavBar(
        currentIndex: 2,
        onTap: (index) {
          if (index == 0) {
            Navigator.pushReplacementNamed(context, '/home');
          } else if (index == 2) {
            Navigator.pop(context);
          }
        },
      ),
    );
  }

  // 검색 결과 내용을 그리는 위젯
  Widget _buildSearchResultContent(FriendProvider provider) {
    // 1. 로딩 중이면 뺑글이 표시
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

    // 5. ★ [성공] 진짜 데이터(List<UserSearchResult>)를 리스트로 보여줌
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      itemCount: provider.searchResults.length,
      itemBuilder: (context, index) {
        // Map['name']이 아니라 객체의 속성(.nickname)을 사용합니다
        final UserSearchResult user = provider.searchResults[index];

        return FriendSearchResultCard(
          name: user.nickname, // 서버에서 받은 닉네임
          email: user.email, // 서버에서 받은 이메일
          onAddTap: () {
            // 여기에 친구 추가 로직 연결
            _addFriend(user);
          },
        );
      },
    );
  }

  // 친구 추가 버튼 눌렀을 때 실행할 함수
  Future<void> _addFriend(UserSearchResult user) async {
    print("지금 추가하려는 친구의 ID는? : ${user.id}");
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('accessToken') ?? '';

    if (!mounted) return;
    // Provider의 addFriend 호출
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
