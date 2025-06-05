import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:forui/forui.dart';
import 'package:mobile_app/app/main_menu_screen.dart';
import 'package:mobile_app/features/authentication/presentation/cubit/auth_cubit.dart';
import 'package:mobile_app/features/authentication/presentation/screens/login_screen.dart';
import 'package:mobile_app/features/authentication/repositories/auth_repository.dart';
import 'package:mobile_app/features/authentication/services/auth_service.dart';

void main() {
  final authService = AuthService();
  final authRepo = AuthRepository(authService);

  runApp(
    BlocProvider(
      create: (_) => AuthCubit(authRepo),
      child: const Application(),
    ),
  );
}

class Application extends StatelessWidget {
  const Application({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = FThemes.zinc.light;

    return MaterialApp(
      localizationsDelegates: FLocalizations.localizationsDelegates,
      supportedLocales: FLocalizations.supportedLocales,
      builder: (_, child) => FTheme(data: theme, child: child!),
      theme: theme.toApproximateMaterialTheme(),
      home: BlocBuilder<AuthCubit, AuthState>(
        builder: (context, state) {
          if (state.loading) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
          if (state.isAuthenticated) {
            return const MainMenuScreen();
          }
          return const LoginScreen();
        },
      ),
    );
  }
}
