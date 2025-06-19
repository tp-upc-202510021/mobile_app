// game_entry_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_app/features/game/data/game_repository.dart';
import 'package:mobile_app/features/game/data/game_service.dart';

import 'package:mobile_app/features/game/presentation/game_cubit.dart';
import 'package:mobile_app/features/game/presentation/rate_event_cubit.dart';
import 'package:mobile_app/features/game/presentation/screens/game_round_screen.dart';

class GameEntryScreen extends StatelessWidget {
  const GameEntryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GameCubit(GameRepository(GameService()))..loadGame(),
      child: Scaffold(
        body: Center(
          child: BlocConsumer<GameCubit, GameState>(
            listener: (context, state) {
              if (state is GameLoaded) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) => MultiBlocProvider(
                      providers: [
                        BlocProvider.value(
                          value: context
                              .read<GameCubit>(), // reutilizas GameCubit
                        ),
                        BlocProvider(
                          create: (_) =>
                              RateEventCubit(GameRepository(GameService())),
                        ),
                      ],
                      child: GameRoundScreen(game: state.game, roundIndex: 0),
                    ),
                  ),
                );
              }
            },
            builder: (context, state) {
              if (state is GameLoading || state is GameInitial) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text("Espera, estamos creando el juego..."),
                  ],
                );
              } else if (state is GameError) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error, color: Colors.red, size: 48),
                    const SizedBox(height: 16),
                    Text(state.message),
                  ],
                );
              } else {
                return const SizedBox.shrink();
              }
            },
          ),
        ),
      ),
    );
  }
}
