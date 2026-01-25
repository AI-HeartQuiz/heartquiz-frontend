import 'package:flutter/material.dart';
import 'package:heartquiz/models/chat_model.dart';
import 'package:heartquiz/models/report_model.dart';
import 'package:heartquiz/models/session_model.dart';
import 'package:heartquiz/services/quiz_service.dart';

/// 채팅 세션과 질문지 생성/답변 과정을 관리하는 Provider 클래스
/// QuizService를 통해 실제 API 호출을 수행하고, 화면(UI)에 상태 변화를 알립니다.
///
/// [관리하는 상태]
/// - _situationText: 사용자 A의 초기 상황 텍스트
/// - _followUpPairs: 꼬리질문 Q/A 3쌍 (최대 3개)
/// - _sessionId: 현재 퀴즈 세션 ID
/// - _bQuestions: B에게 전달될 질문 5개
/// - _bAnswers: B의 답변 5개
/// - _reportData: 생성된 리포트 데이터 (ReportModel)
/// - _quizSessions: A의 퀴즈 세션 목록 (홈 화면용)
/// - _isLoading: API 호출 중인지 여부
/// - _errorMessage: 에러 발생 시 에러 메시지
class ChatSessionProvider with ChangeNotifier {
  final QuizService _quizService = QuizService();

  // A의 초기 상황
  String? _situationText;

  // A의 꼬리질문 Q/A 3쌍
  List<FollowUpPair> _followUpPairs = [];

  // 현재 세션 ID
  String? _sessionId;

  // B에게 전달될 질문 5개
  List<QuestionItem> _bQuestions = [];

  // B의 답변들
  List<BAnswer> _bAnswers = [];

  // 리포트 데이터
  ReportModel? _reportData;

  // 퀴즈 세션 목록 (홈 화면용)
  List<QuizSessionItem> _quizSessions = [];

  // 로딩 상태
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  String? get situationText => _situationText;
  List<FollowUpPair> get followUpPairs => _followUpPairs;
  String? get sessionId => _sessionId;
  List<QuestionItem> get bQuestions => _bQuestions;
  List<BAnswer> get bAnswers => _bAnswers;
  ReportModel? get reportData => _reportData;
  List<QuizSessionItem> get quizSessions => _quizSessions;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  /// A의 초기 상황 설정
  void setSituationText(String text) {
    _situationText = text;
    notifyListeners();
  }

  /// 꼬리질문 Q/A 추가 (최대 3개)
  void addFollowUpPair(FollowUpPair pair) {
    if (_followUpPairs.length < 3) {
      _followUpPairs.add(pair);
      notifyListeners();
    }
  }

  /// 꼬리질문 Q/A 업데이트
  void updateFollowUpPair(int index, FollowUpPair pair) {
    if (index >= 0 && index < _followUpPairs.length) {
      _followUpPairs[index] = pair;
      notifyListeners();
    }
  }

  /// 꼬리질문 Q/A 삭제
  void removeFollowUpPair(int index) {
    if (index >= 0 && index < _followUpPairs.length) {
      _followUpPairs.removeAt(index);
      notifyListeners();
    }
  }

  /// 세션 ID 설정
  void setSessionId(String id) {
    // _sessionId = id; 기존 코드
    // notifyListeners();
    // 1. 값이 똑같으면 아무것도 하지 않음 (무한 루프 및 불필요한 렌더링 방지)
    if (_sessionId == id) return;

    _sessionId = id;

    // 2. 화면 빌드 충돌 방지 (Microtask로 감싸서 실행 순서를 아주 잠시 미룸)
    Future.microtask(() {
      notifyListeners();
    });
  }

  /// B에게 전달될 질문 5개 설정
  void setBQuestions(List<QuestionItem> questions) {
    // 기존 코드
    // _bQuestions = questions;
    // notifyListeners();
    _bQuestions = questions;

    Future.microtask(() {
      notifyListeners();
    });
  }

  /// B의 답변 추가/업데이트
  void setBAnswer(int questionIndex, String answer) {
    if (questionIndex >= 0 && questionIndex < _bQuestions.length) {
      final question = _bQuestions[questionIndex];

      // [추가] 질문 ID를 사용하여 답변 객체 생성
      final newAnswer = BAnswer(
        questionId: question.id, // 질문 ID 생성
        text: answer, // 답변 내용
        role: 'B', // 역할 B 고정
      );

      // 이미 답변이 있으면 업데이트, 없으면 추가
      final existingIndex = _bAnswers.indexWhere(
        (a) => a.questionId == question,
      );
      if (existingIndex >= 0) {
        _bAnswers[existingIndex] = newAnswer; // 업데이트
      } else {
        _bAnswers.add(newAnswer); // 추가
      }
      notifyListeners();
    }
  }

  /// B의 모든 답변이 완료되었는지 확인
  bool get areAllBAnswersComplete {
    return _bQuestions.length == 5 && _bAnswers.length == 5;
  }

  /// 리포트 데이터 설정
  void setReportData(ReportModel report) {
    _reportData = report;
    notifyListeners();
  }

  /// 로딩 상태 설정
  void setLoading(bool value) {
    // 1. 값이 같으면 무시 (불필요한 렌더링 방지)
    if (_isLoading == value) return;

    _isLoading = value;

    // 2. ★수정★ 화면 빌드 충돌 방지 (작업을 아주 잠시 미룸)
    Future.microtask(() {
      notifyListeners();
    });
  }

  /// 에러 메시지 설정
  void setError(String? message) {
    _errorMessage = message;
    notifyListeners();
  }

  /// AI가 다음 꼬리질문을 생성하는 함수
  ///
  /// [내부 동작]
  /// 1. 현재 저장된 초기 상황(_situationText)과 기존 Q/A 쌍(_followUpPairs)을 QuizService로 전달
  /// 2. QuizService가 POST /api/quiz/followup-question API를 호출하여 새로운 꼬리질문을 생성
  /// 3. 생성된 질문을 반환하거나, 실패 시 null과 에러 메시지를 설정
  ///
  /// [사용 시점] 사용자 A가 채팅 화면에서 초기 상황을 입력하고 꼬리질문을 받을 때
  ///
  /// [반환값] 생성된 꼬리질문 문자열, 실패 시 null
  Future<String?> generateFollowUpQuestion(String token) async {
    if (_situationText == null || token.isEmpty) {
      _errorMessage = '로그인이 필요합니다.';
      notifyListeners();
      return null;
    }

    // 1. 세션 ID가 없으면(첫 질문이면) 생성
    if (_sessionId == null) {
      // 타임스탬프 기반 ID 생성 (백엔드와 협의된 방식 사용)
      _sessionId = DateTime.now().millisecondsSinceEpoch.toString();
      notifyListeners();
    }

    setLoading(true);
    _errorMessage = null;

    try {
      // 2. 수정된 QuizService 호출 (sessionId 필수)
      final question = await _quizService.generateFollowUpQuestion(
        _sessionId!, // ✅ 수정됨: sessionid -> _sessionId!
        _situationText,
        _followUpPairs,
        token,
      );

      if (question != null) {
        setLoading(false);
        return question;
      } else {
        _errorMessage = '꼬리질문 생성에 실패했습니다.';
        setLoading(false);
        return null;
      }
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      setLoading(false);
      return null;
    }
  }

  /// 질문지 생성 함수
  ///
  /// [내부 동작]
  /// 1. 초기 상황과 꼬리질문 Q/A 3쌍이 모두 입력되었는지 검증
  /// 2. 세션 ID를 타임스탬프 기반으로 자동 생성 (또는 백엔드에서 받아올 수도 있음)
  /// 3. QuizService가 POST /api/quiz/generate API를 호출하여 질문지(5개) 생성
  /// 4. 생성된 질문 5개를 _bQuestions에 저장하고 BQuestionsResponse 반환
  ///
  /// [사용 시점] 사용자 A가 모든 꼬리질문에 답변을 완료하고 질문지를 생성할 때
  ///
  /// [반환값] BQuestionsResponse (session_id와 questions 포함), 실패 시 null
  Future<BQuestionsResponse?> generateQuestions(
    String token,
    String nickname,
  ) async {
    if (token.isEmpty) {
      _errorMessage = '로그인이 필요합니다.';
      notifyListeners();
      return null;
    }

    if (_situationText == null || _situationText!.isEmpty) {
      _errorMessage = '초기 상황을 입력해주세요.';
      notifyListeners();
      return null;
    }

    if (_followUpPairs.length < 3) {
      _errorMessage = '모든 꼬리질문에 답변해주세요.';
      notifyListeners();
      return null;
    }

    // ✅ 수정됨: 꼬리질문 때 만든 세션 ID를 그대로 사용해야 합니다.
    // 만약 세션 ID가 없다면(예외 상황) 새로 생성
    if (_sessionId == null) {
      _sessionId = DateTime.now().millisecondsSinceEpoch.toString();
      notifyListeners();
    }

    setLoading(true);
    _errorMessage = null;

    try {
      final response = await _quizService.generateQuestions(
        _sessionId!, // ✅ 수정됨: 기존 세션 ID 사용
        nickname,
        _situationText!,
        _followUpPairs,
        token,
      );

      if (response != null) {
        setSessionId(response.sessionId);
        setBQuestions(response.questions);
        setLoading(false);
        return response;
      } else {
        _errorMessage = '질문지 생성에 실패했습니다.';
        setLoading(false);
        return null;
      }
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      setLoading(false);
      return null;
    }
  }

  /// 질문지를 친구에게 전송하는 함수
  ///
  /// [내부 동작]
  /// 1. 세션 ID와 친구 이메일이 유효한지 검증
  /// 2. QuizService가 POST /api/quiz/send API를 호출하여 질문지를 친구에게 전송
  ///
  /// [사용 시점] 사용자 A가 질문지를 생성한 후 친구 선택 화면에서 전송할 때
  ///
  /// [반환값] 성공 시 true, 실패 시 false (에러 메시지는 _errorMessage에 저장됨)
  Future<bool> sendQuestionsToFriend(int friendId, String token) async {
    if (_sessionId == null) {
      _errorMessage = '질문지 세션이 없습니다. 다시 질문지를 생성해주세요.';
      notifyListeners();
      return false;
    }

    if (friendId <= 0) {
      _errorMessage = '$friendId, 친구를 선택해주세요.';
      notifyListeners();
      return false;
    }

    setLoading(true);
    _errorMessage = null;

    try {
      final success = await _quizService.sendQuestionsToFriend(
        _sessionId!,
        friendId,
        token,
      );

      setLoading(false);
      return success;
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      setLoading(false);
      return false;
    }
  }

  /// B가 받을 질문 목록 조회 함수 (세션 ID로)
  ///
  /// [내부 동작]
  /// 1. QuizService가 GET /api/quiz/questions?session_id={sessionId} API를 호출
  /// 2. 받은 질문 5개를 _bQuestions에 저장하고 세션 ID를 설정
  ///
  /// [사용 시점] 사용자 B가 알림을 통해 질문지를 받았을 때, 질문 목록을 불러올 때
  ///
  /// [반환값] BQuestionsResponse (session_id와 questions 포함), 실패 시 null
  Future<BQuestionsResponse?> getBQuestions(
    String sessionId,
    String token,
  ) async {
    if (sessionId.isEmpty || token.isEmpty) {
      _errorMessage = '로그인이 필요합니다.';
      notifyListeners();
      return null;
    }

    setLoading(true);
    _errorMessage = null;

    try {
      final response = await _quizService.getBQuestions(sessionId, token);

      if (response != null) {
        setSessionId(response.sessionId);
        setBQuestions(response.questions);
        setLoading(false);
        return response;
      } else {
        _errorMessage = '질문 목록 조회에 실패했습니다.';
        setLoading(false);
        return null;
      }
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      setLoading(false);
      return null;
    }
  }

  /// B의 답변 제출 함수
  ///
  /// [내부 동작]
  /// 1. 모든 질문에 답변이 완료되었는지 검증 (_bAnswers.length == 5)
  /// 2. QuizService가 POST /api/quiz/answers API를 호출하여 B의 답변 5개를 제출
  ///
  /// [사용 시점] 사용자 B가 질문 5개에 모두 답변을 완료하고 제출할 때
  ///
  /// [반환값] 성공 시 true, 실패 시 false (에러 메시지는 _errorMessage에 저장됨)
  Future<bool> submitBAnswers(String token) async {
    if (_sessionId == null) {
      _errorMessage = '세션 ID가 없습니다.';
      notifyListeners();
      return false;
    }

    if (!areAllBAnswersComplete) {
      _errorMessage = '모든 질문에 답변해주세요.';
      notifyListeners();
      return false;
    }

    if (token.isEmpty) {
      _errorMessage = '로그인이 필요합니다.';
      notifyListeners();
      return false;
    }

    setLoading(true);
    _errorMessage = null;

    try {
      final success = await _quizService.submitBAnswers(
        _sessionId!,
        _bAnswers,
        token,
      );

      setLoading(false);
      return success;
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      setLoading(false);
      return false;
    }
  }

  /// 리포트 생성 요청 함수
  ///
  /// [내부 동작]
  /// 1. 세션 ID가 설정되어 있는지 검증
  /// 2. QuizService가 GET /api/quiz/report?session_id={sessionId} API를 호출
  /// 3. 받은 리포트 데이터를 ReportModel로 변환하여 _reportData에 저장
  ///
  /// [사용 시점]
  /// - 사용자 B가 답변을 완료한 후 리포트를 보거나
  /// - 사용자 A가 홈 화면에서 완료된 세션을 클릭하여 리포트를 볼 때
  ///
  /// [반환값] ReportModel (리포트 데이터), 실패 시 null
  Future<ReportModel?> generateReport(String token) async {
    if (_sessionId == null) {
      _errorMessage = '세션 ID가 없습니다.';
      notifyListeners();
      return null;
    }

    if (token.isEmpty) {
      _errorMessage = '로그인이 필요합니다.';
      notifyListeners();
      return null;
    }

    setLoading(true);
    _errorMessage = null;

    try {
      final report = await _quizService.generateReport(_sessionId!, token);

      if (report != null) {
        setReportData(report);
        setLoading(false);
        return report;
      } else {
        _errorMessage = '리포트 생성에 실패했습니다.';
        setLoading(false);
        return null;
      }
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      setLoading(false);
      return null;
    }
  }

  /// 퀴즈 세션 목록 조회 함수 (홈 화면용)
  ///
  /// [내부 동작]
  /// 1. QuizService가 GET /api/quiz/sessions API를 호출하여 A의 모든 세션 목록 조회
  /// 2. 받은 세션 목록을 _quizSessions에 저장 (각 세션은 partner_nickname, status 등 포함)
  ///
  /// [사용 시점] 홈 화면에서 "진행 중인 대화" 목록을 표시할 때
  ///
  /// [반환값] void (결과는 _quizSessions getter를 통해 접근)
  Future<void> fetchQuizSessions(String token) async {
    if (token.isEmpty) {
      _errorMessage = '로그인이 필요합니다.';
      notifyListeners();
      return;
    }

    setLoading(true);
    _errorMessage = null;

    try {
      _quizSessions = await _quizService.getQuizSessions(token);
      print("✅ 세션 목록 로드 성공: ${_quizSessions.length}개 가져옴");

      setLoading(false);
    } catch (e) {
      print("🚨 세션 목록 로드 실패 에러: $e");
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      _quizSessions = [];
      setLoading(false);
    }
  }

  /// 세션 초기화 (테스트용 또는 새 세션 시작 시)
  void reset() {
    _situationText = null;
    _followUpPairs.clear();
    _sessionId = null;
    _bQuestions.clear();
    _bAnswers.clear();
    _reportData = null;
    _isLoading = false;
    _errorMessage = null;
    notifyListeners();
  }
}
