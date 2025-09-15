class DialogueStoryStep {
  final List<DialogueLine> dialogue;

  const DialogueStoryStep({required this.dialogue});

  factory DialogueStoryStep.fromJson(Map<String, dynamic> json) {
    return DialogueStoryStep(
      dialogue: (json['dialogue'] as List)
          .map((e) => DialogueLine.fromJson(e))
          .toList(),
    );
  }
}

class DialogueLine {
  final int index;
  final String speaker;
  final String text;

  const DialogueLine({
    required this.index,
    required this.speaker,
    required this.text,
  });

  factory DialogueLine.fromJson(Map<String, dynamic> json) {
    return DialogueLine(
      index: json['index'],
      speaker: json['speaker'],
      text: json['text'],
    );
  }
}
