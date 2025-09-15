class QuizStep {
  final String question;
  final List<String> options;
  final int answer;

  const QuizStep({
    required this.question,
    required this.options,
    required this.answer,
  });

  factory QuizStep.fromJson(Map<String, dynamic> json) {
    return QuizStep(
      question: json['question'],
      options: List<String>.from(json['options']),
      answer: json['answer'],
    );
  }
}
