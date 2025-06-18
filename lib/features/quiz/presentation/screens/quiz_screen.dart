import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:forui/forui.dart';
import 'package:mobile_app/features/learning_path/presentation/cubit/learning_path_cubit.dart';
import 'package:mobile_app/features/learning_path/presentation/screens/learning_path_screen.dart';
import 'package:mobile_app/features/learning_path/repositories/learning_path_repository.dart';
import 'package:mobile_app/features/learning_path/services/learning_path_service.dart';
import 'package:mobile_app/features/quiz/data/quiz_model.dart';
import 'package:mobile_app/features/quiz/presentation/quiz_cubit.dart';

class QuizScreen extends StatelessWidget {
  final int moduleId;

  const QuizScreen({Key? key, required this.moduleId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Quiz')),
      body: BlocListener<QuizCubit, QuizState>(
        listener: (context, state) {
          if (state is QuizSubmitted) {
            Future.microtask(() {
              showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  title: const Text('Resultado'),
                  content: Text(
                    'Respondiste ${state.score} preguntas correctamente.',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(
                          context,
                          rootNavigator: true,
                        ).pop(); // Cierra el diálogo

                        // Luego navegamos y eliminamos todo el historial
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (_) => BlocProvider(
                              create: (_) => LearningPathCubit(
                                LearningPathRepository(LearningPathService()),
                              )..loadLearningPath(),
                              child: const LearningPathScreen(),
                            ),
                          ),
                          (route) => route
                              .isFirst, // 🔥 Esto elimina todo el stack anterior
                        );
                      },

                      child: const Text('OK'),
                    ),
                  ],
                ),
              );
            });
          } else if (state is QuizError) {
            Future.microtask(() {
              showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  title: const Text('Error'),
                  content: Text(state.message),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Cerrar'),
                    ),
                  ],
                ),
              );
            });
          }
        },
        child: BlocBuilder<QuizCubit, QuizState>(
          builder: (_, state) {
            if (state is QuizLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is QuizLoaded ||
                state is QuizSubmitting ||
                state is QuizSubmitted) {
              final quiz = state is QuizLoaded
                  ? state.quiz
                  : (state is QuizSubmitting || state is QuizSubmitted)
                  ? context.read<QuizCubit>().quiz
                  : null;

              if (quiz == null) {
                return const Center(child: Text('No se encontró el quiz.'));
              }

              return QuizView(quiz: quiz);
            } else if (state is QuizError) {
              return Center(child: Text('Error: ${state.message}'));
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}

class QuizView extends StatefulWidget {
  final Quiz quiz;
  const QuizView({Key? key, required this.quiz}) : super(key: key);

  @override
  State<QuizView> createState() => _QuizViewState();
}

class _QuizViewState extends State<QuizView> {
  int currentIndex = 0;
  Map<int, int> answers = {};

  @override
  Widget build(BuildContext context) {
    final q = widget.quiz.questions[currentIndex];

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Pregunta ${currentIndex + 1}/${widget.quiz.totalQuestions}',
            style: const TextStyle(fontSize: 20),
          ),
          const SizedBox(height: 20),
          Text(q.text, style: const TextStyle(fontSize: 18)),
          const SizedBox(height: 20),
          ...q.answers.map((ans) {
            final selected = answers[q.questionId] == ans.answerId;
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: FButton(
                style: selected ? FButtonStyle.primary : FButtonStyle.secondary,
                intrinsicWidth: true,
                onPress: () {
                  setState(() => answers[q.questionId] = ans.answerId);
                },
                child: Flexible(
                  child: Text(
                    ans.text,
                    softWrap: true,
                    overflow: TextOverflow.visible,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            );
          }).toList(),

          const Spacer(),
          ElevatedButton(
            onPressed: answers[q.questionId] == null
                ? null
                : () {
                    final next = currentIndex + 1;
                    if (next < widget.quiz.totalQuestions) {
                      setState(() => currentIndex = next);
                    } else {
                      _submitResult();
                    }
                  },
            child: Text(
              currentIndex + 1 < widget.quiz.totalQuestions
                  ? 'Siguiente'
                  : 'Terminar',
            ),
          ),
        ],
      ),
    );
  }

  void _submitResult() {
    int correct = 0;
    for (var q in widget.quiz.questions) {
      final ansId = answers[q.questionId];
      if (ansId != null &&
          q.answers.firstWhere((a) => a.answerId == ansId).isCorrect) {
        correct++;
      }
    }

    print('✅ Enviando score: $correct');
    context.read<QuizCubit>().submitResult(
      quizId: widget.quiz.quizId,
      score: correct,
    );
  }
}
