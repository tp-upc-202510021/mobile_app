import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_app/features/friends/data/friend_repository.dart';
import 'package:mobile_app/features/friends/data/friend_service.dart';
import 'package:mobile_app/features/friends/friend_cubit.dart';
import 'package:mobile_app/features/game/data/loan/game_repository.dart';
import 'package:mobile_app/features/game/data/loan/game_service.dart';
import 'package:mobile_app/features/game/presentation/loan/game_loan_cubit.dart';

import 'package:mobile_app/features/game/presentation/screens/game_invite_screen.dart';

class GameMenuScreen extends StatelessWidget {
  const GameMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Jugar y Aprender')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              onPressed: () {
                final friendService = FriendService();
                final friendRepository = FriendRepository(friendService);
                final friendCubit = FriendCubit(friendRepository);

                final gameService = LoanGameService();
                final gameRepository = LoanGameRepository(gameService);
                final gameCubit = GameCubit(gameRepository);

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => MultiBlocProvider(
                      providers: [
                        BlocProvider.value(value: friendCubit),
                        BlocProvider.value(value: gameCubit),
                      ],
                      child: const InviteFriendScreen(),
                    ),
                  ),
                );
              },

              child: const Text('🎮 Empezar Juego'),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () {
                // Aquí iría navegación a instrucciones si quieres
              },
              child: const Text('📘 Ver instrucciones'),
            ),
          ],
        ),
      ),
    );
  }
}
