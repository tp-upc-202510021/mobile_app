import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_app/app/main_menu_screen.dart';
import 'package:mobile_app/features/authentication/presentation/cubit/auth_cubit.dart';
import 'package:mobile_app/features/authentication/presentation/screens/login_screen.dart';
import 'package:mobile_app/features/splash/presentation/splash_screen.dart';

class AppRoot extends StatelessWidget {
  const AppRoot({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        if (state.loading) {
          return const SplashScreen();
        } else if (!state.isAuthenticated) {
          return const LoginScreen();
        } else {
          return const MainMenuScreen();
        }
      },
    );
  }
}
