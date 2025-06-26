import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_app/features/game/data/investment/game_data_investment_model.dart';
import 'package:mobile_app/features/game/presentation/investment/investment_game_cubit.dart';
import 'package:mobile_app/features/game/presentation/investment/investment_game_state.dart';
import 'package:mobile_app/features/game/presentation/investment/screens/investment_game_result.dart';

class InvestmentGameRoundScreen extends StatelessWidget {
  final GameInvestmentData game;
  final int roundIndex;

  const InvestmentGameRoundScreen({
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
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              round.fxEvent.eventDescription,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            const Text(
              'Opciones de inversión:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: round.options.length,
                itemBuilder: (_, i) {
                  final option = round.options[i];
                  return Card(
                    child: ListTile(
                      title: Text(option.title),
                      subtitle: Text(option.description),
                      onTap: () async {
                        await context
                            .read<InvestmentGameCubit>()
                            .applyExchangeEvent({
                              "current_change_to_buy": game.baseFxRate.buy,
                              "current_change_to_sell": game.baseFxRate.sell,
                              "probability_to_change":
                                  round.fxEvent.probabilityToChange,
                              "type_of_change": round.fxEvent.typeOfChange,
                              "percentage_of_variation":
                                  round.fxEvent.percentageOfVariation,
                              "event": round.fxEvent.eventDescription,
                            });

                        final state = context.read<InvestmentGameCubit>().state;

                        if (state is InvestmentGameError) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(state.message)),
                          );
                          return;
                        }

                        if (state is ExchangeEventApplied) {
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
                                  game: game,
                                  roundIndex: roundIndex,
                                  option: option,
                                  response: state.response,
                                ),
                              ),
                            ),
                          );
                        }
                      },
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
