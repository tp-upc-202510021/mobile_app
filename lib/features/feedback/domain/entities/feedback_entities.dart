class FeedbackQuestion {
  final int id;
  final String questionText;
  final String questionType;
  final List<dynamic> predefinedAnswers;

  FeedbackQuestion({
    required this.id,
    required this.questionText,
    required this.questionType,
    required this.predefinedAnswers,
  });
}

class FeedbackResponse {
  final int questionId;
  final String answer;

  FeedbackResponse({required this.questionId, required this.answer});
}
