import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:mobile_app/features/initial_assesstment/presentation/screens/tone_response_screen.dart';

class IntroScreen extends StatelessWidget {
  final String preference;
  const IntroScreen({super.key, required this.preference});

  void _startAssessment(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ToneSelectionScreen(preference: preference),
      ),
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
