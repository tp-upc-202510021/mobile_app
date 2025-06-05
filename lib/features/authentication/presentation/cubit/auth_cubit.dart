import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_app/features/authentication/models/user_model.dart';
import 'package:mobile_app/features/authentication/repositories/auth_repository.dart';

class AuthState {
  final bool loading;
  final UserModel? user;
  final String? error;
  final bool isAuthenticated;

  AuthState({
    this.loading = false,
    this.user,
    this.error,
    this.isAuthenticated = false,
  });

  AuthState copyWith({
    bool? loading,
    UserModel? user,
    String? error,
    bool? isAuthenticated,
  }) {
    return AuthState(
      loading: loading ?? this.loading,
      user: user ?? this.user,
      error: error ?? this.error,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
    );
  }
}

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _repository;

  AuthCubit(this._repository) : super(AuthState()) {
    checkAuthStatus();
  }

  Future<void> checkAuthStatus() async {
    emit(state.copyWith(loading: true));
    final token = await _repository.getAccessToken();
    if (token != null && token.isNotEmpty) {
      // You can also fetch user info here if you want
      emit(state.copyWith(loading: false, isAuthenticated: true));
    } else {
      emit(state.copyWith(loading: false, isAuthenticated: false));
    }
  }

  Future<void> login(String email, String password) async {
    emit(state.copyWith(loading: true, error: null));
    try {
      final user = await _repository.login(email, password);
      await _repository.printStoredTokens();
      emit(state.copyWith(user: user, loading: false, isAuthenticated: true));
    } catch (e) {
      emit(state.copyWith(error: e.toString(), loading: false));
    }
  }

  Future<void> logout() async {
    await _repository.logout();
    emit(state.copyWith(isAuthenticated: false, user: null));
  }
}
