// game_round_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_app/features/game/data/loan/loan_calc.dart';
import 'package:mobile_app/features/game/data/loan/game_data_loan_model.dart';
import 'package:mobile_app/features/game/presentation/loan/game_loan_cubit.dart';
import 'package:mobile_app/features/game/presentation/loan/rate_loan_event_cubit.dart';
import 'package:mobile_app/features/game/presentation/loan/screens/game_loan_result_screen.dart';

class GameRoundScreen extends StatelessWidget {
  final GameLoanData game;
  final int roundIndex;

  const GameRoundScreen({
    super.key,
    required this.game,
    required this.roundIndex,
  });

  @override
  Widget build(BuildContext context) {
    final round = game.rounds[roundIndex];

    return Scaffold(
      appBar: AppBar(title: Text('Ronda ${round.round}')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              round.statement,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Text(round.economicOutlookStatement),
            const SizedBox(height: 20),
            const Text(
              'Opciones de préstamo:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            ...round.options.map(
              (option) => Card(
                child: ListTile(
                  title: Text(option.financialEntity),
                  subtitle: Text(
                    '${option.spreadPercentage}% - ${option.repaymentTermMonths} meses - ${option.isVariable ? "Variable" : "Fija"}',
                  ),
                  onTap: () async {
                    context.read<RateEventCubit>().submitRateEvent(
                      baseRate: game.baseRate.value,
                      economicOutlookStatement: round.economicOutlookStatement,
                      rateVariation: round.rateVariation,
                      hiddenEvent: round.hiddenEvent,
                    );
                    // Esperar a que se procese
                    final result = await context
                        .read<RateEventCubit>()
                        .stream
                        .firstWhere(
                          (state) =>
                              state is RateEventSuccess || state is GameError,
                        );

                    if (result is GameError) {
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text(result.message)));
                      return;
                    }

                    final eval = result as RateEventSuccess;

                    final calc = calculateLoan(
                      principal: round.requiredAmount.toDouble(),
                      termMonths: option.repaymentTermMonths,
                      originalBaseRate: eval.response.originalRate,
                      newBaseRate: eval.response.newRate,
                      spread: option.spreadPercentage,
                      isVariable: option.isVariable,
                      normalEventOccurred: eval.response.normalEventOccurred,
                      hiddenEventOccurred: eval.response.hiddenEventOccurred,
                      message: eval.response.message,
                    );

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => MultiBlocProvider(
                          providers: [
                            BlocProvider.value(
                              value: context.read<GameCubit>(),
                            ),
                            BlocProvider.value(
                              value: context.read<RateEventCubit>(),
                            ),
                          ],
                          child: GameResultScreen(
                            loanResult: calc,
                            nextRoundIndex: roundIndex + 1,
                            game: game,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
