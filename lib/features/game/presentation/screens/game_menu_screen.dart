import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text(
          'Jugar y Aprender',
          style: TextStyle(
            fontFamily: 'Fredoka',
            fontWeight: FontWeight.bold,
            fontSize: 24,
            letterSpacing: 1.2,
            color: Color.fromARGB(255, 33, 32, 32),
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 30),
              // Animated money bag (bigger)
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.0, end: 1.0),
                duration: const Duration(seconds: 1),
                curve: Curves.elasticOut,
                builder: (context, value, child) {
                  return Transform.translate(
                    offset: Offset(0, -40 * (1 - value)),
                    child: Transform.scale(
                      scale: 0.8 + 0.4 * value,
                      child: child,
                    ),
                  );
                },
                child: Image.asset(
                  'assets/images/money-bag.png',
                  width: 340,
                  height: 340,
                ),
              ),
              const SizedBox(height: 30),
              // Fun title
              const Text(
                '¡Bienvenido al reto financiero!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Fredoka',
                  fontWeight: FontWeight.bold,
                  fontSize: 26,
                  color: Colors.blueAccent,
                  shadows: [
                    Shadow(
                      blurRadius: 8,
                      color: Colors.white70,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              // Play button
              SizedBox(
                width: 240,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    foregroundColor: Colors.white,
                    elevation: 8,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    shadowColor: Colors.blueAccent.shade100,
                    textStyle: const TextStyle(
                      fontFamily: 'Fredoka',
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 18),
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
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.sports_esports, size: 28),
                      SizedBox(width: 12),
                      Text('¡Jugar ahora!'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 18),
              // Instructions button
              SizedBox(
                width: 240,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    backgroundColor: Colors.blueAccent.withOpacity(0.08),
                    foregroundColor: Colors.blueAccent,
                    side: const BorderSide(color: Colors.blueAccent, width: 2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    textStyle: const TextStyle(
                      fontFamily: 'Fredoka',
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  onPressed: () {
                    // Navegación a instrucciones
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.menu_book, size: 24),
                      SizedBox(width: 10),
                      Text('Ver instrucciones'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
