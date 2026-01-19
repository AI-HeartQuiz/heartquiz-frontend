import 'package:flutter/material.dart';
import 'package:heartquiz/widgets/record_widgets.dart';
import 'package:heartquiz/widgets/home_widgets.dart';

class RecordScreen extends StatefulWidget {
  const RecordScreen({super.key});

  @override
  State<RecordScreen> createState() => _RecordScreenState();
}

class _RecordScreenState extends State<RecordScreen> {
  int _currentTabIndex = 1;
  String _selectedFilter = '전체';
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  // 1. 전체 데이터 리스트 (나중에 백엔드에서 받아올 데이터)
  final List<RecordItem> _allRecords = [
    RecordItem(
      name: '민수',
      status: '진행 중',
      title: '우리가 서운했던 날',
      description: '일주일 만에 만난 날의 오해와 진심',
      avatarIcon: Icons.face,
      avatarBgColor: const Color(0xFFFFECF0),
      avatarIconColor: const Color(0xFFFF85A1),
    ),
    RecordItem(
      name: '지수',
      status: '완료됨',
      title: '우리의 첫 여행 준비',
      description: '함께 떠날 제주도 여행에 대한 설렘',
      avatarIcon: Icons.face_2,
      avatarBgColor: const Color(0xFFE0F7F3),
      avatarIconColor: const Color(0xFF12C49D),
    ),
    RecordItem(
      name: '희진',
      status: '완료됨',
      title: '속마음 털어놓기',
      description: '평소에 전하지 못했던 고마운 마음들',
      avatarIcon: Icons.face_3,
      avatarBgColor: const Color(0xFFFFF9E5),
      avatarIconColor: const Color(0xFFFFD43B),
    ),
  ];

  // 2. 필터 및 검색이 적용된 결과 리스트 계산
  List<RecordItem> get _filteredRecords {
    return _allRecords.where((record) {
      // 필터 조건 확인
      bool matchesFilter = _selectedFilter == '전체' || record.status == _selectedFilter;
      // 검색 조건 확인 (이름 또는 제목에 포함되는지)
      bool matchesSearch = record.name.contains(_searchQuery) || record.title.contains(_searchQuery);

      return matchesFilter && matchesSearch;
    }).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final displayList = _filteredRecords;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        // 메인 탭바의 하나라면 보통 뒤로가기가 없어도 되지만, 필요하시다면 유지
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, color: Colors.black, size: 28),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          '기록',
          style: TextStyle(color: Colors.black, fontSize: 17, fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
            child: Column(
              children: [
                RecordSearchBar(
                  controller: _searchController,
                  onChanged: (value) {
                    setState(() => _searchQuery = value);
                  },
                ),
                const SizedBox(height: 16),
                RecordFilterTabs(
                  selectedTab: _selectedFilter,
                  onTabChanged: (tab) {
                    setState(() => _selectedFilter = tab);
                  },
                ),
              ],
            ),
          ),

          // 3. 필터링된 리스트를 보여줌
          Expanded(
            child: displayList.isEmpty
                ? const Center(child: Text('검색 결과가 없습니다.', style: TextStyle(color: Colors.grey)))
                : ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: displayList.length,
              itemBuilder: (context, index) {
                return RecordListCard(item: displayList[index]);
              },
            ),
          ),
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: FloatingActionButton(
          onPressed: () => Navigator.pushNamed(context, '/chat'),
          backgroundColor: const Color(0xFF12C49D),
          elevation: 4,
          shape: const CircleBorder(),
          child: const Icon(Icons.add, color: Colors.white, size: 32),
        ),
      ),
      bottomNavigationBar: HomeBottomNavBar(
        currentIndex: _currentTabIndex,
        onTap: (index) {
          if (index == 0) Navigator.pushReplacementNamed(context, '/home');
          if (index == 2) Navigator.pushReplacementNamed(context, '/profile');
          // 같은 화면이면 setState 안해도 되지만 구조 유지를 위해 둠
          setState(() => _currentTabIndex = index);
        },
      ),
    );
  }
}