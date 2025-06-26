import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_app/features/authentication/services/websocket_service.dart';
import 'package:mobile_app/features/game/data/loan/game_data_loan_model.dart';
import 'package:mobile_app/features/game/data/loan/game_repository.dart';
import 'package:mobile_app/features/game/data/loan/rate_event_loan_model.dart';

abstract class GameState {}

class GameInitial extends GameState {}

class GameLoading extends GameState {}

class GameLoaded extends GameState {
  final GameLoanData game;
  GameLoaded(this.game);
}

class GameInvitationResponded extends GameState {
  final String response;
  final int sessionId;
  GameInvitationResponded({required this.response, required this.sessionId});
}

class GameError extends GameState {
  final String message;
  GameError(this.message);
}

class RateEventInitial extends GameState {}

class RateEventLoading extends GameState {}

class RateEventSuccess extends GameState {
  final RateEventResponse response;

  RateEventSuccess(this.response);
}

class RateEventError extends GameState {
  final String message;

  RateEventError(this.message);
}

class GameCubit extends Cubit<GameState> {
  final LoanGameRepository repository;

  GameCubit(this.repository) : super(GameInitial());

  Future<void> loadGame() async {
    emit(GameLoading());
    try {
      print("api creando juego...");
      final game = await repository.fetchGame();

      print("✅ Juego creado:");
      print(game);
      emit(GameLoaded(game));
    } catch (e) {
      emit(GameError('Error al cargar el juego: $e'));
    }
  }

  Future<void> inviteToGame(int invitedUserId) async {
    final response = await repository.inviteToGame(invitedUserId);
    final message = response['message'];
    final sessionId = response['session_id'];

    final messageData = jsonEncode({
      "title": "Invitación enviada",
      "body": message,
      "show_button": true,
      "button_text": "Ir a sala",
    });

    print('📨 $message | 🆔 sessionId: $sessionId');

    // Aquí podrías navegar, mostrar un toast, etc.
  }

  Future<void> respondToInvitation(int sessionId, String response) async {
    try {
      emit(GameLoading());
      final result = await repository.respondToInvitation(
        sessionId: sessionId,
        response: response,
      );
      emit(
        GameInvitationResponded(
          response: result.response,
          sessionId: result.sessionId,
        ),
      );
    } catch (e) {
      emit(GameError(e.toString()));
    }
  }
}
