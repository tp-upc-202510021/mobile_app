import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_app/features/game/data/investment/game_data_investment_model.dart';
import 'package:mobile_app/features/game/data/investment/game_investment_repository.dart';
import 'package:mobile_app/features/game/data/investment/game_investment_service.dart';
import 'package:mobile_app/features/game/data/loan/game_data_loan_model.dart';
import 'package:mobile_app/features/game/data/loan/game_loan_repository.dart';
import 'package:mobile_app/features/game/data/loan/game_loan_service.dart';
import 'package:mobile_app/features/game/presentation/investment/investment_game_cubit.dart';
import 'package:mobile_app/features/game/presentation/investment/screens/investment_game_round.dart';
import 'package:mobile_app/features/game/presentation/loan/game_loan_cubit.dart';
import 'package:mobile_app/features/game/presentation/loan/rate_loan_event_cubit.dart';
import 'package:mobile_app/features/game/presentation/loan/screens/game_loan_round_screen.dart';
import 'package:mobile_app/main.dart';
import 'package:mobile_app/shared/notification_service.dart';
import 'package:web_socket_channel/io.dart';

class WebSocketService {
  IOWebSocketChannel? _channel;

  void connect({required String userId, required String accessToken}) async {
    final uri = Uri.parse('ws://10.0.2.2:8000/ws/game/$userId/');

    try {
      final socket = await WebSocket.connect(
        uri.toString(),
        headers: {'Authorization': 'Bearer $accessToken'},
      );

      _channel = IOWebSocketChannel(socket);

      _channel!.stream.listen(
        (message) {
          print('📥 WS: $message');
          handleMessage(message);
        },
        onError: (error) {
          print('❌ WS error: $error');
        },
        onDone: () {
          print('🔌 WS cerrado');
        },
      );
    } catch (e) {
      print('🚨 Error conectando WebSocket: $e');
    }
  }

  void disconnect() {
    _channel?.sink.close();
    _channel = null;
  }

  void send(String message) {
    _channel?.sink.add(message);
  }

  void handleMessage(String message) {
    print('📥 Mensaje recibido: $message');

    try {
      final data = jsonDecode(message);
      final context = navigatorKey.currentContext;
      if (context == null) return;

      final gameType = data['game_type']; // 👈 Puede ser 'loan' o 'investment'

      if (data['type'] == 'game.accepted' || data['type'] == 'game.started') {
        NotificationService.dismissLoadingToast();

        NotificationService.show(
          title: '¡El juego ya comenzó! 🚀',
          body: data['message'] ?? 'El juego ha empezado. Únete ahora.',
          showButton: true,
          durationSeconds: 10,
          onPressed: () {
            if (gameType == 'loan') {
              final gameData = GameLoanData.fromJson(data['game_data']);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => MultiBlocProvider(
                    providers: [
                      BlocProvider(
                        create: (_) => GameLoanCubit(
                          LoanGameRepository(LoanGameService()),
                        ),
                      ),
                      BlocProvider(
                        create: (_) => RateEventCubit(
                          LoanGameRepository(LoanGameService()),
                        ),
                      ),
                    ],
                    child: GameRoundScreen(game: gameData, roundIndex: 0),
                  ),
                ),
              );
            } else if (gameType == 'investment') {
              final gameData = GameInvestmentData.fromJson(data['game_data']);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => BlocProvider(
                    create: (_) => InvestmentGameCubit(
                      InvestmentGameRepository(
                        service: InvestmentGameService(),
                      ),
                    ),
                    child: InvestmentGameRoundScreen(
                      game: gameData,
                      roundIndex: 0,
                    ),
                  ),
                ),
              );
            }
          },
        );
        return;
      }

      if (data['type'] == 'game.invitation') {
        final sessionId = data['session_id'];

        NotificationService.show(
          title: 'Invitación de juego',
          body: data['message'] ?? 'Has recibido una invitación.',
          showButton: true,
          buttonText: 'Responder',
          onPressed: () async {
            final context = navigatorKey.currentContext;
            if (context == null) return;

            final choice = await showDialog<String>(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Invitación'),
                content: const Text('¿Quieres aceptar la invitación al juego?'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context, 'reject'),
                    child: const Text('Rechazar'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context, 'accept');
                      NotificationService.showLoadingToast(context);
                    },
                    child: const Text('Aceptar'),
                  ),
                ],
              ),
            );

            if (choice == null) return;

            try {
              if (gameType == 'loan') {
                await LoanGameRepository(
                  LoanGameService(),
                ).respondToInvitation(sessionId: sessionId, response: choice);
              } else if (gameType == 'investment') {
                await InvestmentGameRepository(
                  service: InvestmentGameService(),
                ).respondToInvitation(sessionId: sessionId, response: choice);
              }

              if (choice == 'reject') {
                NotificationService.dismissLoadingToast();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Has rechazado la invitación.')),
                );
              }

              // Si acepta, espera el mensaje 'game.accepted' o 'game.started'
            } catch (e) {
              NotificationService.dismissLoadingToast();
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text('Error al responder: $e')));
            }
          },
        );
        return;
      }

      if (data['type'] == 'game.rejected') {
        NotificationService.dismissLoadingToast();
        NotificationService.show(
          title: 'Notificación',
          body: data['message'] ?? message,
          showButton: false,
        );
        return;
      }

      // Otros tipos genéricos
      NotificationService.show(
        title: 'Notificación',
        body: data['message'] ?? message,
        showButton: false,
      );
    } catch (e) {
      print('❌ Error al procesar mensaje WebSocket: $e');
    }
  }

  void simulateToast() {
    handleMessage(
      jsonEncode({
        "title": "Test Toast",
        "body": "Este es un mensaje de prueba 🧪",
      }),
    );
  }

  bool get isConnected => _channel != null;
}
