import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:heartquiz/models/chat_model.dart';
import 'package:heartquiz/models/report_model.dart';
import 'package:heartquiz/models/session_model.dart';

/// 퀴즈 관련 API 호출을 담당하는 서비스 클래스
/// 질문지 생성, 답변 제출, 리포트 생성 등의 백엔드와의 실제 HTTP 통신을 처리합니다.
class QuizService {
  final String baseUrl = 'http://localhost:8080/api';

  /// AI가 꼬리질문을 동적으로 생성하는 API 호출
  ///
  /// [API 엔드포인트] POST /api/quiz/followup-question
  /// [인증 헤더] Authorization: Bearer {token}
  /// [요청 바디] { "situation_text": string, "existing_qa": [{ "question": string, "answer": string }] }
  /// [응답 형식] { "data": { "question": string } } 또는 { "question": string }
  /// [성공 코드] 200, 201
  /// [실패 시] Exception을 throw하며, error.message에 에러 메시지가 포함됩니다.
  ///
  /// 초기 상황과 기존 Q/A 쌍을 기반으로 다음 꼬리질문을 생성합니다.
  Future<String?> generateFollowUpQuestion(
    String? situationText,
    List<FollowUpPair> existingPairs,
    String token,
  ) async {
    try {
      final requestBody = {
        if (situationText != null) 'situation_text': situationText,
        'existing_qa': existingPairs.map((e) => e.toJson()).toList(),
      };

      final response = await http.post(
        Uri.parse('$baseUrl/quiz/followup-question'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonData = jsonDecode(response.body);
        final question = jsonData['data']?['question'] ?? jsonData['question'];
        return question?.toString();
      } else {
        final errorData = jsonDecode(response.body);
        throw Exception(errorData['error']?['message'] ?? '꼬리질문 생성에 실패했습니다.');
      }
    } catch (e) {
      rethrow;
    }
  }

  /// A의 초기 상황 + 꼬리질문 Q/A 3쌍을 전송하여 질문지 생성
  ///
  /// [API 엔드포인트] POST /api/quiz/generate
  /// [인증 헤더] Authorization: Bearer {token}
  /// [요청 바디] {
  ///   "session_id": string,
  ///   "user_a_id": string (사용자 닉네임),
  ///   "situation_text": string,
  ///   "followup_qa": [{ "question": string, "answer": string }] (최대 3개)
  /// }
  /// [응답 형식] { "data": { "session_id": string, "questions": [string] } }
  ///            또는 { "session_id": string, "questions": [string] }
  ///            questions는 B에게 전달될 질문 5개 리스트입니다.
  /// [성공 코드] 200, 201
  /// [실패 시] Exception을 throw하며, error.message에 에러 메시지가 포함됩니다.
  ///
  /// API 3.1: 질문지 생성 요청
  Future<BQuestionsResponse?> generateQuestions(
    int sessionId,
    String userAId,
    String situationText,
    List<FollowUpPair> followUpQa,
    String token,
  ) async {
    try {
      final requestBody = {
        'session_id': sessionId,
        'user_a_id': userAId,
        'situation_text': situationText,
        'followup_qa': followUpQa.map((e) => e.toJson()).toList(),
      };

      final response = await http.post(
        Uri.parse('$baseUrl/quiz/generate'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonData = jsonDecode(response.body);
        return BQuestionsResponse.fromJson(jsonData['data'] ?? jsonData);
      } else {
        final errorData = jsonDecode(response.body);
        throw Exception(errorData['error']?['message'] ?? '질문지 생성에 실패했습니다.');
      }
    } catch (e) {
      rethrow;
    }
  }

  /// B의 답변 5개를 전송하는 API 호출
  ///
  /// [API 엔드포인트] POST /api/quiz/answers
  /// [인증 헤더] Authorization: Bearer {token}
  /// [요청 바디] {
  ///   "session_id": string,
  ///   "answers": [{ "question": string, "answer": string }] (5개)
  /// }
  /// [응답 형식] 성공 시 빈 응답 또는 { "success": true }
  /// [성공 코드] 200, 201
  /// [실패 시] Exception을 throw하며, error.message에 에러 메시지가 포함됩니다.
  ///
  /// API 3.3: B의 답변 제출
  Future<bool> submitBAnswers(
    int sessionId,
    List<BAnswer> answers,
    String token,
  ) async {
    try {
      final requestBody = {
        'session_id': sessionId,
        'answers': answers.map((e) => e.toJson()).toList(),
      };

      final response = await http.post(
        Uri.parse('$baseUrl/quiz/answers'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      } else {
        final errorData = jsonDecode(response.body);
        throw Exception(errorData['error']?['message'] ?? '답변 제출에 실패했습니다.');
      }
    } catch (e) {
      rethrow;
    }
  }

  /// 리포트 생성 요청 API 호출
  ///
  /// [API 엔드포인트] GET /api/quiz/report?session_id={sessionId}
  /// [인증 헤더] Authorization: Bearer {token}
  /// [쿼리 파라미터] session_id: 세션 ID
  /// [응답 형식] { "data": { ... } } 또는 ReportModel 형식의 JSON 객체
  ///            ReportModel은 aThought, bThought, mediationTitle, aDetailForB,
  ///            bDetailForA, conversationTips, partnerNickname 등을 포함합니다.
  /// [성공 코드] 200
  /// [실패 시] Exception을 throw하며, error.message에 에러 메시지가 포함됩니다.
  ///
  /// API 3.4: 리포트 생성
  Future<ReportModel?> generateReport(int sessionId, String token) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/quiz/report?session_id=$sessionId'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        final reportData = jsonData['data'] ?? jsonData;
        return ReportModel.fromJson(reportData);
      } else {
        final errorData = jsonDecode(response.body);
        throw Exception(errorData['error']?['message'] ?? '리포트 생성에 실패했습니다.');
      }
    } catch (e) {
      rethrow;
    }
  }

  /// B가 받을 질문 목록 조회 API 호출 (세션 ID로)
  ///
  /// [API 엔드포인트] GET /api/quiz/questions?session_id={sessionId}
  /// [인증 헤더] Authorization: Bearer {token}
  /// [쿼리 파라미터] session_id: 세션 ID
  /// [응답 형식] { "data": { "session_id": string, "questions": [string] } }
  ///            또는 { "session_id": string, "questions": [string] }
  ///            questions는 B가 답변할 질문 5개 리스트입니다.
  /// [성공 코드] 200
  /// [실패 시] Exception을 throw하며, error.message에 에러 메시지가 포함됩니다.
  ///
  /// API 3.2: B의 질문 목록 조회
  Future<BQuestionsResponse?> getBQuestions(int sessionId, String token) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/quiz/questions?session_id=$sessionId'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        return BQuestionsResponse.fromJson(jsonData['data'] ?? jsonData);
      } else {
        final errorData = jsonDecode(response.body);
        throw Exception(errorData['error']?['message'] ?? '질문 목록 조회에 실패했습니다.');
      }
    } catch (e) {
      rethrow;
    }
  }

  /// 질문지를 친구에게 전송하는 API 호출
  ///
  /// [API 엔드포인트] POST /api/quiz/send
  /// [인증 헤더] Authorization: Bearer {token}
  /// [요청 바디] {
  ///   "session_id": string,
  ///   "friend_id": string (받을 사람(B)의 사용자 ID)
  /// }
  /// [응답 형식] 성공 시 빈 응답 또는 { "success": true }
  /// [성공 코드] 200, 201
  /// [실패 시] Exception을 throw하며, error.message에 에러 메시지가 포함됩니다.
  ///
  /// 세션 ID와 받을 사람(B)의 사용자 ID를 전송합니다.
  Future<bool> sendQuestionsToFriend(
    int sessionId,
    int friendId,
    String token,
  ) async {
    try {
      final requestBody = {'session_id': sessionId, 'friend_id': friendId};

      final response = await http.post(
        Uri.parse('$baseUrl/quiz/send'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      } else {
        final errorData = jsonDecode(response.body);
        throw Exception(errorData['error']?['message'] ?? '질문지 전송에 실패했습니다.');
      }
    } catch (e) {
      rethrow;
    }
  }

  /// A의 퀴즈 세션 목록 조회 API 호출
  ///
  /// [API 엔드포인트] GET /api/quiz/sessions
  /// [인증 헤더] Authorization: Bearer {token}
  /// [응답 형식] { "data": { "sessions": [{ ... }] } } 또는 { "sessions": [{ ... }] }
  ///            각 세션 객체는 QuizSessionItem 형식을 따르며,
  ///            session_id, partner_nickname, status ('ongoing' 또는 'completed'),
  ///            created_at, updated_at 등을 포함합니다.
  /// [성공 코드] 200
  /// [실패 시] Exception을 throw하며, error.message에 에러 메시지가 포함됩니다.
  ///
  /// 홈 화면에서 "진행 중인 대화" 목록을 가져올 때 사용됩니다.
  Future<List<QuizSessionItem>> getQuizSessions(String token) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/quiz/sessions'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        final sessionsData =
            jsonData['data']?['sessions'] ?? jsonData['sessions'] ?? [];
        return (sessionsData as List)
            .map((json) => QuizSessionItem.fromJson(json))
            .toList();
      } else {
        final errorData = jsonDecode(response.body);
        throw Exception(errorData['error']?['message'] ?? '세션 목록 조회에 실패했습니다.');
      }
    } catch (e) {
      rethrow;
    }
  }
}
