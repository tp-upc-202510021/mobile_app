import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/feedback_entities.dart';
import '../../domain/usecases/feedback_usecases.dart';

part 'feedback_state.dart';

class FeedbackCubit extends Cubit<FeedbackState> {
  final GetFeedbackQuestionsUseCase getQuestionsUseCase;
  final SaveFeedbackResponsesUseCase saveResponsesUseCase;

  FeedbackCubit({
    required this.getQuestionsUseCase,
    required this.saveResponsesUseCase,
  }) : super(FeedbackInitial());

  Future<void> loadQuestions() async {
    emit(FeedbackLoading());
    try {
      final questions = await getQuestionsUseCase();
      emit(FeedbackLoaded(questions));
    } catch (e) {
      emit(FeedbackError(e.toString()));
    }
  }

  Future<void> submitResponses(
    int moduleId,
    List<FeedbackResponse> responses,
  ) async {
    emit(FeedbackSubmitting());
    try {
      await saveResponsesUseCase(moduleId, responses);
      emit(FeedbackSubmitted());
    } catch (e) {
      emit(FeedbackError(e.toString()));
    }
  }
}
