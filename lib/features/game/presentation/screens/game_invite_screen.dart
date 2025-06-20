import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_app/features/friends/friend_cubit.dart';
import 'package:mobile_app/features/friends/friend_state.dart';
import 'package:mobile_app/features/game/presentation/game_cubit.dart';
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
                      final confirmed = await showDialog<bool>(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: Text('¿Invitar a ${friend.username}?'),
                          actions: [
                            TextButton(
                              onPressed: () => {
                                Navigator.of(
                                  context,
                                  rootNavigator: true,
                                ).pop(),
                              },
                              child: const Text('No'),
                            ),
                            TextButton(
                              onPressed: () async {
                                Navigator.of(
                                  context,
                                  rootNavigator: true,
                                ).pop(); // Cierra el diálogo
                                try {
                                  print("confirmado");
                                  final response = await context
                                      .read<GameCubit>()
                                      .inviteToGame(friend.id);
                                  NotificationService.show(
                                    title: '✅ Exito',
                                    body: "Invitación enviada",
                                  );
                                } catch (e) {
                                  NotificationService.show(
                                    title: '❌ Error',
                                    body: e.toString(),
                                  );
                                }
                              },
                              child: const Text('Sí'),
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
