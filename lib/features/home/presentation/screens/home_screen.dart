import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:forui/forui.dart';
import 'package:mobile_app/features/authentication/presentation/cubit/auth_cubit.dart';
import 'package:mobile_app/features/game/data/loan/game_repository.dart';
import 'package:mobile_app/features/game/data/loan/game_service.dart';
import 'package:mobile_app/features/game/presentation/loan/game_loan_cubit.dart';
import 'package:mobile_app/features/game/presentation/screens/game_entry_screen.dart';
import 'package:mobile_app/features/game/presentation/screens/game_invite_screen.dart';
import 'package:mobile_app/features/game/presentation/screens/game_menu_screen.dart';
import 'package:mobile_app/features/learning_path/presentation/cubit/learning_path_cubit.dart';
import 'package:mobile_app/features/learning_path/presentation/screens/learning_path_screen.dart';
import 'package:mobile_app/features/learning_path/repositories/learning_path_repository.dart';
import 'package:mobile_app/features/learning_path/services/learning_path_service.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // decoration: const BoxDecoration(
        //   gradient: LinearGradient(
        //     colors: [Color(0xFFEEF2F3), Color(0xFFEEF2F3), Color(0xFF8EC5FC)],
        //     begin: Alignment.topLeft,
        //     end: Alignment.bottomRight,
        //   ),
        // ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Spacer(),
                const Text(
                  '¡Bienvenido!',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),

                const SizedBox(height: 8),
                const Text(
                  '¿Qué deseas hacer hoy?',
                  style: TextStyle(fontSize: 18, color: Colors.black54),
                ),
                const SizedBox(height: 40),
                _AnimatedHomeOption(
                  icon: FIcons.graduationCap,
                  label: 'Explorar Ruta de Aprendizaje',
                  subtitle: 'Avanza paso a paso en tu camino financiero',
                  color: Colors.deepPurpleAccent,
                  onTap: () {
                    context.read<AuthCubit>().webSocketService.simulateToast();
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
                  },
                ),
                const SizedBox(height: 20),
                _AnimatedHomeOption(
                  icon: FIcons.gamepad2,
                  label: 'Jugar Minijuego',
                  subtitle: 'Pon a prueba tus conocimientos con diversión',
                  color: Colors.orangeAccent,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const GameMenuScreen()),
                    );
                  },
                ),
                Spacer(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _AnimatedHomeOption extends StatefulWidget {
  final IconData icon;
  final String label;
  final String subtitle;
  final VoidCallback onTap;
  final Color color;

  const _AnimatedHomeOption({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.onTap,
    required this.color,
  });

  @override
  State<_AnimatedHomeOption> createState() => _AnimatedHomeOptionState();
}

class _AnimatedHomeOptionState extends State<_AnimatedHomeOption>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _scaleAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutBack,
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: GestureDetector(
        onTap: widget.onTap,
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: widget.color.withOpacity(0.3),
                blurRadius: 10,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: widget.color.withOpacity(0.1),
                radius: 30,
                child: Icon(widget.icon, size: 30, color: widget.color),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.label,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.subtitle,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, size: 16),
            ],
          ),
        ),
      ),
    );
  }
}
