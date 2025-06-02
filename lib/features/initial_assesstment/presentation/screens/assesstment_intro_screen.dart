import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:mobile_app/features/initial_assesstment/presentation/screens/age_question_screen.dart';
//import 'question_screen.dart'; // Asegúrate de crear esta luego

class IntroScreen extends StatelessWidget {
  const IntroScreen({super.key});

  void _startAssessment(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const AgeQuestionScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FScaffold(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Evaluación Inicial',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              const Text(
                'Antes de comenzar, necesitamos conocerte un poco mejor para brindarte una experiencia más personalizada.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              FButton(
                onPress: () => _startAssessment(context),
                child: const Text('Empezar evaluación'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
