import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_app/features/learning_path/models/learning_path_model.dart';
import 'package:mobile_app/features/learning_path/repositories/learning_path_repository.dart';

class LearningPathState {
  final bool loading;
  final LearningPathModel? data;
  final String? error;

  LearningPathState({this.loading = false, this.data, this.error});
}

class LearningPathCubit extends Cubit<LearningPathState> {
  final LearningPathRepository _repository;

  LearningPathCubit(this._repository) : super(LearningPathState());

  Future<void> loadLearningPath() async {
    emit(LearningPathState(loading: true));
    try {
      final learningPath = await _repository.getLearningPath();
      emit(LearningPathState(data: learningPath));
    } catch (e) {
      emit(LearningPathState(error: e.toString()));
    }
  }
}
