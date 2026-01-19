import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:heartquiz/widgets/chat_widgets.dart';
import 'package:heartquiz/providers/chat_session_provider.dart';
import 'package:heartquiz/providers/auth_provider.dart';

/// B가 질문 5개에 답변하는 화면 (챗봇 UI)
class BAnswerScreen extends StatefulWidget {
  final String sessionId;
  final List<String> questions;

  const BAnswerScreen({
    super.key,
    required this.sessionId,
    required this.questions,
  });

  @override
  State<BAnswerScreen> createState() => _BAnswerScreenState();
}

class _BAnswerScreenState extends State<BAnswerScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, dynamic>> _messages = [];
  int _currentQuestionIndex = 0;
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    // Provider에 세션 ID와 질문 설정
    final chatProvider = context.read<ChatSessionProvider>();
    chatProvider.setSessionId(widget.sessionId);
    chatProvider.setBQuestions(widget.questions);

    // 첫 번째 질문을 메시지에 추가
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.questions.isNotEmpty) {
        setState(() {
          _messages.add({"isAi": true, "text": widget.questions[0]});
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _sendMessage() {
    final chatProvider = context.read<ChatSessionProvider>();
    if (_controller.text.trim().isEmpty ||
        _isProcessing ||
        chatProvider.isLoading) {
      return;
    }

    final userMessage = _controller.text.trim();

    // 사용자 메시지 추가
    setState(() {
      _messages.add({"isAi": false, "text": userMessage});
      _isProcessing = true;
    });
    _controller.clear();

    // 현재 질문에 대한 답변 저장
    chatProvider.setBAnswer(_currentQuestionIndex, userMessage);

    // 다음 질문이 있는지 확인
    if (_currentQuestionIndex < widget.questions.length - 1) {
      // 다음 질문 표시
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) {
          setState(() {
            _currentQuestionIndex++;
            _messages.add({
              "isAi": true,
              "text": widget.questions[_currentQuestionIndex],
            });
            _isProcessing = false;
          });
        }
      });
    } else {
      // 모든 질문에 답변 완료
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) {
          setState(() {
            _messages.add({
              "isAi": true,
              "text": "모든 질문에 답변해주셔서 감사합니다! 이제 분석 결과를 확인해보세요.",
              "actionText": "분석 결과보기",
            });
            _isProcessing = false;
          });
        }
      });
    }
  }

  Future<void> _submitAnswers() async {
    final chatProvider = context.read<ChatSessionProvider>();
    final authProvider = context.read<AuthProvider>();
    final token = authProvider.accessToken;

    if (token == null) {
      _showError('로그인이 필요합니다.');
      return;
    }

    final success = await chatProvider.submitBAnswers(token);

    if (success && mounted) {
      // 리포트 생성 화면으로 이동
      Navigator.pushReplacementNamed(context, '/report');
    } else if (mounted) {
      _showError(chatProvider.errorMessage ?? '답변 제출에 실패했습니다.');
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
    // 메시지 리스트를 위한 메시지 데이터 준비 (onActionTap 포함)
    final messagesWithActions = _messages.map((msg) {
      final Map<String, dynamic> messageWithAction = Map.from(msg);
      if (msg['isAi'] && msg['actionText'] != null) {
        messageWithAction['onActionTap'] = _submitAnswers;
      }
      return messageWithAction;
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF6F8F8),
      appBar: ChatAppBar(
        title: widget.questions.isNotEmpty
            ? '질문 ${_currentQuestionIndex + 1}/${widget.questions.length}'
            : '질문 답변',
      ),
      body: Column(
        children: [
          Expanded(child: ChatMessageList(messages: messagesWithActions)),
          Consumer<ChatSessionProvider>(
            builder: (context, chatProvider, child) => ChatBottomBar(
              controller: _controller,
              onSend: _sendMessage,
              isLoading: chatProvider.isLoading,
              showInput: !chatProvider.isLoading,
            ),
          ),
        ],
      ),
    );
  }
}
