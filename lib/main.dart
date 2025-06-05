import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:forui/forui.dart';
import 'package:mobile_app/app/app_root.dart';

import 'features/authentication/presentation/cubit/auth_cubit.dart';
import 'features/authentication/repositories/auth_repository.dart';
import 'features/authentication/services/auth_service.dart';

void main() {
  final authService = AuthService();
  final authRepo = AuthRepository(authService);

  runApp(
    MultiBlocProvider(
      providers: [BlocProvider(create: (_) => AuthCubit(authRepo))],
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
      home:
          const AppRoot(), // Aquí está el widget que decide qué pantalla mostrar
    );
  }
}
