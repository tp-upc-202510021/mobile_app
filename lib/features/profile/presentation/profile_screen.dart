import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:forui/forui.dart';

import 'package:mobile_app/features/authentication/presentation/cubit/auth_cubit.dart';
import 'package:mobile_app/features/badge/data/badge_repository.dart';
import 'package:mobile_app/features/badge/data/badge_service.dart';
import 'package:mobile_app/features/badge/presentation/badge_cubit.dart';
import 'package:mobile_app/features/badge/presentation/screens/badges_profile_screen.dart';
import 'package:mobile_app/features/friends/data/friend_repository.dart';
import 'package:mobile_app/features/friends/data/friend_service.dart';
import 'package:mobile_app/features/friends/screens/friend_screen.dart';
import 'package:mobile_app/features/friends/friend_cubit.dart';
import 'package:mobile_app/features/profile/data/profile_cubit.dart';

import 'package:mobile_app/features/profile/data/profile_model.dart';
import 'package:mobile_app/features/profile/data/profile_repository.dart';
import 'package:mobile_app/features/profile/data/profile_service.dart';
import 'package:mobile_app/features/profile/data/profile_state.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Obtén la instancia de AuthRepository (ajusta según tu arquitectura)
    final authRepository = context.read<AuthCubit>().authRepository;
    return BlocProvider(
      create: (_) {
        final cubit = ProfileCubit(
          ProfileRepository(ProfileService(authRepository)),
          context.read<AuthCubit>(),
        );
        Future.delayed(const Duration(milliseconds: 500), () {
          cubit.loadProfile();
        });
        return cubit;
      },
      child: FScaffold(
        header: FHeader(
          title: Row(
            children: const [
              SizedBox(width: 10, height: 35),
              Text(
                'Mi Perfil',
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: BlocBuilder<ProfileCubit, ProfileState>(
            builder: (context, state) {
              if (state is ProfileLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is ProfileError) {
                return Center(child: Text(state.message));
              } else if (state is ProfileLoaded) {
                final ProfileModel profile = state.profile;

                return Column(
                  children: [
                    Row(
                      children: [
                        FAvatar(
                          image: const NetworkImage(
                            'https://example.com/profile.jpg',
                          ),
                          fallback: Text(profile.name[0].toUpperCase()),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                profile.name,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                profile.email,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () => print('Editar perfil'),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),
                    Row(
                      children: [
                        const SizedBox(width: 8),
                        const Text(
                          'ID de amigo: ',
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.black87,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(width: 5),
                        Text(
                          '${profile.id}',
                          style: const TextStyle(
                            fontSize: 20,
                            color: Colors
                                .blueGrey, // Cambia a tu color primario si prefieres
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 1),
                        IconButton(
                          icon: const Icon(FIcons.copy, size: 20),
                          tooltip: 'Copiar ID',
                          onPressed: () {
                            Clipboard.setData(
                              ClipboardData(text: profile.id.toString()),
                            );
                            showFToast(
                              context: context,
                              alignment: FToastAlignment.topCenter,
                              title: const Text('ID copiado'),
                              description: const Text(
                                'Tu ID ha sido copiado al portapapeles',
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Estadísticas
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _StatItem(
                          value: '${profile.badges.length}',
                          label: 'Logros',
                        ),
                      ],
                    ),
                    const Spacer(),

                    // Navegación dentro de un marco gris
                    Container(
                      height: 230,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: const Color(0xFFDDDDDD)),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          FButton(
                            style: FButtonStyle.secondary,
                            prefix: Icon(FIcons.settings),
                            onPress: () => print('Ir a Opciones'),
                            child: const _NavItem(title: 'Opciones'),
                          ),
                          const SizedBox(height: 15),
                          FButton(
                            style: FButtonStyle.secondary,
                            prefix: Icon(FIcons.trophy),
                            onPress: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => BlocProvider(
                                    create: (_) => BadgeCubit(
                                      BadgeRepository(BadgeService()),
                                    )..loadUserBadges(),
                                    child: const BadgeScreen(),
                                  ),
                                ),
                              );
                            },
                            child: const _NavItem(title: 'Logros'),
                          ),
                          const SizedBox(height: 15),
                          FButton(
                            style: FButtonStyle.secondary,
                            prefix: Icon(FIcons.users),
                            onPress: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => BlocProvider(
                                    create: (_) => FriendCubit(
                                      FriendRepository(FriendService()),
                                    ),
                                    child: const FriendsScreen(),
                                  ),
                                ),
                              );
                            },
                            child: const _NavItem(title: 'Amigos'),
                          ),
                        ],
                      ),
                    ),

                    const Spacer(),

                    // Mi cuenta
                    Container(
                      height: 130,
                      width: 400,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Color(0xFFDDDDDD)),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(left: 8.0),
                            child: Text(
                              'Mi cuenta',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF888888),
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextButton(
                            onPressed: () async {
                              print('Cerrar sesión');
                              await context.read<AuthCubit>().logout();
                            },
                            child: const Text(
                              'Cerrar sesión',
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              } else {
                return const SizedBox(); // Estado inicial vacío
              }
            },
          ),
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String value;
  final String label;

  const _StatItem({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(color: Colors.grey)),
      ],
    );
  }
}

class _NavItem extends StatelessWidget {
  final String title;

  const _NavItem({required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(title, style: const TextStyle(fontSize: 16)),
        const SizedBox(width: 10),
        const Icon(Icons.arrow_forward_ios, size: 16),
      ],
    );
  }
}
