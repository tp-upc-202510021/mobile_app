// game_result_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_app/features/game/data/game_data_model.dart';
import 'package:mobile_app/features/game/presentation/game_cubit.dart';
import 'package:mobile_app/features/game/presentation/rate_event_cubit.dart';
import 'package:mobile_app/features/game/presentation/screens/game_round_screen.dart';
import 'package:intl/intl.dart';

class GameResultScreen extends StatelessWidget {
  final LoanResult loanResult;
  final int nextRoundIndex;
  final GameData game;

  const GameResultScreen({
    super.key,
    required this.loanResult,
    required this.nextRoundIndex,
    required this.game,
  });

  @override
  Widget build(BuildContext context) {
    final isLast = nextRoundIndex >= game.rounds.length;
    final formatCurrency = NumberFormat.currency(
      locale: 'es_PE',
      symbol: 'S/',
      customPattern: '¤#,##0.00', // ¤ indica dónde va el símbolo
    );
    return Scaffold(
      appBar: AppBar(title: const Text('Resultado del préstamo')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              loanResult.message,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 20),

            Text(
              "💰 Total pagado: ${formatCurrency.format(loanResult.totalPaid)}",
            ),
            Text(
              "📈 Intereses: ${formatCurrency.format(loanResult.totalInterest)}",
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () {
                if (isLast) {
                  Navigator.popUntil(context, (route) => route.isFirst);
                } else {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => MultiBlocProvider(
                        providers: [
                          BlocProvider.value(value: context.read<GameCubit>()),
                          BlocProvider.value(
                            value: context.read<RateEventCubit>(),
                          ),
                        ],
                        child: GameRoundScreen(
                          game: game,
                          roundIndex: nextRoundIndex,
                        ),
                      ),
                    ),
                  );
                }
              },
              child: Text(isLast ? 'Finalizar Juego' : 'Siguiente Ronda'),
            ),
          ],
        ),
      ),
    );
  }
}
