import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_app/features/game/data/investment/game_data_investment_model.dart';
import 'package:mobile_app/features/game/data/investment/investment_calc.dart';
import 'package:mobile_app/features/game/presentation/investment/investment_game_cubit.dart';
import 'package:mobile_app/features/game/presentation/investment/investment_game_state.dart';
import 'package:mobile_app/features/game/presentation/investment/screens/investment_game_result.dart';

class InvestmentGameRoundScreen extends StatefulWidget {
  final GameInvestmentData game;
  final int roundIndex;

  const InvestmentGameRoundScreen({
    super.key,
    required this.game,
    required this.roundIndex,
  });

  @override
  State<InvestmentGameRoundScreen> createState() =>
      _InvestmentGameRoundScreenState();
}

class _InvestmentGameRoundScreenState extends State<InvestmentGameRoundScreen> {
  InvestmentOption? _selectedOption;

  void _handleTapOption(BuildContext context, InvestmentOption option) {
    final round = widget.game.rounds[widget.roundIndex];

    setState(() {
      _selectedOption = option;
    });

    context.read<InvestmentGameCubit>().applyExchangeEvent({
      "current_change_to_buy": widget.game.baseFxRate.buy,
      "current_change_to_sell": widget.game.baseFxRate.sell,
      "probability_to_change": round.fxEvent.probabilityToChange,
      "type_of_change": round.fxEvent.typeOfChange,
      "percentage_of_variation": round.fxEvent.percentageOfVariation,
      "event": round.fxEvent.eventDescription,
    });
  }

  Color _riskColor(RiskLevel risk) {
    switch (risk) {
      case RiskLevel.low:
        return Colors.green.shade100;
      case RiskLevel.medium:
        return Colors.orange.shade100;
      case RiskLevel.high:
        return Colors.red.shade100;
    }
  }

  IconData _riskIcon(RiskLevel risk) {
    switch (risk) {
      case RiskLevel.low:
        return Icons.shield;
      case RiskLevel.medium:
        return Icons.warning;
      case RiskLevel.high:
        return Icons.whatshot;
    }
  }

  @override
  Widget build(BuildContext context) {
    final round = widget.game.rounds[widget.roundIndex];

    return Scaffold(
      appBar: AppBar(title: Text('🧩 Ronda ${round.round}')),
      body: BlocListener<InvestmentGameCubit, InvestmentGameState>(
        listener: (context, state) {
          if (state is InvestmentGameError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }

          if (state is ExchangeEventApplied && _selectedOption != null) {
            final outcome = computeOutcome(
              initialPen: widget.game.initialCapitalPen,
              option: _selectedOption!,
              fx: state.response.event.newRate ?? state.response.baseRate,
              durationM: round.investmentDurationMonths,
            );

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => MultiBlocProvider(
                  providers: [
                    BlocProvider.value(
                      value: context.read<InvestmentGameCubit>(),
                    ),
                  ],
                  child: InvestmentGameResultScreen(
                    game: widget.game,
                    roundIndex: widget.roundIndex,
                    option: _selectedOption!,
                    response: state.response,
                    outcome: outcome,
                  ),
                ),
              ),
            );
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // 💰 Capital actual
              Card(
                color: Colors.lightBlue.shade50,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      const Icon(Icons.wallet, color: Colors.blue),
                      const SizedBox(width: 10),
                      Text(
                        'Capital disponible: S/ ${widget.game.initialCapitalPen.toStringAsFixed(2)}',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // 🎯 Evento
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.yellow.shade100,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.flash_on, color: Colors.orange),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        round.fxEvent.eventDescription,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // 🎯 Opciones
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Elige tu inversión:',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: Expanded(
                  child: Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                          itemCount: round.options.length,
                          itemBuilder: (_, i) {
                            final option = round.options[i];
                            final selected = _selectedOption == option;

                            return Container(
                              margin: const EdgeInsets.symmetric(
                                vertical: 8,
                                horizontal: 4,
                              ),
                              child: AnimatedScale(
                                duration: const Duration(milliseconds: 200),
                                scale: selected ? 1.02 : 1.0,
                                child: Material(
                                  color: _riskColor(option.riskLevel),
                                  elevation: selected ? 6 : 2,
                                  borderRadius: BorderRadius.circular(16),
                                  child: InkWell(
                                    onTap: () => setState(
                                      () => _selectedOption = option,
                                    ),
                                    borderRadius: BorderRadius.circular(16),
                                    splashColor: Colors.blue.withOpacity(0.2),
                                    highlightColor: Colors.blue.withOpacity(
                                      0.1,
                                    ),
                                    child: Container(
                                      padding: const EdgeInsets.all(16),
                                      child: Row(
                                        children: [
                                          Icon(
                                            _riskIcon(option.riskLevel),
                                            size: 28,
                                            color: Colors.black87,
                                          ),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  option.title,
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16,
                                                  ),
                                                ),
                                                const SizedBox(height: 4),
                                                Text(option.description),
                                                const SizedBox(height: 6),
                                                Row(
                                                  children: [
                                                    Text(
                                                      "📈 ${option.expectedReturnPct}%  ",
                                                    ),
                                                    Text(
                                                      "💱 ${option.currency}",
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                          if (selected)
                                            const Icon(
                                              Icons.check_circle,
                                              color: Colors.blue,
                                              size: 28,
                                            ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),

                      // ✅ Botón de confirmar
                      const SizedBox(height: 16),
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        child: _selectedOption == null
                            ? const SizedBox.shrink()
                            : ElevatedButton.icon(
                                key: const ValueKey("confirm_button"),
                                onPressed: () {
                                  final round =
                                      widget.game.rounds[widget.roundIndex];

                                  context
                                      .read<InvestmentGameCubit>()
                                      .applyExchangeEvent({
                                        "current_change_to_buy":
                                            widget.game.baseFxRate.buy,
                                        "current_change_to_sell":
                                            widget.game.baseFxRate.sell,
                                        "probability_to_change":
                                            round.fxEvent.probabilityToChange,
                                        "type_of_change":
                                            round.fxEvent.typeOfChange,
                                        "percentage_of_variation":
                                            round.fxEvent.percentageOfVariation,
                                        "event": round.fxEvent.eventDescription,
                                      });
                                },
                                icon: const Icon(Icons.check),
                                label: const Text("Confirmar Inversión"),
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 24,
                                    vertical: 12,
                                  ),
                                  textStyle: const TextStyle(fontSize: 16),
                                ),
                              ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
