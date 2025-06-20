import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_app/features/authentication/models/user_model.dart';
import 'package:mobile_app/features/authentication/repositories/auth_repository.dart';
import 'package:mobile_app/features/authentication/services/websocket_service.dart';

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
  final WebSocketService _webSocketService;

  AuthCubit(this._repository, this._webSocketService) : super(AuthState()) {
    checkAuthStatus();
  }

  Future<void> checkAuthStatus() async {
    emit(state.copyWith(loading: true));
    final token = await _repository.getAccessToken();
    final userId = await _repository.getUserId();

    if (token != null && userId != null && token.isNotEmpty) {
      // 🔌 Conecta el WebSocket en segundo plano
      _webSocketService.connect(userId: userId, accessToken: token);

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

      final accessToken = await _repository.getAccessToken();

      // 🔌 Conectar WebSocket con el user ID y access token
      if (accessToken != null) {
        _webSocketService.connect(
          userId: user.id.toString(),
          accessToken: accessToken,
        );
      }
      emit(state.copyWith(user: user, loading: false, isAuthenticated: true));
    } catch (e) {
      emit(state.copyWith(error: e.toString(), loading: false));
    }
  }

  Future<void> logout() async {
    await _repository.logout();
    _webSocketService.disconnect();
    emit(state.copyWith(isAuthenticated: false, user: null));
  }

  WebSocketService get webSocketService => _webSocketService;
}
