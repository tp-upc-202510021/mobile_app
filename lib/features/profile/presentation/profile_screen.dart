import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:forui/forui.dart';
import 'package:mobile_app/features/authentication/presentation/cubit/auth_cubit.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return FScaffold(
      header: FHeader(title: const Text('Perfil')),
      child: Center(
        child: FButton(
          onPress: () {
            // Llama al logout del cubit
            context.read<AuthCubit>().logout();
            // Navega a pantalla de login o limpia stack si quieres
            Navigator.of(
              context,
            ).pushNamedAndRemoveUntil('/login', (route) => false);
          },
          child: const Text('Cerrar sesión'),
        ),
      ),
    );
  }
}
