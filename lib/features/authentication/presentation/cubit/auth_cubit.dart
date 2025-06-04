import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_app/features/authentication/models/user_model.dart';
import 'package:mobile_app/features/authentication/repositories/auth_repository.dart';

class AuthState {
  final bool loading;
  final UserModel? user;
  final String? error;

  AuthState({this.loading = false, this.user, this.error});
}

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _repository;

  AuthCubit(this._repository) : super(AuthState());

  Future<void> login(String email, String password) async {
    emit(AuthState(loading: true));
    try {
      print('🔐 Attempting to login with email: $email');
      final user = await _repository.login(email, password);
      await _repository.printStoredTokens();
      emit(AuthState(user: user));
    } catch (e) {
      emit(AuthState(error: e.toString()));
    }
  }
}
