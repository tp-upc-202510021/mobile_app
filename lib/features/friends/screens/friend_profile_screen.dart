import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_app/features/friends/friend_cubit.dart';
import 'package:mobile_app/features/friends/friend_profile_state.dart';
import 'package:mobile_app/features/friends/friend_state.dart';

class FriendProfileScreen extends StatefulWidget {
  final int friendId;

  const FriendProfileScreen({super.key, required this.friendId});

  @override
  State<FriendProfileScreen> createState() => _FriendProfileScreenState();
}

class _FriendProfileScreenState extends State<FriendProfileScreen> {
  @override
  void initState() {
    super.initState();
    context.read<FriendCubit>().loadFriendProfile(widget.friendId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Perfil del Amigo')),
      body: BlocBuilder<FriendCubit, FriendState>(
        builder: (context, state) {
          if (state is FriendProfileLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is FriendProfileError) {
            return Center(child: Text(state.message));
          } else if (state is FriendProfileLoaded) {
            final profile = state.profile;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  /// 💚 HEADER
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.green.shade100,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 40,
                          backgroundColor: Colors.green.shade400,
                          child: Text(
                            profile.name[0].toUpperCase(),
                            style: const TextStyle(
                              fontSize: 32,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          profile.name,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                        ),
                        Text(
                          profile.email,
                          style: const TextStyle(color: Colors.black54),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  /// 📋 INFO
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 3,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _infoRow("👶 Edad", "${profile.age} años"),
                          _infoRow("💼 Preferencia", profile.preference),
                          _infoRow(
                            "📅 Se unió",
                            "${profile.dateJoined.day}/${profile.dateJoined.month}/${profile.dateJoined.year}",
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  /// 🏅 INSIGNIAS
                  const Text(
                    '🏆 Insignias desbloqueadas',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  if (profile.badges.isEmpty)
                    const Text("No tiene insignias aún 😔"),
                  ...profile.badges.map((badge) {
                    return Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: ListTile(
                        leading: const Icon(
                          Icons.emoji_events,
                          color: Colors.amber,
                          size: 30,
                        ),
                        title: Text(badge.name),
                        subtitle: Text(badge.userDescription),
                        trailing: Text("🎯", style: TextStyle(fontSize: 24)),
                      ),
                    );
                  }),
                ],
              ),
            );
          } else {
            return const Center(child: Text("Cargando perfil..."));
          }
        },
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Text(
            "$label: ",
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.black87,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 16, color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }
}
