import 'step_types/dialogue_story_step.dart';
import 'step_types/analogy_card_step.dart';
import 'step_types/flashcard_step.dart';
import 'step_types/quiz_step.dart';
import 'step_types/true_false_step.dart';
import 'step_types/fill_blank_step.dart';
import 'step_types/dialogue_fill_step.dart';

class LearningModuleContent {
  final String moduleTitle;
  final List<LearningStep> steps;

  LearningModuleContent({required this.moduleTitle, required this.steps});

  factory LearningModuleContent.fromJson(Map<String, dynamic> json) {
    return LearningModuleContent(
      moduleTitle: json['module_title'],
      steps: (json['steps'] as List)
          .map((stepJson) => LearningStep.fromJson(stepJson))
          .toList(),
    );
  }
}

class LearningStep {
  final String type;
  final dynamic data;

  LearningStep({required this.type, required this.data});

  factory LearningStep.fromJson(Map<String, dynamic> json) {
    final type = json['type'] as String;
    switch (type) {
      case 'dialogue_story':
        return LearningStep(type: type, data: DialogueStoryStep.fromJson(json));
      case 'analogy_card':
        return LearningStep(type: type, data: AnalogyCardStep.fromJson(json));
      case 'flashcard':
        return LearningStep(type: type, data: FlashcardStep.fromJson(json));
      case 'quiz':
        return LearningStep(type: type, data: QuizStep.fromJson(json));
      case 'true_false':
        return LearningStep(type: type, data: TrueFalseStep.fromJson(json));
      case 'fill_blank':
        return LearningStep(type: type, data: FillBlankStep.fromJson(json));
      case 'dialogue_fill':
        return LearningStep(type: type, data: DialogueFillStep.fromJson(json));
      default:
        return LearningStep(type: type, data: null);
    }
  }
}
