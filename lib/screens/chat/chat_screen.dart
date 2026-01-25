import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:heartquiz/widgets/chat_widgets.dart';
import 'package:heartquiz/providers/chat_session_provider.dart';
import 'package:heartquiz/providers/auth_provider.dart';
import 'package:heartquiz/models/chat_model.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, dynamic>> _messages = [
    {"isAi": true, "text": "무슨 일이 있으셨나요? 그 때의 상황과 감정을 설명해주세요."},
  ];

  String? _currentFollowUpQuestion; // 현재 AI가 생성한 꼬리질문

  @override
  void initState() {
    super.initState();
    // 화면 진입 시 세션 초기화
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final chatProvider = context.read<ChatSessionProvider>();
      chatProvider.reset();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// 질문지 생성 함수
  Future<void> _generateQuestions() async {
    final authProvider = context.read<AuthProvider>();
    final token = authProvider.accessToken;

    if (token == null) {
      _showError('로그인이 필요합니다.');
      return;
    }

    // 즉시 로딩 화면으로 이동 (API 호출은 로딩 화면에서 수행)
    if (mounted) {
      Navigator.pushNamed(context, '/question_loading');
    }
  }

  void _showError(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message), backgroundColor: Colors.redAccent),
      );
    }
  }

  void _sendMessage() async {
    final chatProvider = context.read<ChatSessionProvider>();
    final authProvider = context.read<AuthProvider>();

    if (_controller.text.trim().isEmpty || chatProvider.isLoading) {
      return;
    }

    final token = authProvider.accessToken;
    if (token == null) {
      _showError('로그인이 필요합니다.');
      return;
    }

    final userMessage = _controller.text.trim();

    // 사용자 메시지 추가
    setState(() {
      _messages.add({"isAi": false, "text": userMessage});
    });
    _controller.clear();

    // 초기 상황인지 확인
    if (chatProvider.situationText == null) {
      // 첫 번째 메시지는 초기 상황으로 저장
      chatProvider.setSituationText(userMessage);

      // AI가 첫 번째 꼬리질문 생성
      await _generateNextFollowUpQuestion();
    } else {
      // 꼬리질문에 대한 답변 처리
      if (_currentFollowUpQuestion != null) {
        final followUpPair = FollowUpPair(
          question: _currentFollowUpQuestion!,
          answer: userMessage,
        );

        // 꼬리질문 Q/A 쌍 저장
        chatProvider.addFollowUpPair(followUpPair);
      }

      // 다음 꼬리질문이 필요한지 확인 (최대 3개)
      if (chatProvider.followUpPairs.length < 3) {
        // 다음 꼬리질문 생성
        await _generateNextFollowUpQuestion();
      } else {
        // 모든 꼬리질문이 완료됨 (3개)
        Future.delayed(const Duration(milliseconds: 800), () {
          if (mounted) {
            setState(() {
              _messages.add({
                "isAi": true,
                "text":
                    "진솔한 이야기 덕분에 대화의 핵심을 이해하게 되었어요. 이제 상대방에게 보낼 질문지를 생성해볼까요?",
                "actionText": "질문 생성하기",
              });
              _currentFollowUpQuestion = null;
            });
          }
        });
      }
    }
  }

  /// AI가 다음 꼬리질문을 생성하는 함수
  Future<void> _generateNextFollowUpQuestion() async {
    final chatProvider = context.read<ChatSessionProvider>();
    final authProvider = context.read<AuthProvider>();
    final token = authProvider.accessToken;

    if (token == null) {
      _showError('로그인이 필요합니다.');
      return;
    }

    final question = await chatProvider.generateFollowUpQuestion(token);

    if (question != null && mounted) {
      setState(() {
        _messages.add({"isAi": true, "text": question});
        _currentFollowUpQuestion = question;
      });
    } else if (mounted) {
      _showError(chatProvider.errorMessage ?? '꼬리질문 생성에 실패했습니다.');
    }
  }

  @override
  Widget build(BuildContext context) {
    // 메시지 리스트를 위한 메시지 데이터 준비 (onActionTap 포함)
    final messagesWithActions = _messages.map((msg) {
      final Map<String, dynamic> messageWithAction = Map.from(msg);
      if (msg['isAi'] && msg['actionText'] != null) {
        messageWithAction['onActionTap'] = _generateQuestions;
      }
      return messageWithAction;
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF6F8F8),
      appBar: const ChatAppBar(title: 'Chat with AI'),
      body: Column(
        children: [
          Expanded(child: ChatMessageList(messages: messagesWithActions)),
          Consumer<ChatSessionProvider>(
            builder: (context, chatProvider, child) => ChatBottomBar(
              controller: _controller,
              onSend: _sendMessage,
              isLoading: chatProvider.isLoading,
            ),
          ),
        ],
      ),
    );
  }
}
