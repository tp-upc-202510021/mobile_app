import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:forui/forui.dart';
import 'package:mobile_app/features/authentication/presentation/cubit/auth_cubit.dart';
import 'package:mobile_app/features/authentication/presentation/screens/login_screen.dart';
import 'package:mobile_app/features/authentication/repositories/auth_repository.dart';
import 'package:mobile_app/features/authentication/services/auth_service.dart';

void main() {
  final authService = AuthService();
  final authRepo = AuthRepository(authService);

  // runApp(const Application());
  runApp(
    BlocProvider(create: (_) => AuthCubit(authRepo), child: Application()),
  );
}

class Application extends StatelessWidget {
  const Application({super.key});

  @override
  Widget build(BuildContext context) {
    /// Try changing this and hot reloading the application.
    ///
    /// To create a custom theme:
    /// ```shell
    /// dart forui theme create [theme template].
    /// ```
    final theme = FThemes.zinc.light;

    return MaterialApp(
      localizationsDelegates: FLocalizations.localizationsDelegates,
      supportedLocales: FLocalizations.supportedLocales,
      builder: (_, child) => FTheme(data: theme, child: child!),
      theme: theme.toApproximateMaterialTheme(),
      // You can replace FScaffold with Material's Scaffold.
      home: const LoginScreen(),
    );
  }
}
