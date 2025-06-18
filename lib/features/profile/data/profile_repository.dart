import 'package:mobile_app/features/profile/data/profile_model.dart';
import 'package:mobile_app/features/profile/data/profile_service.dart';

class ProfileRepository {
  final ProfileService service;

  ProfileRepository(this.service);

  Future<ProfileModel> getProfile() async {
    final data = await service.getCurrentUser();
    return ProfileModel.fromJson(data);
  }
}
