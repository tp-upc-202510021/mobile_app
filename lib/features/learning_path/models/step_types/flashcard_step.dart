class FlashcardStep {
  final String front;
  final String back;

  const FlashcardStep({required this.front, required this.back});

  factory FlashcardStep.fromJson(Map<String, dynamic> json) {
    return FlashcardStep(front: json['front'], back: json['back']);
  }
}
