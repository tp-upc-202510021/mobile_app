class InitialAssessmentResult {
  String responseTone;
  String motivation;
  Set<int> selectedModules;

  InitialAssessmentResult({
    required this.responseTone,
    required this.motivation,
    Set<int>? modules,
  }) : selectedModules = modules ?? {};

  Map<String, dynamic> toJson() {
    return {
      'response_tone': responseTone,
      'motivation': motivation,
      'modules': selectedModules.toList(),
    };
  }

  void addModules(List<dynamic> modules) {
    selectedModules.addAll(modules.cast<int>());
  }
}
