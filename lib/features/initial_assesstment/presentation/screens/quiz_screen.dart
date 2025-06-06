import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:forui/forui.dart';
import 'package:mobile_app/app/main_menu_screen.dart';

class QuizScreen extends StatefulWidget {
  final String preference;
  const QuizScreen({super.key, required this.preference});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int currentQuestionIndex = 0;
  String? selectedAnswer;
  List<dynamic> questions = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadQuestions();
  }

  Future<void> loadQuestions() async {
    final String jsonString = await rootBundle.loadString(
      'assets/data/evaluation_questions.json',
    );
    final Map<String, dynamic> data = json.decode(jsonString);

    List<dynamic> allQuestions = data['questions'];

    List<dynamic> filteredQuestions = [];

    if (widget.preference == 'loans') {
      filteredQuestions = allQuestions.where((q) {
        final id = q['id'] as String;
        return id.startsWith('mat_') || id.startsWith('pres_');
      }).toList();
    } else if (widget.preference == 'investments') {
      filteredQuestions = allQuestions.where((q) {
        final id = q['id'] as String;
        return id.startsWith('mat_') || id.startsWith('inv_');
      }).toList();
    } else {
      // Por si acaso, si preference es otro valor, usa todo o vacío
      filteredQuestions = allQuestions;
    }

    setState(() {
      questions = filteredQuestions;
      isLoading = false;
    });
  }

  void _nextQuestion() {
    if (currentQuestionIndex < questions.length - 1) {
      setState(() {
        currentQuestionIndex++;
        selectedAnswer = null;
      });
    } else {
      print('Encuesta completada');
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const MainMenuScreen()),
        (Route<dynamic> route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const FScaffold(child: Center(child: CircularProgressIndicator()));
    }

    final question = questions[currentQuestionIndex];

    return FScaffold(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              question['question'],
              style: const TextStyle(fontSize: 20),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ...List<Widget>.from(
              question['options'].map<Widget>((option) {
                final isSelected = selectedAnswer == option['option'];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: FButton(
                    style: isSelected
                        ? FButtonStyle.primary
                        : FButtonStyle.secondary,
                    onPress: () {
                      setState(() {
                        selectedAnswer = option['option'];
                      });
                    },
                    child: Flexible(
                      child: Text(
                        option['text'],
                        softWrap: true,
                        overflow: TextOverflow.visible,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                );
              }),
            ),
            const SizedBox(height: 35),
            FButton(
              onPress: selectedAnswer != null ? _nextQuestion : null,
              child: Text(
                currentQuestionIndex < questions.length - 1
                    ? 'Siguiente'
                    : 'Finalizar',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
