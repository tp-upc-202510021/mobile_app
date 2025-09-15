import 'package:flutter/material.dart';
import 'package:mobile_app/features/learning_path/models/step_types/quiz_step.dart';

class QuizStepWidget extends StatefulWidget {
  final QuizStep step;
  const QuizStepWidget({Key? key, required this.step}) : super(key: key);

  @override
  State<QuizStepWidget> createState() => _QuizStepWidgetState();
}

class _QuizStepWidgetState extends State<QuizStepWidget> {
  int? _selectedIndex;
  bool _answered = false;

  void _selectOption(int index) {
    if (_answered) return;
    setState(() {
      _selectedIndex = index;
      _answered = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: const EdgeInsets.all(24),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.cyanAccent, Colors.blueAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: Colors.blue.withOpacity(0.15),
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
              'Quiz Time!',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 18),
            Text(
              widget.step.question,
              style: TextStyle(
                fontSize: 18,
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 18),
            ...List.generate(widget.step.options.length, (i) {
              final isCorrect = _answered && i == widget.step.answer;
              final isSelected = _selectedIndex == i;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 350),
                curve: Curves.easeInOut,
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: Material(
                  color: isCorrect
                      ? Colors.greenAccent
                      : isSelected
                      ? Colors.redAccent
                      : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: () => _selectOption(i),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 14,
                        horizontal: 16,
                      ),
                      child: Row(
                        children: [
                          Icon(
                            isCorrect
                                ? Icons.check_circle
                                : isSelected
                                ? Icons.cancel
                                : Icons.circle_outlined,
                            color: isCorrect
                                ? Colors.green
                                : isSelected
                                ? Colors.red
                                : Colors.grey,
                            size: 28,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              widget.step.options[i],
                              style: TextStyle(
                                fontSize: 16,
                                color: isCorrect || isSelected
                                    ? Colors.white
                                    : Colors.black87,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }),
            if (_answered)
              Padding(
                padding: const EdgeInsets.only(top: 18),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      _selectedIndex == widget.step.answer
                          ? Icons.emoji_events
                          : Icons.sentiment_dissatisfied,
                      color: _selectedIndex == widget.step.answer
                          ? Colors.amber
                          : Colors.redAccent,
                      size: 32,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      _selectedIndex == widget.step.answer
                          ? '¡Correcto!'
                          : 'Ups, intenta de nuevo',
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
