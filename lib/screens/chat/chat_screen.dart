import 'package:flutter/material.dart';
import 'package:heartquiz/widgets/chat_widgets.dart';

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

  void _sendMessage() {
    if (_controller.text.trim().isEmpty) return;

    setState(() {
      _messages.add({
        "isAi": false,
        "text": _controller.text,
        "time": "오후 2:30", // 실제 시간 로직 추가 가능
      });
      _controller.clear();
    });

    // 가상의 AI 응답 로직
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          _messages.add({
            "isAi": true,
            "text":
                "지민님의 진솔한 이야기 덕분에 대화의 핵심을 이해하게 되었어요. 이제 민수님에게 보낼 질문지를 생성해볼까요?",
            "actionText": "질문 생성하기",
          });
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8F8),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.black,
            size: 20,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Chat with AI',
          style: TextStyle(
            color: Colors.black,
            fontSize: 17,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                if (msg['isAi']) {
                  return AiMessageBubble(
                    message: msg['text'],
                    actionText: msg['actionText'],
                    onActionTap: () {
                      // 질문 생성 로직 실행
                    },
                  );
                } else {
                  return UserMessageBubble(
                    message: msg['text'],
                    time: msg['time'] ?? "",
                  );
                }
              },
            ),
          ),
          ChatInputBar(controller: _controller, onSend: _sendMessage),
        ],
      ),
    );
  }
}
