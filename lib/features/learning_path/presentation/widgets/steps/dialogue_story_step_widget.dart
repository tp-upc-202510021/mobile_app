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
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ...widget.step.dialogue.asMap().entries.map((entry) {
            final i = entry.key;
            final line = entry.value;
            final isProfesor = line.speaker == 'Profesor';
            final isFirst = i == 0;
            final isPrevProfesor =
                !isFirst && widget.step.dialogue[i - 1].speaker == 'Profesor';
            final isPrevAlumno =
                !isFirst && widget.step.dialogue[i - 1].speaker != 'Profesor';
            return Column(
              children: [
                if (!isFirst &&
                    ((isProfesor && isPrevAlumno) ||
                        (!isProfesor && isPrevProfesor)))
                  const SizedBox(
                    height: 16,
                  ), // Espacio extra entre profesor y alumno
                AnimatedBuilder(
                  animation: _animation,
                  builder: (context, child) {
                    return Opacity(
                      opacity: _animation.value.clamp(0.0, 1.0),
                      child: Transform.translate(
                        offset: Offset(
                          0,
                          (1 - _animation.value.clamp(0.0, 1.0)) * 30,
                        ),
                        child: Row(
                          mainAxisAlignment: isProfesor
                              ? MainAxisAlignment.start
                              : MainAxisAlignment.end,
                          children: [
                            if (isProfesor) ...[
                              CircleAvatar(
                                backgroundColor: Colors.orangeAccent,
                                child: Icon(Icons.school, color: Colors.white),
                              ),
                              const SizedBox(width: 8),
                            ],
                            Flexible(
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                  horizontal: 16,
                                ),
                                decoration: BoxDecoration(
                                  color: isProfesor
                                      ? Colors.orangeAccent
                                      : Colors.blueAccent,
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(16),
                                    topRight: Radius.circular(16),
                                    bottomLeft: Radius.circular(
                                      isProfesor ? 16 : 16,
                                    ),
                                    bottomRight: Radius.circular(
                                      isProfesor ? 16 : 16,
                                    ),
                                  ),
                                ),
                                child: Text(
                                  line.text,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                            if (!isProfesor) ...[
                              const SizedBox(width: 8),
                              CircleAvatar(
                                backgroundColor: Colors.blueAccent,
                                child: Icon(Icons.person, color: Colors.white),
                              ),
                            ],
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            );
          }),
        ],
      ),
    );
  }
}
