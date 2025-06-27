// game_round_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_app/features/game/data/loan/loan_calc.dart';
import 'package:mobile_app/features/game/data/loan/game_data_loan_model.dart';
import 'package:mobile_app/features/game/presentation/loan/game_loan_cubit.dart';
import 'package:mobile_app/features/game/presentation/loan/rate_loan_event_cubit.dart';
import 'package:mobile_app/features/game/presentation/loan/screens/game_loan_result_screen.dart';

class GameRoundScreen extends StatefulWidget {
  final GameLoanData game;
  final int roundIndex;

  const GameRoundScreen({
    super.key,
    required this.game,
    required this.roundIndex,
  });

  @override
  State<GameRoundScreen> createState() => _GameRoundScreenState();
}

class _GameRoundScreenState extends State<GameRoundScreen> {
  LoanOption? selectedOption;

  @override
  Widget build(BuildContext context) {
    final round = widget.game.rounds[widget.roundIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text('Ronda ${round.round}'),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0.5,
        foregroundColor: Colors.black87,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '📖 ${round.statement}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Text(
              '🔍 ${round.economicOutlookStatement}',
              style: TextStyle(fontSize: 15, color: Colors.black87),
            ),
            const SizedBox(height: 24),
            const Text(
              '🏦 Opciones de préstamo:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ListView.separated(
                itemCount: round.options.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (_, i) {
                  final option = round.options[i];
                  final isSelected = selectedOption == option;

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedOption = option;
                      });
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      padding: const EdgeInsets.symmetric(
                        vertical: 16,
                        horizontal: 16,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.blue.shade50 : Colors.white,
                        border: Border.all(
                          color: isSelected
                              ? Colors.blue
                              : Colors.grey.shade300,
                          width: isSelected ? 2 : 1,
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.05),
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            option.financialEntity,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              Icon(
                                Icons.percent,
                                size: 16,
                                color: Colors.grey[600],
                              ),
                              const SizedBox(width: 4),
                              Text("${option.spreadPercentage}%"),
                              const SizedBox(width: 12),
                              Icon(
                                Icons.calendar_today_outlined,
                                size: 16,
                                color: Colors.grey[600],
                              ),
                              const SizedBox(width: 4),
                              Text("${option.repaymentTermMonths} meses"),
                              const SizedBox(width: 12),
                              Icon(
                                Icons.sync_alt,
                                size: 16,
                                color: Colors.grey[600],
                              ),
                              const SizedBox(width: 4),
                              Text(option.isVariable ? "Variable" : "Fija"),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            if (selectedOption != null)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.play_arrow),
                  label: const Text('Confirmar y continuar'),
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
                  onPressed: () async {
                    final option = selectedOption!;
                    context.read<RateEventCubit>().submitRateEvent(
                      baseRate: widget.game.baseRate.value,
                      economicOutlookStatement: round.economicOutlookStatement,
                      rateVariation: round.rateVariation,
                      hiddenEvent: round.hiddenEvent,
                    );

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
                              value: context.read<GameLoanCubit>(),
                            ),
                            BlocProvider.value(
                              value: context.read<RateEventCubit>(),
                            ),
                          ],
                          child: GameResultScreen(
                            loanResult: calc,
                            nextRoundIndex: widget.roundIndex + 1,
                            game: widget.game,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
