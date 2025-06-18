import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_app/features/friends/data/friend_model.dart';
import 'package:mobile_app/features/friends/data/friend_request_model.dart';
import 'package:mobile_app/features/friends/friend_cubit.dart';
import 'package:mobile_app/features/friends/friend_state.dart';

class FriendsScreen extends StatefulWidget {
  const FriendsScreen({super.key});

  @override
  State<FriendsScreen> createState() => _FriendsScreenState();
}

class _FriendsScreenState extends State<FriendsScreen> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<FriendCubit>().loadFriendsAndRequests();
  }

  void _sendRequest() {
    final id = int.tryParse(_controller.text);
    if (id != null) {
      context.read<FriendCubit>().sendRequest(id);
      _controller.clear();
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Ingresa un ID válido')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Amigos"), centerTitle: true),

      body: BlocBuilder<FriendCubit, FriendState>(
        builder: (context, state) {
          List<Friend> friends = [];
          List<FriendRequest> pending = [];

          if (state is FriendLoaded) {
            friends = state.friends;
            pending = state.pendingRequests;
            print('Friends loaded: ${friends.length}');
          } else if (state is FriendError) {
            return Center(child: Text(state.message));
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Agregar amigo",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 15),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: 'ID del amigo',
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: _sendRequest,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue[300],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: const Text("Enviar "),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                /// 🕒 Solicitudes pendientes
                if (pending.isNotEmpty) ...[
                  const Text(
                    "Solicitudes pendientes",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  ...pending.map(
                    (request) => Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      color: Colors.white,
                      child: ListTile(
                        title: Text(request.requesterName),
                        subtitle: Text('Solicitud de amistad'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(
                                Icons.check_circle,
                                color: Colors.green,
                              ),
                              onPressed: () {
                                context.read<FriendCubit>().respondRequest(
                                  request.friendshipId,
                                  'accepted',
                                );
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.cancel, color: Colors.red),
                              onPressed: () {
                                context.read<FriendCubit>().respondRequest(
                                  request.friendshipId,
                                  'rejected',
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),
                ],

                /// 👥 Lista de amigos
                const Text(
                  "Mis amigos",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                if (friends.isEmpty)
                  const Text(
                    "Aún no tienes amigos.",
                    style: TextStyle(color: Colors.grey),
                  ),
                ...friends.map(
                  (friend) => Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    color: Colors.white,
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.green[200],
                        child: Text(friend.username[0].toUpperCase()),
                      ),
                      title: Text(friend.username),
                      subtitle: Text(friend.email),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
