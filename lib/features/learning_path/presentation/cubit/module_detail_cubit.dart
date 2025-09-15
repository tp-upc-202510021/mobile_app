import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_app/features/learning_path/models/module_detail_model.dart';
import 'package:mobile_app/features/learning_path/repositories/learning_path_repository.dart';

class ModuleDetailState {
  final bool loading;
  final ModuleDetailModel? data;
  final String? error;

  ModuleDetailState({this.loading = false, this.data, this.error});
}

class ModuleDetailCubit extends Cubit<ModuleDetailState> {
  final LearningPathRepository _repository;

  ModuleDetailCubit(this._repository) : super(ModuleDetailState());

  Future<ModuleDetailModel> loadModuleDetail(int moduleId) async {
    emit(ModuleDetailState(loading: true));
    try {
      final moduleDetail = await _repository.getModuleDetail(moduleId);
      // moduleDetail.content is now LearningModuleContent with steps
      emit(ModuleDetailState(data: moduleDetail));
      return moduleDetail;
    } catch (e) {
      emit(ModuleDetailState(error: e.toString()));
      throw Exception(e.toString());
    }
  }
}
