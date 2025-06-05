import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:forui/forui.dart';
import 'package:mobile_app/features/learning_path/presentation/cubit/learning_path_cubit.dart';
import 'package:mobile_app/features/learning_path/presentation/screens/learning_path_screen.dart';
import 'package:mobile_app/features/learning_path/repositories/learning_path_repository.dart';
import 'package:mobile_app/features/learning_path/services/learning_path_service.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return FScaffold(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _HomeOption(
            icon: FIcons.graduationCap,
            label: 'Ruta de aprendizaje',
            onTap: () {
              // Aquí puedes navegar a la pantalla de Ruta de Aprendizaje
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => BlocProvider(
                    create: (_) => LearningPathCubit(
                      LearningPathRepository(LearningPathService()),
                    )..loadLearningPath(),
                    child: const LearningPathScreen(),
                  ),
                ),
              );
              print('Ir a Ruta de aprendizaje');
            },
          ),
          const SizedBox(height: 20),
          _HomeOption(
            icon: FIcons.gamepad2,
            label: 'Minijuego',
            onTap: () {
              print('Ir a Minijuego');
            },
          ),
          const SizedBox(height: 20),
          _HomeOption(
            icon: FIcons.bookCheck,
            label: 'Quizz',
            onTap: () {
              print('Ir a Quiz');
            },
          ),
        ],
      ),
    );
  }
}

class _HomeOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _HomeOption({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              offset: Offset(0, 2),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        child: Row(
          children: [
            Icon(icon, size: 40),
            const SizedBox(width: 16),
            Expanded(child: Text(label, style: const TextStyle(fontSize: 18))),
            const Icon(Icons.arrow_forward_ios),
          ],
        ),
      ),
    );
  }
}
