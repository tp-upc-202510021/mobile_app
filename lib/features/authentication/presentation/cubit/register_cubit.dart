import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_app/features/authentication/models/user_model.dart';
import 'package:mobile_app/features/authentication/repositories/auth_repository.dart';

class RegisterState {
  final bool loading;
  final UserModel? user;
  final String? error;
  final bool success;

  RegisterState({
    this.loading = false,
    this.user,
    this.error,
    this.success = false,
  });

  RegisterState copyWith({
    bool? loading,
    UserModel? user,
    String? error,
    bool? success,
  }) {
    return RegisterState(
      loading: loading ?? this.loading,
      user: user ?? this.user,
      error: error ?? this.error,
      success: success ?? this.success,
    );
  }
}

class RegisterCubit extends Cubit<RegisterState> {
  final AuthRepository _repository;

  RegisterCubit(this._repository) : super(RegisterState());

  Future<void> register({
    required String name,
    required String email,
    required String password,
    required int age,
    required String preference,
  }) async {
    emit(state.copyWith(loading: true, error: null, success: false));

    try {
      final user = await _repository.register(
        name: name,
        email: email,
        password: password,
        age: age,
        preference: preference,
      );

      print(preference);
      emit(state.copyWith(loading: false, user: user, success: true));
    } catch (e) {
      emit(state.copyWith(loading: false, error: e.toString(), success: false));
    }
  }

  void reset() {
    emit(RegisterState());
  }
}
