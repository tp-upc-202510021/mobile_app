class TrueFalseStatement {
  final String text;
  final bool answer;

  const TrueFalseStatement({required this.text, required this.answer});

  factory TrueFalseStatement.fromJson(Map<String, dynamic> json) {
    return TrueFalseStatement(text: json['text'], answer: json['answer']);
  }
}

class TrueFalseStep {
  final List<TrueFalseStatement> statements;

  const TrueFalseStep({required this.statements});

  factory TrueFalseStep.fromJson(Map<String, dynamic> json) {
    return TrueFalseStep(
      statements: (json['statements'] as List)
          .map((e) => TrueFalseStatement.fromJson(e))
          .toList(),
    );
  }
}
