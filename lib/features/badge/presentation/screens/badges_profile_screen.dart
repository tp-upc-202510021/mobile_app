import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:forui/forui.dart';
import 'package:mobile_app/features/badge/data/badge_model.dart';
import 'package:mobile_app/features/badge/presentation/badge_cubit.dart';
import 'package:mobile_app/features/badge/presentation/badge_state.dart';

class BadgeScreen extends StatelessWidget {
  const BadgeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mis Logros')),
      body: BlocBuilder<BadgeCubit, BadgeState>(
        builder: (context, state) {
          if (state is BadgeLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is BadgeLoaded) {
            final badges = state.badges;

            if (badges.isEmpty) {
              return const Center(child: Text('Aún no tienes logros 😅'));
            }

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Wrap(
                spacing: 16,
                runSpacing: 16,
                children: badges.map((badge) {
                  return GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (_) => _buildBadgeDialog(context, badge),
                      );
                    },
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: Colors.blue.withOpacity(0.1),
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.blue, width: 2),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 6,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.emoji_events,
                            size: 40,
                            color: Colors.blue,
                          ),
                        ),
                        const SizedBox(height: 9),
                        FBadge(
                          style: FBadgeStyle.secondary,
                          child: Text(
                            badge.name,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            );
          } else if (state is BadgeError) {
            return Center(child: Text(state.message));
          } else {
            return const SizedBox();
          }
        },
      ),
    );
  }

  Widget _buildBadgeDialog(BuildContext context, BadgeModel badge) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Text(
        badge.name,
        style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.emoji_events, size: 60, color: Colors.amber),
          const SizedBox(height: 16),
          Text(
            badge.badgeDescription,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 14),
          ),
          const SizedBox(height: 20),
          Text(
            'Desbloqueado el:\n',
            style: const TextStyle(fontSize: 12, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 1),
          Text(
            _formatDate(badge.dateUnlocked),
            style: const TextStyle(fontSize: 12, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
        ],
      ),
      actions: [
        TextButton(
          child: const Text('Cerrar'),
          onPressed: () => Navigator.of(
            context,
            rootNavigator: true,
          ).pop(), // Cierra el diálogo
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year}';
  }
}
