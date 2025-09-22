import 'package:flutter/material.dart';
import '../cubit/feedback_cubit.dart';
import '../../domain/entities/feedback_entities.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FeedbackDialog extends StatefulWidget {
  final int moduleId;
  final void Function()? onSubmitted;
  const FeedbackDialog({Key? key, required this.moduleId, this.onSubmitted})
    : super(key: key);

  @override
  State<FeedbackDialog> createState() => _FeedbackDialogState();
}

class _FeedbackDialogState extends State<FeedbackDialog> {
  final Map<int, dynamic> _answers = {};
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    context.read<FeedbackCubit>().loadQuestions();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: BlocConsumer<FeedbackCubit, FeedbackState>(
        listener: (context, state) {
          if (state is FeedbackSubmitted) {
            Navigator.of(context).pop();
            if (widget.onSubmitted != null) widget.onSubmitted!();
          }
        },
        builder: (context, state) {
          if (state is FeedbackLoading || state is FeedbackInitial) {
            return SizedBox(
              height: 220,
              child: Center(child: CircularProgressIndicator()),
            );
          }
          if (state is FeedbackLoaded) {
            final questions = state.questions;
            final q = questions[_currentIndex];
            final isLast = _currentIndex == questions.length - 1;
            return Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Ayúdanos a mejorar',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  const SizedBox(height: 12),
                  _buildQuestion(q),
                  const SizedBox(height: 18),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      if (!isLast)
                        ElevatedButton(
                          onPressed: _answers[q.id] != null
                              ? () => setState(() => _currentIndex++)
                              : null,
                          child: const Text('Siguiente'),
                        ),
                      if (isLast)
                        ElevatedButton(
                          onPressed:
                              _answers.length == questions.length &&
                                  !_answers.values.contains(null)
                              ? () {
                                  final responses = questions
                                      .map(
                                        (q) => FeedbackResponse(
                                          questionId: q.id,
                                          answer: _answers[q.id].toString(),
                                        ),
                                      )
                                      .toList();
                                  context.read<FeedbackCubit>().submitResponses(
                                    widget.moduleId,
                                    responses,
                                  );
                                }
                              : null,
                          child: const Text('Enviar'),
                        ),
                    ],
                  ),
                ],
              ),
            );
          }
          if (state is FeedbackError) {
            return Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Error: ${state.message}',
                    style: TextStyle(color: Colors.red),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () =>
                        context.read<FeedbackCubit>().loadQuestions(),
                    child: const Text('Reintentar'),
                  ),
                ],
              ),
            );
          }
          return SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildQuestion(FeedbackQuestion q) {
    if (q.questionType == 'rating') {
      // Estrellas
      int? value = _answers[q.id] is int ? _answers[q.id] : null;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(q.questionText),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (i) {
              final selected = value != null && value > i;
              return IconButton(
                icon: Icon(
                  selected ? Icons.star : Icons.star_border,
                  color: selected ? Colors.amber : Colors.grey,
                  size: 32,
                ),
                onPressed: () => setState(() => _answers[q.id] = i + 1),
              );
            }),
          ),
        ],
      );
    }
    // personalized: Slider
    double? value;
    final labels = List.from(q.predefinedAnswers.reversed);
    // Si ya hay respuesta, buscar el índice del string en labels, si no, valor default 3
    int selectedIdx = 2; // default al centro
    if (_answers[q.id] != null && labels.isNotEmpty) {
      final idx = labels.indexOf(_answers[q.id]);
      if (idx != -1) {
        selectedIdx = idx;
      }
    }
    value = (selectedIdx + 1).toDouble();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(q.questionText),
        const SizedBox(height: 12),
        Slider(
          value: value,
          min: 1,
          max: 5,
          divisions: 4,
          label: labels.isNotEmpty
              ? labels[selectedIdx]
              : value.round().toString(),
          onChanged: (v) {
            final idx = (v.round() - 1).clamp(0, labels.length - 1);
            setState(() => _answers[q.id] = labels[idx]);
          },
        ),
        if (labels.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: Center(
              child: Text(
                labels[selectedIdx].toString(),
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.deepOrange,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
      ],
    );
  }
}
