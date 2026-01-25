/// 리포트 데이터 모델
class ReportModel {
  // 속마음 데이터
  final String aThought;
  final String bThought;

  // AI 중재 메시지
  final String mediationTitle; // 공통 타이틀
  final String aDetailForB; // A의 자세한 입장 (B에게 보여줄 내용)
  final String bDetailForA; // B의 자세한 입장 (A에게 보여줄 내용)

  // 공통 팁
  final List<String> conversationTips;

  // 사용자 A와 B의 이름 (백엔드에서 제공)
  final String userAName;
  final String userBName;

  ReportModel({
    required this.aThought,
    required this.bThought,
    required this.mediationTitle,
    required this.aDetailForB,
    required this.bDetailForA,
    required this.conversationTips,
    required this.userAName,
    required this.userBName,
  });

  factory ReportModel.fromJson(Map<String, dynamic> json) {
    return ReportModel(
      aThought: json['a_thought'] ?? '',
      bThought: json['b_thought'] ?? '',
      mediationTitle: json['mediation_title'] ?? '',
      aDetailForB: json['a_detail_for_b'] ?? '',
      bDetailForA: json['b_detail_for_a'] ?? '',
      conversationTips: List<String>.from(json['conversation_tips'] ?? []),
      userAName: json['user_a_name'] ?? '사용자A',
      userBName: json['user_b_name'] ?? '상대방',
    );
  }

  Map<String, dynamic> toJson() => {
    'a_thought': aThought,
    'b_thought': bThought,
    'mediation_title': mediationTitle,
    'a_detail_for_b': aDetailForB,
    'b_detail_for_a': bDetailForA,
    'conversation_tips': conversationTips,
  };
}
