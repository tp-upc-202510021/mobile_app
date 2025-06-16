class InitialAssessmentResult {
  String responseTone;
  String motivation;
  Set<int> modules;

  InitialAssessmentResult({
    required this.responseTone,
    required this.motivation,
    Set<int>? modules,
  }) : modules = modules ?? {};

  Map<String, dynamic> toJson() {
    return {
      'response_tone': responseTone,
      'motivation': motivation,
      'modules': modules.toList(),
    };
  }

  void addModules(List<dynamic> newModules) {
    modules.addAll(newModules.cast<int>());
  }
}
