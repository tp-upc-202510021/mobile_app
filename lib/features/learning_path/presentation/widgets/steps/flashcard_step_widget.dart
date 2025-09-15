import 'package:flutter/material.dart';
import 'package:mobile_app/features/learning_path/models/step_types/flashcard_step.dart';

class FlashcardStepWidget extends StatefulWidget {
  final FlashcardStep step;
  const FlashcardStepWidget({Key? key, required this.step}) : super(key: key);

  @override
  State<FlashcardStepWidget> createState() => _FlashcardStepWidgetState();
}

class _FlashcardStepWidgetState extends State<FlashcardStepWidget> {
  bool _showBack = false;

  void _flipCard() {
    setState(() {
      _showBack = !_showBack;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: _flipCard,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
          margin: const EdgeInsets.all(24),
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: _showBack ? Colors.tealAccent : Colors.pinkAccent,
            borderRadius: BorderRadius.circular(32),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 16,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 400),
            transitionBuilder: (child, animation) => RotationTransition(
              turns: Tween<double>(begin: 0.8, end: 1.0).animate(animation),
              child: child,
            ),
            child: _showBack
                ? Column(
                    key: const ValueKey('back'),
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Respuesta',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        widget.step.back,
                        style: TextStyle(fontSize: 18, color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 12),
                      Icon(Icons.check_circle, color: Colors.white, size: 36),
                    ],
                  )
                : Column(
                    key: const ValueKey('front'),
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Pregunta',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        widget.step.front,
                        style: TextStyle(fontSize: 18, color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 12),
                      Icon(Icons.help_outline, color: Colors.white, size: 36),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
