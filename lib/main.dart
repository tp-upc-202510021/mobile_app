import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:forui/forui.dart';
import 'package:mobile_app/app/app_root.dart';
import 'package:mobile_app/features/authentication/services/websocket_service.dart';

import 'features/authentication/presentation/cubit/auth_cubit.dart';
import 'features/authentication/repositories/auth_repository.dart';
import 'features/authentication/services/auth_service.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() {
  // Configura la barra de estado transparente y texto oscuro

  final authService = AuthService();
  final authRepo = AuthRepository(authService);
  final webSocketService = WebSocketService();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => AuthCubit(authRepo, webSocketService)),
      ],
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
      navigatorKey: navigatorKey,
      localizationsDelegates: FLocalizations.localizationsDelegates,
      supportedLocales: FLocalizations.supportedLocales,
      theme: theme.toApproximateMaterialTheme(),
      builder: (context, child) {
        return FToaster(
          child: FTheme(
            data: theme,
            child: Container(
              color: theme.colors.background,
              child: SafeArea(child: child!),
            ),
          ),
        );
      },
      home: const AppRoot(),
    );
  }
}
