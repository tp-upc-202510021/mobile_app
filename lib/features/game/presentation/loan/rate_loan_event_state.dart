import 'package:mobile_app/features/game/data/loan/rate_event_loan_model.dart';

abstract class RateLoanEventState {}

class RateLoanEventInitial extends RateLoanEventState {}

class RateLoanEventLoading extends RateLoanEventState {}

class RateLoanEventSuccess extends RateLoanEventState {
  final RateEventResponse response;

  RateLoanEventSuccess(this.response);
}

class RateLoanEventError extends RateLoanEventState {
  final String message;

  RateLoanEventError(this.message);
}
