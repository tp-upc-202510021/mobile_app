import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_app/features/friends/friend_cubit.dart';
import 'package:mobile_app/features/friends/friend_state.dart';
import 'package:mobile_app/features/game/presentation/loan/game_loan_cubit.dart';
import 'package:mobile_app/features/game/presentation/investment/investment_game_cubit.dart';
import 'package:mobile_app/main.dart';
import 'package:mobile_app/shared/notification_service.dart';

class InviteFriendScreen extends StatefulWidget {
  const InviteFriendScreen({super.key});

  @override
  State<InviteFriendScreen> createState() => _InviteFriendScreenState();
}

class _InviteFriendScreenState extends State<InviteFriendScreen> {
  @override
  void initState() {
    super.initState();
    context.read<FriendCubit>().loadFriends();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Invitar a un amigo')),
      body: BlocBuilder<FriendCubit, FriendState>(
        builder: (context, state) {
          if (state is FriendLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is FriendOnlyLoaded) {
            if (state.friends.isEmpty) {
              return const Center(child: Text('No tienes amigos aún 😢'));
            }
            return ListView.builder(
              itemCount: state.friends.length,
              itemBuilder: (context, index) {
                final friend = state.friends[index];
                return ListTile(
                  leading: const Icon(Icons.person),
                  title: Text(friend.username),
                  trailing: IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: () async {
                      await showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: Text(
                            '¿A qué juego invitar a ${friend.username}?',
                          ),
                          content: const Text('Selecciona el tipo de juego'),
                          actions: [
                            TextButton(
                              onPressed: () async {
                                Navigator.of(
                                  context,
                                  rootNavigator: true,
                                ).pop();
                                try {
                                  await context
                                      .read<GameLoanCubit>()
                                      .inviteToGame(friend.id);

                                  NotificationService.show(
                                    title: '✅ Éxito',
                                    body:
                                        'Invitación al juego de préstamos enviada',
                                  );
                                  NotificationService.showLoadingToast(context);
                                } catch (e) {
                                  NotificationService.show(
                                    title: '❌ Error',
                                    body: e.toString(),
                                  );
                                }
                              },
                              child: const Text('Préstamos'),
                            ),
                            TextButton(
                              onPressed: () async {
                                Navigator.of(
                                  context,
                                  rootNavigator: true,
                                ).pop();
                                try {
                                  await context
                                      .read<InvestmentGameCubit>()
                                      .inviteUser(friend.id);

                                  NotificationService.show(
                                    title: '✅ Éxito',
                                    body:
                                        'Invitación al juego de inversiones enviada',
                                  );
                                  NotificationService.showLoadingToast(context);
                                } catch (e) {
                                  NotificationService.show(
                                    title: '❌ Error',
                                    body: e.toString(),
                                  );
                                }
                              },
                              child: const Text('Inversiones'),
                            ),
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: const Text('Cancelar'),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                );
              },
            );
          } else if (state is FriendError) {
            return Center(child: Text('Error: ${state.message}'));
          }
          return const SizedBox();
        },
      ),
    );
  }
}
