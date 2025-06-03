import 'package:flutter/material.dart';
import 'package:forui/forui.dart';

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
