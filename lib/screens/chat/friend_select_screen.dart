import 'package:flutter/material.dart';

class FriendSelectScreen extends StatefulWidget {
  const FriendSelectScreen({super.key});

  @override
  State<FriendSelectScreen> createState() => _FriendSelectScreenState();
}

class _FriendSelectScreenState extends State<FriendSelectScreen> {
  // 현재 선택된 친구의 ID (기본값으로 '민수' 선택)
  String _selectedFriendId = "minsoo@heartquiz.com";

  // 가상 친구 데이터 목록
  final List<Map<String, dynamic>> _friends = [
    {
      "name": "민수",
      "email": "minsoo@heartquiz.com",
      "icon": Icons.face_6,
      "color": Colors.blue.shade100,
      "iconColor": Colors.blue,
    },
    {
      "name": "지수",
      "email": "jisu@heartquiz.com",
      "icon": Icons.face_3,
      "color": Colors.orange.shade100,
      "iconColor": Colors.orange,
    },
    {
      "name": "희진",
      "email": "heejin@heartquiz.com",
      "icon": Icons.face_4,
      "color": Colors.purple.shade100,
      "iconColor": Colors.purple,
    },
  ];

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
              Icons.chevron_left, color: Color(0xFF181111), size: 30),
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
              child: const TextField(
                decoration: InputDecoration(
                  hintText: '이름으로 검색',
                  hintStyle: TextStyle(color: Color(0xFF94A3B8), fontSize: 14),
                  prefixIcon: Icon(
                      Icons.search, color: Color(0xFF94A3B8), size: 20),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 15),
                ),
              ),
            ),
          ),

          // 2. 친구 목록 영역
          Expanded(
            child: ListView(
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
                ..._friends.map((friend) =>
                    _buildFriendItem(friend, primaryColor)).toList(),
              ],
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
          bottom: MediaQuery
              .of(context)
              .padding
              .bottom + 16,
        ),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              bgColor.withOpacity(0.0),
              bgColor,
            ],
          ),
        ),
        child: ElevatedButton(
          onPressed: () {
            Navigator.pushNamed(context, '/send_complete');
            // 질문 전송 로직 실행
            //_showSuccessSnackBar(context);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryColor,
            foregroundColor: Colors.white,
            minimumSize: const Size(double.infinity, 56),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16)),
            elevation: 8,
            shadowColor: primaryColor.withOpacity(0.4),
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('질문 보내기',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(width: 8),
              Icon(Icons.send, size: 20),
            ],
          ),
        ),
      ),
    );
  }

  // 각 친구 항목 카드 위젯
  Widget _buildFriendItem(Map<String, dynamic> friend, Color primaryColor) {
    bool isSelected = _selectedFriendId == friend['email'];

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedFriendId = friend['email'];
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
            color: isSelected ? primaryColor.withOpacity(0.4) : const Color(
                0xFFF1F5F9),
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
                color: friend['color'],
                shape: BoxShape.circle,
              ),
              child: Icon(friend['icon'], color: friend['iconColor'], size: 28),
            ),
            const SizedBox(width: 16),
            // 정보 (이름, 이메일)
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    friend['name'],
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    friend['email'],
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