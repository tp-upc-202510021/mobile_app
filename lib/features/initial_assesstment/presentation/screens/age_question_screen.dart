import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:mobile_app/features/initial_assesstment/presentation/screens/quiz_screen.dart';

class AgeQuestionScreen extends StatefulWidget {
  const AgeQuestionScreen({super.key});

  @override
  State<AgeQuestionScreen> createState() => _AgeQuestionScreenState();
}

class _AgeQuestionScreenState extends State<AgeQuestionScreen> {
  final _ageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return FScaffold(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Builder(
          builder: (contextInside) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  '¿Cuántos años tienes?',
                  style: TextStyle(fontSize: 20),
                ),
                const SizedBox(height: 20),
                FTextField(
                  controller: _ageController,
                  hint: 'Ej. 25',
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 24),
                FButton(
                  onPress: () {
                    final age = int.tryParse(_ageController.text);
                    if (age != null && age > 0) {
                      Navigator.push(
                        contextInside,
                        MaterialPageRoute(
                          builder: (_) => QuizScreen(userAge: age),
                        ),
                      );
                    } else {
                      showFToast(
                        context: contextInside,
                        title: const Text('Edad inválida'),
                        description: const Text(
                          'Por favor, introduce un número valido',
                        ),
                        alignment: FToastAlignment.bottomCenter,
                      );
                    }
                  },
                  child: const Text('Siguiente'),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
