class FeedbackQuestionModel {
  final int id;
  final String questionText;
  final String questionType;
  final List<dynamic> predefinedAnswers;
  final DateTime createdAt;

  FeedbackQuestionModel({
    required this.id,
    required this.questionText,
    required this.questionType,
    required this.predefinedAnswers,
    required this.createdAt,
  });

  factory FeedbackQuestionModel.fromJson(Map<String, dynamic> json) {
    return FeedbackQuestionModel(
      id: json['id'],
      questionText: json['question_text'],
      questionType: json['question_type'],
      predefinedAnswers: json['predefined_answers'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}

class FeedbackResponseModel {
  final int questionId;
  final String answer;

  FeedbackResponseModel({required this.questionId, required this.answer});

  Map<String, dynamic> toJson() => {
    'question_id': questionId,
    'answer': answer,
  };
}
