import 'package:mobile_app/features/game/data/rate_event_model.dart';

abstract class RateEventState {}

class RateEventInitial extends RateEventState {}

class RateEventLoading extends RateEventState {}

class RateEventSuccess extends RateEventState {
  final RateEventResponse response;

  RateEventSuccess(this.response);
}

class RateEventError extends RateEventState {
  final String message;

  RateEventError(this.message);
}
