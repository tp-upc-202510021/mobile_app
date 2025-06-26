import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mobile_app/features/friends/data/friend_repository.dart';
import 'package:mobile_app/features/friends/data/friend_service.dart';
import 'package:mobile_app/features/friends/friend_cubit.dart';
import 'package:mobile_app/features/game/data/investment/game_investment_repository.dart';
import 'package:mobile_app/features/game/data/investment/game_investment_service.dart';
import 'package:mobile_app/features/game/data/loan/game_loan_repository.dart';
import 'package:mobile_app/features/game/data/loan/game_loan_service.dart';
import 'package:mobile_app/features/game/presentation/investment/investment_game_cubit.dart';
import 'package:mobile_app/features/game/presentation/loan/game_loan_cubit.dart';

import 'package:mobile_app/features/game/presentation/screens/game_invite_screen.dart';

class GameMenuScreen extends StatelessWidget {
  const GameMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Jugar y Aprender'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 40),
            SizedBox(
              height: 250,
              child: SvgPicture.asset(
                'assets/images/game_menu.svg',
                fit: BoxFit.contain,
              ),
            ),

            const SizedBox(height: 40),

            // Botón Jugar
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                label: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 14),
                  child: Text(
                    '🎮 Empezar Juego',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 4,
                ),
                onPressed: () {
                  final friendService = FriendService();
                  final friendRepository = FriendRepository(friendService);
                  final friendCubit = FriendCubit(friendRepository);

                  final loanGameService = LoanGameService();
                  final loanGameRepository = LoanGameRepository(
                    loanGameService,
                  );
                  final loanGameCubit = GameLoanCubit(loanGameRepository);

                  final investmentGameService = InvestmentGameService();
                  final investmentGameRepository = InvestmentGameRepository(
                    service: investmentGameService,
                  );
                  final investmentGameCubit = InvestmentGameCubit(
                    investmentGameRepository,
                  );

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => MultiBlocProvider(
                        providers: [
                          BlocProvider.value(value: friendCubit),
                          BlocProvider.value(value: loanGameCubit),
                          BlocProvider.value(value: investmentGameCubit),
                        ],
                        child: const InviteFriendScreen(),
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 16),

            // Botón Instrucciones
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                label: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 14),
                  child: Text(
                    '📘 Ver instrucciones',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  // Navegación a instrucciones
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
