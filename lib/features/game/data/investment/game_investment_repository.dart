import 'package:mobile_app/features/game/data/game_invitation_response_model.dart';
import 'package:mobile_app/features/game/data/investment/apply_exchange_investment_model.dart';
import 'package:mobile_app/features/game/data/investment/game_investment_service.dart';

class InvestmentGameRepository {
  final InvestmentGameService service;

  InvestmentGameRepository({required this.service});

  Future<Map<String, dynamic>> inviteUser(int userId) =>
      service.inviteToInvestmentGame(userId);

  Future<GameInvitationResponse> respondToInvitation({
    required int sessionId,
    required String response,
  }) => service.respondToInvestmentInvitation(
    sessionId: sessionId,
    response: response,
  );

  Future<ApplyExchangeEventResponse> applyExchangeEvent(
    Map<String, dynamic> data,
  ) => service.applyExchangeEvent(data);
}
