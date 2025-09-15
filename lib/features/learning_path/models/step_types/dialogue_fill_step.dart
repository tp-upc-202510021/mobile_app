class DialogueFillConversation {
  final String speaker;
  final String text;

  const DialogueFillConversation({required this.speaker, required this.text});

  factory DialogueFillConversation.fromJson(Map<String, dynamic> json) {
    return DialogueFillConversation(
      speaker: json['speaker'],
      text: json['text'],
    );
  }
}

class DialogueFillStep {
  final List<DialogueFillConversation> conversation;
  final List<String> options;
  final List<int> answers;

  const DialogueFillStep({
    required this.conversation,
    required this.options,
    required this.answers,
  });

  factory DialogueFillStep.fromJson(Map<String, dynamic> json) {
    return DialogueFillStep(
      conversation: (json['conversation'] as List)
          .map((e) => DialogueFillConversation.fromJson(e))
          .toList(),
      options: List<String>.from(json['options']),
      answers: List<int>.from(json['answers']),
    );
  }
}
