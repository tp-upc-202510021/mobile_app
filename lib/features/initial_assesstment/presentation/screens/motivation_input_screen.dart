import 'package:flutter/material.dart';
import 'package:mobile_app/features/initial_assesstment/models/initial_assestment_model.dart';
import 'initial_quiz_screen.dart';

class MotivationInputScreen extends StatefulWidget {
  final InitialAssessmentResult result;
  final String preference;

  const MotivationInputScreen({
    super.key,
    required this.result,
    required this.preference,
  });

  @override
  State<MotivationInputScreen> createState() => _MotivationInputScreenState();
}

class _MotivationInputScreenState extends State<MotivationInputScreen> {
  final TextEditingController _controller = TextEditingController();
  bool isButtonEnabled = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_handleTextChange);
  }

  void _handleTextChange() {
    setState(() {
      isButtonEnabled = _controller.text.trim().isNotEmpty;
    });
  }

  @override
  void dispose() {
    _controller.removeListener(_handleTextChange);
    _controller.dispose();
    super.dispose();
  }

  void _goToQuiz() {
    widget.result.motivation = _controller.text.trim();

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => InitialQuizScreen(
          result: widget.result,
          preference: widget.preference,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  '¿Cuál es tu principal expectativa al usar esta aplicación? ¿Qué enfoque te mantendrá más motivado a aprender?',
                  style: TextStyle(fontSize: 18),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                TextField(
                  controller: _controller,
                  maxLines: 5,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Escribe tu respuesta aquí...',
                  ),
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: isButtonEnabled ? _goToQuiz : null,
                  child: const Text('Siguiente'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
