import 'package:mobile_app/features/badge/data/badge_model.dart';

abstract class BadgeState {}

class BadgeInitial extends BadgeState {}

class BadgeLoading extends BadgeState {}

class BadgeLoaded extends BadgeState {
  final List<BadgeModel> badges;
  BadgeLoaded(this.badges);
}

class BadgeError extends BadgeState {
  final String message;
  BadgeError(this.message);
}
