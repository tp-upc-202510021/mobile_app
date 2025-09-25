import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:forui/forui.dart';
import 'package:mobile_app/app/app_root.dart';
import 'package:mobile_app/features/authentication/services/websocket_service.dart';
import 'features/authentication/presentation/cubit/auth_cubit.dart';
import 'features/authentication/repositories/auth_repository.dart';
import 'features/authentication/services/auth_service.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // Reporta errores no capturados automáticamente
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;

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

class AnalyticsNavigatorObserver extends NavigatorObserver {
  DateTime? _screenEnterTime;
  String? _lastScreenName;

  @override
  void didPush(Route route, Route? previousRoute) {
    _logScreenChange(route);
    super.didPush(route, previousRoute);
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    _logScreenChange(previousRoute);
    super.didPop(route, previousRoute);
  }

  void _logScreenChange(Route? route) async {
    String? screenName = route?.settings.name;

    // Si no hay settings.name, intenta obtener el nombre del widget principal o su child
    if (screenName == null && route is MaterialPageRoute) {
      try {
        final widget = route.builder(route.navigator!.context);
        Widget realWidget = widget;
        // Si el widget es un BlocProvider o MultiBlocProvider, toma el child (o unknown si es null)
        if (widget is BlocProvider) {
          realWidget = widget.child ?? const _UnknownScreen();
        } else if (widget.runtimeType.toString().contains(
          'MultiBlocProvider',
        )) {
          // Usa reflection para intentar obtener el child
          try {
            final child = (widget as dynamic).child as Widget?;
            realWidget = child ?? const _UnknownScreen();
          } catch (_) {
            realWidget = const _UnknownScreen();
          }
        }
        screenName = realWidget.runtimeType.toString();
      } catch (_) {
        screenName = route.runtimeType.toString();
      }
    }

    screenName ??= route?.runtimeType.toString() ?? 'unknown';

    final now = DateTime.now();
    if (_screenEnterTime != null && _lastScreenName != null) {
      final duration = now.difference(_screenEnterTime!).inSeconds;
      await FirebaseAnalytics.instance.logEvent(
        name: 'screen_time',
        parameters: {
          'screen_name': _lastScreenName ?? 'unknown',
          'duration_seconds': duration,
        },
      );
    }
    await FirebaseAnalytics.instance.logEvent(
      name: 'screen_view',
      parameters: {'screen_name': screenName},
    );
    _screenEnterTime = now;
    _lastScreenName = screenName;
  }
}

class SessionObserver with WidgetsBindingObserver {
  DateTime? _sessionStartTime;

  void start() {
    WidgetsBinding.instance.addObserver(this);
    _sessionStartTime = DateTime.now();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.detached) {
      _logSessionTime();
    } else if (state == AppLifecycleState.resumed) {
      _sessionStartTime = DateTime.now();
    }
  }

  void _logSessionTime() async {
    if (_sessionStartTime != null) {
      final duration = DateTime.now().difference(_sessionStartTime!).inSeconds;
      await FirebaseAnalytics.instance.logEvent(
        name: 'session_time',
        parameters: {'duration_seconds': duration},
      );
      _sessionStartTime = null;
    }
  }
}

class Application extends StatelessWidget {
  const Application({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = FThemes.zinc.light;
    final sessionObserver = SessionObserver();
    sessionObserver.start();
    return MaterialApp(
      navigatorKey: navigatorKey,
      navigatorObservers: [AnalyticsNavigatorObserver()],
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

// Widget auxiliar para evitar nulls en el observer
class _UnknownScreen extends StatelessWidget {
  const _UnknownScreen();
  @override
  Widget build(BuildContext context) => const SizedBox.shrink();
}
