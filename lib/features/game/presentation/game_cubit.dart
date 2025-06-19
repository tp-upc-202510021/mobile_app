import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_app/features/game/data/game_data_model.dart';
import 'package:mobile_app/features/game/data/game_repository.dart';
import 'package:mobile_app/features/game/data/rate_event_model.dart';

abstract class GameState {}

class GameInitial extends GameState {}

class GameLoading extends GameState {}

class GameLoaded extends GameState {
  final GameData game;
  GameLoaded(this.game);
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
  final GameRepository repository;
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
}
