import 'package:mobile_app/features/badge/data/badge_model.dart';
import 'package:mobile_app/features/badge/data/badge_service.dart';

class BadgeRepository {
  final BadgeService _service;

  BadgeRepository(this._service);

  Future<List<BadgeModel>> getUserBadges() async {
    final data = await _service.fetchUserBadges();
    return data.map((json) => BadgeModel.fromJson(json)).toList();
  }

  Future<void> unlockBadge(int badgeId, String description) {
    return _service.unlockBadge(badgeId, description);
  }
}
