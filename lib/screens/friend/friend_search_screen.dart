import 'package:flutter/material.dart';
import 'package:heartquiz/widgets/friend_widgets.dart';

class FriendSearchScreen extends StatefulWidget {
  const FriendSearchScreen({super.key});

  @override
  State<FriendSearchScreen> createState() => _FriendSearchScreenState();
}

class _FriendSearchScreenState extends State<FriendSearchScreen> {
  final TextEditingController _searchController = TextEditingController();

  // 가상의 전체 친구 데이터베이스
  final List<Map<String, String>> _allUsers = [
    {"name": "민수", "email": "minsu@heartquiz.com"},
    {"name": "지혜", "email": "jihye@heartquiz.com"},
    {"name": "철수", "email": "chulsoo@heartquiz.com"},
  ];

  // 실제 화면에 보여줄 검색 결과 리스트
  List<Map<String, String>> _searchResults = [];
  bool _hasSearched = false;

  // 검색 실행 함수 (글자가 바뀔 때마다 혹은 엔터를 쳤을 때 실행)
  void _handleSearch(String query) {
    setState(() {
      if (query.trim().isEmpty) {
        _searchResults = [];
        _hasSearched = false; // 검색어가 없으면 '이름을 검색해보세요' 상태로 복구
      } else {
        _hasSearched = true;
        // 이름에 검색어가 포함된 유저 필터링 (대소문자 구분 없이)
        _searchResults = _allUsers
            .where((user) => user['name']!.contains(query))
            .toList();
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose(); // 컨트롤러 메모리 해제
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                onSubmitted: _handleSearch, // 키보드에서 엔터/체크 클릭 시
                //onChanged: _handleSearch,   // 타이핑할 때마다 실시간 검색
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
                    Expanded(child: _buildSearchResultContent()),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 검색 결과에 따른 내부 콘텐츠 위젯
  Widget _buildSearchResultContent() {
    // 1. 아직 검색을 시작하지 않았을 때
    if (!_hasSearched) {
      return const Center(
        child: Text(
          '친구의 이름을 검색해보세요.',
          style: TextStyle(color: Colors.grey, fontSize: 14),
        ),
      );
    }

    // 2. 검색 결과가 없을 때
    if (_searchResults.isEmpty) {
      return const Center(
        child: Text(
          '검색 결과가 없습니다.',
          style: TextStyle(color: Colors.grey, fontSize: 14),
        ),
      );
    }

    // 3. 검색 결과가 있을 때 (리스트 뷰)
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      itemCount: _searchResults.length,
      itemBuilder: (context, index) {
        final user = _searchResults[index];
        return FriendSearchResultCard(
          name: user['name']!,
          email: user['email']!,
          onAddTap: () {
            // 친구 추가 완료 메시지 띄우기
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('${user['name']}님이 친구로 추가되었습니다.'),
                behavior: SnackBarBehavior.floating,
                duration: const Duration(seconds: 2),
              ),
            );
          },
        );
      },
    );
  }
}
