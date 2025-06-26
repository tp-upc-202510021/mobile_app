import 'package:mobile_app/features/game/data/loan/game_data_loan_model.dart';
import 'package:mobile_app/features/game/data/game_invitation_response_model.dart';
import 'package:mobile_app/features/game/data/loan/game_loan_service.dart';
import 'package:mobile_app/features/game/data/loan/rate_event_loan_model.dart';

class LoanGameRepository {
  final LoanGameService service;

  LoanGameRepository(this.service);

  Future<GameLoanData> fetchGame() => service.generateGame();

  Future<RateEventResponse> sendRateEvent(RateEventLoanRequest request) {
    return service.sendRateEvent(request);
  }

  Future<Map<String, dynamic>> inviteToGame(int invitedUserId) {
    return service.inviteToGame(invitedUserId);
  }

  // En GameService
  Future<GameInvitationResponse> respondToInvitation({
    required int sessionId,
    required String response,
  }) async {
    return service.respondToInvitation(
      sessionId: sessionId,
      response: response,
    );
  }
}
