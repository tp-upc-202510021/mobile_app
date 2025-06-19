import 'package:mobile_app/features/game/data/game_data_model.dart';
import 'package:mobile_app/features/game/data/game_service.dart';
import 'package:mobile_app/features/game/data/rate_event_model.dart';

class GameRepository {
  final GameService service;

  GameRepository(this.service);

  Future<GameData> fetchGame() => service.generateGame();

  Future<RateEventResponse> sendRateEvent(RateEventRequest request) {
    return service.sendRateEvent(request);
  }
}
