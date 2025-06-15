import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:forui/forui.dart';
import 'package:mobile_app/app/app_root.dart';
import 'package:mobile_app/features/authentication/presentation/cubit/auth_cubit.dart';

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
    String filePath;

    if (widget.preference == 'loans') {
      filePath = 'assets/data/loans_questions.json';
    } else if (widget.preference == 'investments') {
      filePath = 'assets/data/investments_questions.json';
    } else {
      // Opción por defecto si el valor de preference es inválido
      setState(() {
        isLoading = false;
        questions = [];
      });
      return;
    }

    try {
      final String jsonString = await rootBundle.loadString(filePath);
      final List<dynamic> loadedQuestions = json.decode(jsonString);

      setState(() {
        questions = loadedQuestions;
        isLoading = false;
      });
    } catch (e) {
      debugPrint('Error loading questions: $e');
      setState(() {
        questions = [];
        isLoading = false;
      });
    }
  }

  void _nextQuestion() {
    if (currentQuestionIndex < questions.length - 1) {
      setState(() {
        currentQuestionIndex++;
        selectedAnswer = null;
      });
    } else {
      print('Encuesta completada');
      context.read<AuthCubit>().checkAuthStatus();
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const AppRoot()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const FScaffold(child: Center(child: CircularProgressIndicator()));
    }

    if (questions.isEmpty) {
      return const FScaffold(
        child: Center(child: Text('No se encontraron preguntas.')),
      );
    }

    final question = questions[currentQuestionIndex];
    final Map<String, dynamic> answers = question['answers'];

    return FScaffold(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              question['question_text'],
              style: const TextStyle(fontSize: 20),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),

            // Renderiza las opciones a, b, c, d
            ...answers.entries.map((entry) {
              final optionKey = entry.key; // "a", "b", etc.
              final answerText = entry.value['answer_text'];
              final isSelected = selectedAnswer == optionKey;

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: FButton(
                  style: isSelected
                      ? FButtonStyle.primary
                      : FButtonStyle.secondary,
                  onPress: () {
                    setState(() {
                      selectedAnswer = optionKey;
                    });
                  },
                  child: Flexible(
                    child: Text(
                      answerText,
                      softWrap: true,
                      overflow: TextOverflow.visible,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              );
            }),

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
