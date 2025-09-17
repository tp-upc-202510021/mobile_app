import 'package:flutter/material.dart';
import 'package:mobile_app/features/learning_path/models/step_types/quiz_step.dart';

class QuizStepWidget extends StatefulWidget {
  final QuizStep step;
  final void Function(bool correct)? onAnswered;
  const QuizStepWidget({Key? key, required this.step, this.onAnswered})
    : super(key: key);

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
    if (widget.onAnswered != null) {
      widget.onAnswered!(_selectedIndex == widget.step.answer);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Card principal
          Container(
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
                  final isSelected = _selectedIndex == i;
                  // Si la respuesta es incorrecta, solo marca la opción seleccionada como incorrecta
                  Color optionColor;
                  IconData iconData;
                  Color iconColor;
                  if (_answered) {
                    if (_selectedIndex == widget.step.answer) {
                      // Respuesta correcta
                      optionColor = i == widget.step.answer
                          ? Colors.greenAccent
                          : Colors.white;
                      iconData = i == widget.step.answer
                          ? Icons.check_circle
                          : Icons.circle_outlined;
                      iconColor = i == widget.step.answer
                          ? Colors.green
                          : Colors.grey;
                    } else {
                      // Respuesta incorrecta
                      optionColor = isSelected
                          ? Colors.redAccent
                          : Colors.white;
                      iconData = isSelected
                          ? Icons.cancel
                          : Icons.circle_outlined;
                      iconColor = isSelected ? Colors.red : Colors.grey;
                    }
                  } else {
                    optionColor = Colors.white;
                    iconData = Icons.circle_outlined;
                    iconColor = Colors.grey;
                  }
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 350),
                    curve: Curves.easeInOut,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: Material(
                      color: optionColor,
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
                              Icon(iconData, color: iconColor, size: 28),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  widget.step.options[i],
                                  style: TextStyle(
                                    fontSize: 16,
                                    color:
                                        (optionColor == Colors.greenAccent ||
                                            optionColor == Colors.redAccent)
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
          // Botón intentar de nuevo fuera del card
          if (_answered && _selectedIndex != widget.step.answer)
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Center(
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _selectedIndex = null;
                      _answered = false;
                    });
                    if (widget.onAnswered != null) widget.onAnswered!(false);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Intentar de nuevo'),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
