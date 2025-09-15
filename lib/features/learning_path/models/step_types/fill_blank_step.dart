class FillBlankStep {
  final String sentence;
  final List<String> options;
  final int answer;

  const FillBlankStep({
    required this.sentence,
    required this.options,
    required this.answer,
  });

  factory FillBlankStep.fromJson(Map<String, dynamic> json) {
    return FillBlankStep(
      sentence: json['sentence'],
      options: List<String>.from(json['options']),
      answer: json['answer'],
    );
  }
}
