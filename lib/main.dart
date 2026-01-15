import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:heartquiz/providers/auth_provider.dart';

import 'package:heartquiz/screens/auth/landing_screen.dart';
import 'package:heartquiz/screens/auth/login_screen.dart';
import 'package:heartquiz/screens/auth/signup_screen.dart';
import 'package:heartquiz/screens/auth/welcome_screen.dart';
import 'package:heartquiz/screens/home/home_screen.dart';
import 'package:heartquiz/screens/profile/profile_screen.dart';
import 'package:heartquiz/screens/friend/friend_search_screen.dart';
import 'package:heartquiz/screens/chat/chat_screen.dart';
import 'package:heartquiz/screens/chat/friend_select_screen.dart';
import 'package:heartquiz/screens/chat/question_loading_screen.dart';
import 'package:heartquiz/screens/chat/question_send_screen.dart';
import 'package:heartquiz/screens/chat/send_complete_screen.dart';
import 'package:heartquiz/screens/report/report_screen.dart';
import 'package:heartquiz/screens/record/record_screen.dart';

void main() {
  runApp(
    // MultiProvider는 앱의 최상단에서 데이터를 공급하는 역할을 합니다.
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: const HeartQuizApp(),
    ),
  );
}

class HeartQuizApp extends StatelessWidget {
  const HeartQuizApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Heart Quiz',

      // 앱 전체 디자인 규칙 정의
      theme: ThemeData(
        // 메인 컬러: 12c49d
        primaryColor: const Color(0xFF12C49D),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF12C49D),
          primary: const Color(0xFF12C49D),
        ),

        // 폰트 설정: Pretendard (pubspec에 등록한 이름과 같아야 함)
        fontFamily: 'Pretendard',

        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF7F8FA),
      ),

      // 초기 화면
      home: const LandingScreen(),

      // 경로 등록
      routes: {
        '/login': (context) => const LoginScreen(),
        '/signup': (context) => const SignUpScreen(),
        '/welcome': (context) => const WelcomeScreen(),
        '/home': (context) => const HomeScreen(),
        '/profile': (context) => const ProfileScreen(),
        '/friend_search': (context) => const FriendSearchScreen(),
        '/chat': (context) => const ChatScreen(),
        '/question_loading': (context) => const QuestionLoadingScreen(),
        '/friend_select' : (context) => const FriendSelectScreen(),
        '/question_send' : (context) => const QuestionSendScreen(),
        '/send_complete' : (context) => const SendCompleteScreen(),
        '/report' : (context) => const ReportScreen(),
        '/record' : (context) => const RecordScreen(),
      },
    );
  }
}
