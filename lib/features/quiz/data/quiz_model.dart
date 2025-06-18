class Answer {
  final int answerId;
  final String text;
  final bool isCorrect;

  Answer({required this.answerId, required this.text, required this.isCorrect});

  factory Answer.fromJson(Map<String, dynamic> json) => Answer(
    answerId: json['answer_id'],
    text: json['text'],
    isCorrect: json['is_correct'],
  );
}

class Question {
  final int questionId;
  final String text;
  final List<Answer> answers;

  Question({
    required this.questionId,
    required this.text,
    required this.answers,
  });

  factory Question.fromJson(Map<String, dynamic> json) => Question(
    questionId: json['question_id'],
    text: json['text'],
    answers: (json['answers'] as List).map((e) => Answer.fromJson(e)).toList(),
  );
}

// quiz_model.dart
class Quiz {
  final int quizId;
  final int moduleId;
  final int totalQuestions;
  final List<Question> questions;

  Quiz({
    required this.quizId,
    required this.moduleId,
    required this.totalQuestions,
    required this.questions,
  });

  factory Quiz.fromJson(Map<String, dynamic> json) => Quiz(
    quizId: json['quiz_id'],
    moduleId: json['module_id'],
    totalQuestions: json['total_questions'],
    questions: (json['questions'] as List)
        .map((e) => Question.fromJson(e))
        .toList(),
  );
}
