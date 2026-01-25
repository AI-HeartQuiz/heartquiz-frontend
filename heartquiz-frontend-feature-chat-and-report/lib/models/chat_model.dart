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

class QuestionItem {
  final int id; // 백엔드 questionId
  final String text; // 질문 텍스트

  QuestionItem({required this.id, required this.text});

  factory QuestionItem.fromJson(Map<String, dynamic> json) {
    return QuestionItem(
      // 백엔드가 주는 키값(questionId, id 등)을 안전하게 파싱
      id: json['questionId'] ?? json['question_id'] ?? json['id'] ?? 0,
      text: json['text'] ?? '',
    );
  }
}

/// API 3.2 응답: B가 답할 질문 리스트 모델
class BQuestionsResponse {
  final String sessionId;
  final List<QuestionItem> questions;

  BQuestionsResponse({required this.sessionId, required this.questions});

  factory BQuestionsResponse.fromJson(Map<String, dynamic> json) {
    return BQuestionsResponse(
      sessionId: json['session_id']?.toString() ?? '',
      // [수정] 객체 리스트로 변환
      questions:
          (json['questions'] as List?)
              ?.map((q) => QuestionItem.fromJson(q))
              .toList() ??
          [],
    );
  }
}

/// B의 질문에 대한 답변 모델
class BAnswer {
  final int questionId; // [수정] 질문 텍스트 대신 '질문 ID'를 저장
  final String text; // [수정] 백엔드 DTO 이름인 'text'로 변경 (기존 answer)
  final String role; // [추가] 백엔드가 요구하는 역할 값 ('B')

  BAnswer({
    required this.questionId,
    required this.text,
    this.role = 'B', // 기본값 B로 고정
  });

  // [핵심] 백엔드 AnswerDtos.SubmitAnswerRequest와 키 이름이 100% 일치해야 함
  Map<String, dynamic> toJson() => {
    'questionId': questionId,
    'text': text,
    'role': role,
  };

  factory BAnswer.fromJson(Map<String, dynamic> json) {
    return BAnswer(
      questionId: json['questionId'] ?? 0,
      text: json['text'] ?? '',
      role: json['role'] ?? 'B',
    );
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
