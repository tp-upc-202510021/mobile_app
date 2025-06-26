import 'package:mobile_app/features/game/data/investment/apply_exchange_investment_model.dart';

abstract class InvestmentGameState {}

class InvestmentGameInitial extends InvestmentGameState {}

class InvestmentGameLoading extends InvestmentGameState {}

class InvestmentGameInviteSuccess extends InvestmentGameState {}

class InvestmentGameInvitationResponseSuccess extends InvestmentGameState {}

class ExchangeEventApplied extends InvestmentGameState {
  final ApplyExchangeEventResponse response;

  ExchangeEventApplied(this.response);
}

class InvestmentGameError extends InvestmentGameState {
  final String message;

  InvestmentGameError(this.message);
}
