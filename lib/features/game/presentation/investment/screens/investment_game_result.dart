import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:mobile_app/features/game/data/investment/apply_exchange_investment_model.dart';
import 'package:mobile_app/features/game/data/investment/game_data_investment_model.dart';
import 'package:mobile_app/features/game/data/investment/investment_calc.dart';
import 'package:mobile_app/features/game/presentation/investment/investment_game_cubit.dart';
import 'package:mobile_app/features/game/presentation/investment/screens/investment_game_round.dart';

// 👇 Asegúrate de tener este extension en tu archivo de modelo
extension GameInvestmentDataX on GameInvestmentData {
  GameInvestmentData copyWithNewCapital(double newCapital, FxRate newBaseRate) {
    return GameInvestmentData(
      initialCapitalPen: newCapital,
      baseFxRate: newBaseRate,
      rounds: rounds,
    );
  }
}

class InvestmentGameResultScreen extends StatelessWidget {
  final GameInvestmentData game;
  final int roundIndex;
  final InvestmentOption option;
  final ApplyExchangeEventResponse response;
  final InvestmentOutcome outcome;

  const InvestmentGameResultScreen({
    super.key,
    required this.game,
    required this.roundIndex,
    required this.option,
    required this.response,
    required this.outcome,
  });

  @override
  Widget build(BuildContext context) {
    final isLast = roundIndex + 1 >= game.rounds.length;
    final format = NumberFormat.currency(locale: 'es_PE', symbol: 'S/');

    return Scaffold(
      appBar: AppBar(title: const Text('Resultado de inversión')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Inversión: ${option.title}",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              "Tipo de cambio original: Compra ${response.baseRate.buy} / Venta ${response.baseRate.sell}",
            ),
            Text(
              "Tipo de cambio nuevo: Compra ${response.event.newRate?.buy} / Venta ${response.event.newRate?.sell}",
            ),
            Text("Evento ocurrido: ${response.event.occurred ? 'Sí' : 'No'}"),
            const SizedBox(height: 20),
            Text("📈 Rendimiento: ${option.expectedReturnPct}%"),
            Text(
              "💰 Capital inicial: ${format.format(game.initialCapitalPen)}",
            ),
            Text("🔁 Moneda: ${outcome.currency}"),
            Text(
              "🔁 Monto final estimado: ${format.format(outcome.finalAmount)}",
            ),
            Text("📊 Ganancia estimada: ${format.format(outcome.gain)}"),
            const Spacer(),
            ElevatedButton(
              onPressed: () {
                if (isLast) {
                  Navigator.popUntil(context, (route) => route.isFirst);
                } else {
                  final nextBaseRate = response.event.occurred
                      ? response.event.newRate
                      : response.baseRate;

                  final updatedGame = game.copyWithNewCapital(
                    outcome.finalAmount,
                    nextBaseRate!,
                  );

                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => MultiBlocProvider(
                        providers: [
                          BlocProvider.value(
                            value: context.read<InvestmentGameCubit>(),
                          ),
                        ],
                        child: InvestmentGameRoundScreen(
                          game: updatedGame, // 👈 juego actualizado
                          roundIndex: roundIndex + 1,
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
