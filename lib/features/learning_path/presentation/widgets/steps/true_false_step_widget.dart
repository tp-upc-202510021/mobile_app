import 'package:flutter/material.dart';
import 'package:mobile_app/features/learning_path/models/step_types/true_false_step.dart';

class TrueFalseStepWidget extends StatefulWidget {
  final TrueFalseStep step;
  final void Function(bool correct)? onAnswered;
  const TrueFalseStepWidget({Key? key, required this.step, this.onAnswered})
    : super(key: key);

  @override
  State<TrueFalseStepWidget> createState() => _TrueFalseStepWidgetState();
}

class _TrueFalseStepWidgetState extends State<TrueFalseStepWidget> {
  final List<bool?> _answers = [];
  bool _completed = false;

  @override
  void initState() {
    super.initState();
    _answers.addAll(List<bool?>.filled(widget.step.statements.length, null));
  }

  void _select(int idx, bool value) {
    if (_completed) return;
    setState(() {
      _answers[idx] = value;
      _completed = _answers.every((a) => a != null);
    });
    if (_completed && widget.onAnswered != null) {
      final allCorrect = List.generate(
        widget.step.statements.length,
        (i) => _answers[i] == widget.step.statements[i].answer,
      ).every((v) => v);
      widget.onAnswered!(allCorrect);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: const EdgeInsets.all(24),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.greenAccent, Colors.lightGreen],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: Colors.green.withOpacity(0.15),
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '¿Verdadero o Falso?',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 18),
            ...List.generate(widget.step.statements.length, (i) {
              final statement = widget.step.statements[i];
              final selected = _answers[i];
              final correct = selected != null && selected == statement.answer;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 350),
                curve: Curves.easeInOut,
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: Material(
                  color: correct
                      ? Colors.green
                      : selected != null
                      ? Colors.redAccent
                      : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 14,
                      horizontal: 16,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            statement.text,
                            style: TextStyle(
                              fontSize: 16,
                              color: correct || selected != null
                                  ? Colors.white
                                  : Colors.black87,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        if (!_completed)
                          Row(
                            children: [
                              IconButton(
                                icon: Icon(Icons.check, color: Colors.green),
                                onPressed: () => _select(i, true),
                              ),
                              IconButton(
                                icon: Icon(Icons.close, color: Colors.red),
                                onPressed: () => _select(i, false),
                              ),
                            ],
                          ),
                        if (_completed)
                          Icon(
                            correct
                                ? Icons.emoji_events
                                : Icons.sentiment_dissatisfied,
                            color: correct ? Colors.amber : Colors.redAccent,
                            size: 28,
                          ),
                      ],
                    ),
                  ),
                ),
              );
            }),
            if (_completed)
              Padding(
                padding: const EdgeInsets.only(top: 18),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.celebration,
                      color: Colors.yellowAccent,
                      size: 32,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      '¡Completado!',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
