class AnalogyCardStep {
  final String concept;
  final String analogy;

  const AnalogyCardStep({required this.concept, required this.analogy});

  factory AnalogyCardStep.fromJson(Map<String, dynamic> json) {
    return AnalogyCardStep(concept: json['concept'], analogy: json['analogy']);
  }
}
