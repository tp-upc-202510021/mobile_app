import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_app/features/badge/data/badge_repository.dart';

import 'badge_state.dart';

class BadgeCubit extends Cubit<BadgeState> {
  final BadgeRepository _repository;

  BadgeCubit(this._repository) : super(BadgeInitial());

  Future<void> loadUserBadges() async {
    emit(BadgeLoading());
    try {
      final badges = await _repository.getUserBadges();
      emit(BadgeLoaded(badges));
    } catch (e) {
      emit(BadgeError('Error al cargar los badges'));
    }
  }

  Future<void> unlockBadge(int badgeId, String description) async {
    try {
      await _repository.unlockBadge(badgeId, description);
      await loadUserBadges(); // reload badges
    } catch (e) {
      emit(BadgeError('No se pudo desbloquear el badge'));
    }
  }
}
