import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:mobile_app/features/game/data/investment/apply_exchange_investment_model.dart';
import 'package:mobile_app/features/game/data/investment/game_data_investment_model.dart';
import 'package:mobile_app/features/game/data/investment/investment_calc.dart';
import 'package:mobile_app/features/game/presentation/investment/investment_game_cubit.dart';
import 'package:mobile_app/features/game/presentation/investment/screens/investment_game_round.dart';
import 'package:confetti/confetti.dart';

class InvestmentGameResultScreen extends StatefulWidget {
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
  State<InvestmentGameResultScreen> createState() =>
      _InvestmentGameResultScreenState();
}

class _InvestmentGameResultScreenState
    extends State<InvestmentGameResultScreen> {
  late ConfettiController _confettiController;
  final format = NumberFormat.currency(locale: 'en_US', symbol: '');

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(
      duration: const Duration(seconds: 2),
    );

    // Si hubo ganancia => celebrar 🎉
    if (widget.outcome.gain > 0) {
      _confettiController.play();
    }
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  String getCurrencyLabel(String currencyCode) {
    switch (currencyCode.toUpperCase()) {
      case 'USD':
        return 'USD';
      case 'PEN':
      default:
        return 'PEN';
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLast = widget.roundIndex + 1 >= widget.game.rounds.length;
    final event = widget.response.event;
    final shownRate = widget.response.event.occurred
        ? widget.response.event.newRate
        : widget.response.baseRate;

    final gainPositive = widget.outcome.gain >= 0;

    return Scaffold(
      appBar: AppBar(title: const Text('Resultado de inversión')),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  gainPositive ? "¡Ganaste!" : "Perdiste...",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: gainPositive ? Colors.green : Colors.red,
                  ),
                ),
                const SizedBox(height: 10),
                Icon(
                  gainPositive ? Icons.trending_up : Icons.trending_down,
                  color: gainPositive ? Colors.green : Colors.red,
                  size: 80,
                ),
                const SizedBox(height: 20),

                // Monto final
                Text("💰 Capital final", style: const TextStyle(fontSize: 18)),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      format.format(widget.outcome.finalAmount),
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: gainPositive ? Colors.green : Colors.red,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        getCurrencyLabel(widget.outcome.currency),
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // Tipo de cambio
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        const Text("💱 Tipo de Cambio"),
                        const SizedBox(height: 8),
                        Text("Compra: ${shownRate?.buy.toStringAsFixed(2)}"),
                        Text("Venta: ${shownRate?.sell.toStringAsFixed(2)}"),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Evento
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.event_note, color: Colors.blue),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          event.description,
                          style: const TextStyle(fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                ),

                const Spacer(),

                ElevatedButton.icon(
                  onPressed: () {
                    if (isLast) {
                      Navigator.popUntil(context, (route) => route.isFirst);
                    } else {
                      final nextBaseRate = event.occurred
                          ? event.newRate
                          : widget.response.baseRate;

                      final finalPen = widget.outcome.currency == 'USD'
                          ? widget.outcome.finalAmount * nextBaseRate!.buy
                          : widget.outcome.finalAmount;

                      final isUSD = widget.outcome.currency == 'USD';
                      final shownInitial = widget.game.initialCapitalPen;
                      final shownFinal = isUSD
                          ? widget.outcome.finalAmount * nextBaseRate!.buy
                          : widget.outcome.finalAmount;

                      final gain = shownFinal - shownInitial;
                      final result = gain >= 0 ? 'Ganancia' : 'Pérdida';

                      print("💼 moneda: ${widget.outcome.currency}");
                      print("💼 Capital inicial (PEN): $shownInitial");
                      print("💸 Capital final (PEN): $shownFinal");
                      print("💸 ganancia final (PEN): $gain");
                      print("📊 Resultado: $result");

                      final updatedGame = widget.game.copyWithNewCapital(
                        finalPen,
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
                              game: updatedGame,
                              roundIndex: widget.roundIndex + 1,
                            ),
                          ),
                        ),
                      );
                    }
                  },
                  icon: const Icon(Icons.arrow_forward),
                  label: Text(isLast ? 'Finalizar Juego' : 'Siguiente Ronda'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    textStyle: const TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
          ),

          // 🎉 Confetti Animation
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              numberOfParticles: 30,
              shouldLoop: false,
              colors: const [Colors.green, Colors.yellow, Colors.blue],
            ),
          ),
        ],
      ),
    );
  }
}
