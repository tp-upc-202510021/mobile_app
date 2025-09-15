import 'package:flutter/material.dart';
import 'package:mobile_app/features/learning_path/models/step_types/dialogue_story_step.dart';

class DialogueStoryStepWidget extends StatefulWidget {
  final DialogueStoryStep step;
  const DialogueStoryStepWidget({Key? key, required this.step})
    : super(key: key);

  @override
  State<DialogueStoryStepWidget> createState() =>
      _DialogueStoryStepWidgetState();
}

class _DialogueStoryStepWidgetState extends State<DialogueStoryStepWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutBack,
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.lightBlueAccent, Colors.blueAccent],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '¡Historia de Diálogo!',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 18),
          ...widget.step.dialogue.map(
            (line) => AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return Opacity(
                  opacity: _animation.value.clamp(0.0, 1.0),
                  child: Transform.translate(
                    offset: Offset(
                      0,
                      (1 - _animation.value.clamp(0.0, 1.0)) * 30,
                    ),
                    child: Card(
                      color: line.speaker == 'Profesor'
                          ? Colors.orangeAccent
                          : Colors.greenAccent,
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 16,
                        ),
                        child: Row(
                          children: [
                            Icon(
                              line.speaker == 'Profesor'
                                  ? Icons.school
                                  : Icons.person,
                              color: Colors.white,
                              size: 28,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                '${line.speaker}: ${line.text}',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
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
              },
            ),
          ),
        ],
      ),
    );
  }
}
