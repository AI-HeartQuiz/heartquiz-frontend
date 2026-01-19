/// AI와 주고받는 질문-답변 쌍 모델
class FollowUpPair {
  final String question;
  final String answer;

  FollowUpPair({required this.question, required this.answer});

  Map<String, dynamic> toJson() => {'question': question, 'answer': answer};

  factory FollowUpPair.fromJson(Map<String, dynamic> json) {
    return FollowUpPair(question: json['question'], answer: json['answer']);
  }
}

/// AI 세션 상태를 관리하는 모델
class AiChatSession {
  final String sessionId;
  final String userAId;
  final String situationText;
  final List<FollowUpPair> followupQa;

  AiChatSession({
    required this.sessionId,
    required this.userAId,
    required this.situationText,
    this.followupQa = const [],
  });

  // API 전송을 위한 헬퍼 메서드
  Map<String, dynamic> toJson() => {
    'session_id': sessionId,
    'user_a_id': userAId,
    'situation_text': situationText,
    'followup_qa': followupQa.map((e) => e.toJson()).toList(),
  };
}

/// API 3.2 응답: B가 답할 질문 리스트 모델
class BQuestionsResponse {
  final String sessionId;
  final List<String> questions;

  BQuestionsResponse({required this.sessionId, required this.questions});

  factory BQuestionsResponse.fromJson(Map<String, dynamic> json) {
    return BQuestionsResponse(
      sessionId: json['session_id'],
      questions: List<String>.from(json['questions']),
    );
  }
}

/// B의 질문에 대한 답변 모델
class BAnswer {
  final String question;
  final String answer;

  BAnswer({required this.question, required this.answer});

  Map<String, dynamic> toJson() => {'question': question, 'answer': answer};

  factory BAnswer.fromJson(Map<String, dynamic> json) {
    return BAnswer(question: json['question'], answer: json['answer']);
  }
}

/// B의 모든 답변을 담는 모델
class BAnswersRequest {
  final String sessionId;
  final List<BAnswer> answers;

  BAnswersRequest({required this.sessionId, required this.answers});

  Map<String, dynamic> toJson() => {
    'session_id': sessionId,
    'answers': answers.map((e) => e.toJson()).toList(),
  };
}
