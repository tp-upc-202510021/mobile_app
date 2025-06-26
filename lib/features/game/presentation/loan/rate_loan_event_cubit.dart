import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_app/features/game/data/loan/game_repository.dart';
import 'package:mobile_app/features/game/data/loan/rate_event_loan_model.dart';
import 'package:mobile_app/features/game/presentation/loan/game_loan_cubit.dart';

class RateEventCubit extends Cubit<GameState> {
  final LoanGameRepository repository;

  RateEventCubit(this.repository) : super(RateEventInitial());

  Future<void> submitRateEvent({
    required double baseRate,
    required String economicOutlookStatement,
    required RateVariation rateVariation,
    required HiddenEvent hiddenEvent,
  }) async {
    emit(RateEventLoading());
    try {
      final request = RateEventLoanRequest(
        baseRate: baseRate,
        economicOutlookStatement: economicOutlookStatement,
        rateVariation: rateVariation,
        hiddenEvent: hiddenEvent,
      );

      final response = await repository.sendRateEvent(request);
      emit(RateEventSuccess(response));
    } catch (e) {
      emit(RateEventError(e.toString()));
    }
  }
}
