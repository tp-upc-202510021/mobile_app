import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_app/features/friends/friend_cubit.dart';
import 'package:mobile_app/features/friends/friend_state.dart';
import 'package:mobile_app/features/game/presentation/loan/game_loan_cubit.dart';
import 'package:mobile_app/features/game/presentation/investment/investment_game_cubit.dart';
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
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Invitar a un amigo'),
        centerTitle: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
      ),
      body: BlocBuilder<FriendCubit, FriendState>(
        builder: (context, state) {
          if (state is FriendLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is FriendOnlyLoaded) {
            if (state.friends.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.sentiment_dissatisfied,
                      size: 80,
                      color: Colors.grey.shade400,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No tienes amigos aún 😢',
                      style: theme.textTheme.titleLarge!.copyWith(
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Invita amigos y gana recompensas',
                      style: theme.textTheme.bodyMedium!.copyWith(
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              );
            }
            return ListView.separated(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemCount: state.friends.length,
              itemBuilder: (context, index) {
                final friend = state.friends[index];
                return Card(
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  shadowColor: Colors.blue.withOpacity(0.3),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 14,
                    ),
                    leading: CircleAvatar(
                      radius: 26,
                      backgroundColor: Colors.blue.shade100,
                      child: Text(
                        friend.username.substring(0, 1).toUpperCase(),
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue.shade700,
                        ),
                      ),
                    ),
                    title: Text(
                      friend.username,
                      style: theme.textTheme.titleLarge!.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    trailing: ElevatedButton.icon(
                      onPressed: () async {
                        await showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            title: Text(
                              '¿A qué juego invitar a ${friend.username}?',
                              style: theme.textTheme.titleLarge,
                            ),
                            content: const Text(
                              'Selecciona el tipo de juego',
                              style: TextStyle(fontWeight: FontWeight.w500),
                            ),
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
                                    NotificationService.showLoadingToast(
                                      context,
                                    );
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
                                    NotificationService.showLoadingToast(
                                      context,
                                    );
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
                      icon: const Icon(Icons.send),
                      label: const Text('Invitar'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey.shade100,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 6,
                        shadowColor: Colors.grey.shade200,
                      ),
                    ),
                  ),
                );
              },
            );
          } else if (state is FriendError) {
            return Center(
              child: Text(
                'Error: ${state.message}',
                style: const TextStyle(
                  color: Colors.redAccent,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}
