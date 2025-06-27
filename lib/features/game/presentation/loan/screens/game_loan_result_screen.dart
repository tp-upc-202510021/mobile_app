// game_result_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_app/features/game/data/loan/game_data_loan_model.dart';
import 'package:mobile_app/features/game/presentation/loan/game_loan_cubit.dart';
import 'package:mobile_app/features/game/presentation/loan/rate_loan_event_cubit.dart';
import 'package:mobile_app/features/game/presentation/loan/screens/game_loan_round_screen.dart';
import 'package:intl/intl.dart';

class GameResultScreen extends StatelessWidget {
  final LoanResult loanResult;
  final int nextRoundIndex;
  final GameLoanData game;

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
      appBar: AppBar(
        title: const Text('Resultado del préstamo'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Spacer(),
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '📢 Resultado',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      loanResult.message,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              color: Colors.blue[50],
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 16.0,
                  horizontal: 20,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '📊 Detalles del préstamo',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Icon(Icons.payments_outlined, color: Colors.green),
                        const SizedBox(width: 8),
                        Text(
                          "Total pagado: ",
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        Text(
                          formatCurrency.format(loanResult.totalPaid),
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Icon(Icons.trending_up, color: Colors.redAccent),
                        const SizedBox(width: 8),
                        Text(
                          "Intereses: ",
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        Text(
                          formatCurrency.format(loanResult.totalInterest),
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: Icon(isLast ? Icons.flag : Icons.arrow_forward_ios),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  textStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onPressed: () {
                  if (isLast) {
                    Navigator.popUntil(context, (route) => route.isFirst);
                  } else {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => MultiBlocProvider(
                          providers: [
                            BlocProvider.value(
                              value: context.read<GameLoanCubit>(),
                            ),
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
                label: Text(
                  isLast ? '🎉 Finalizar Juego' : '➡️ Siguiente Ronda',
                ),
              ),
            ),
            const Spacer(),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
