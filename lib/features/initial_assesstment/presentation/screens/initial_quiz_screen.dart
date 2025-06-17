import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:forui/forui.dart';
import 'package:mobile_app/features/initial_assesstment/models/initial_assestment_model.dart';

import 'package:mobile_app/features/initial_assesstment/presentation/cubit/initial_assestment_cubit.dart';
import 'package:mobile_app/features/initial_assesstment/presentation/screens/assestment_loading_screen.dart';
import 'package:mobile_app/features/initial_assesstment/repositories/initial_assestment_repository.dart';

import 'package:mobile_app/features/initial_assesstment/services/initial_assestment_service.dart';

class InitialQuizScreen extends StatefulWidget {
  final String preference;
  final InitialAssessmentResult result;

  const InitialQuizScreen({
    super.key,
    required this.preference,
    required this.result,
  });

  @override
  State<InitialQuizScreen> createState() => _InitialQuizScreenState();
}

class _InitialQuizScreenState extends State<InitialQuizScreen> {
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
    final question = questions[currentQuestionIndex];
    final selectedModules =
        question['answers'][selectedAnswer]['assigned_modules'];

    widget.result.addModules(selectedModules);

    if (currentQuestionIndex < questions.length - 1) {
      setState(() {
        currentQuestionIndex++;
        selectedAnswer = null;
      });
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => AssessmentCubit(
              repository: AssessmentRepository(service: AssessmentService()),
            ),
            child: AssessmentLoadingScreen(result: widget.result),
          ),
        ),
      );
    }
  }

  Widget _buildProgressIndicators() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(questions.length, (index) {
        final isCurrent = index == currentQuestionIndex;
        final isCompleted = index < currentQuestionIndex;

        Color color;
        if (isCurrent) {
          color = Colors.blueAccent;
        } else if (isCompleted) {
          color = Colors.green;
        } else {
          color = Colors.grey.shade300;
        }

        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.black12),
          ),
        );
      }),
    );
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
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildProgressIndicators(),
            const SizedBox(height: 24),
            Text(
              question['question_text'],
              style: const TextStyle(fontSize: 20),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ...answers.entries.map((entry) {
              final optionKey = entry.key;
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
