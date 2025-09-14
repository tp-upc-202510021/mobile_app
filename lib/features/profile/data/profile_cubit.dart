import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_app/features/profile/data/profile_repository.dart';
import 'package:mobile_app/features/authentication/presentation/cubit/auth_cubit.dart';
import 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final ProfileRepository repository;
  final AuthCubit authCubit;

  ProfileCubit(this.repository, this.authCubit) : super(ProfileInitial());

  Future<void> loadProfile() async {
    emit(ProfileLoading());
    try {
      final profile = await repository.getProfile();
      emit(ProfileLoaded(profile));
    } catch (e) {
      // Detecta expiración por mensaje o tipo de error
      if (e.toString().contains('expirada') || e.toString().contains('401')) {
        await authCubit.logout();
        emit(ProfileError('Sesión expirada'));
      } else {
        emit(ProfileError('Sesión expirada o error de red'));
      }
    }
  }
}
