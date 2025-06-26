import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_app/features/game/data/investment/game_investment_repository.dart';
import 'investment_game_state.dart';

class InvestmentGameCubit extends Cubit<InvestmentGameState> {
  final InvestmentGameRepository repository;

  InvestmentGameCubit(this.repository) : super(InvestmentGameInitial());

  Future<void> inviteUser(int userId) async {
    emit(InvestmentGameLoading());
    try {
      await repository.inviteUser(userId);
      emit(InvestmentGameInviteSuccess());
    } catch (e) {
      emit(InvestmentGameError(e.toString()));
    }
  }

  Future<void> respondToInvitation(int sessionId, String response) async {
    emit(InvestmentGameLoading());
    try {
      await repository.respondToInvitation(
        sessionId: sessionId,
        response: response,
      );
      emit(InvestmentGameInvitationResponseSuccess());
    } catch (e) {
      emit(InvestmentGameError(e.toString()));
    }
  }

  Future<void> applyExchangeEvent(Map<String, dynamic> eventData) async {
    emit(InvestmentGameLoading());
    try {
      final result = await repository.applyExchangeEvent(eventData);

      emit(ExchangeEventApplied(result));
    } catch (e) {
      emit(InvestmentGameError(e.toString()));
    }
  }
}
