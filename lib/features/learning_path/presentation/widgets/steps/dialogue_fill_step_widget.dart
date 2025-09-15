import 'package:flutter/material.dart';
import 'package:mobile_app/features/learning_path/models/step_types/dialogue_fill_step.dart';

class DialogueFillStepWidget extends StatefulWidget {
  final DialogueFillStep step;
  const DialogueFillStepWidget({Key? key, required this.step})
    : super(key: key);

  @override
  State<DialogueFillStepWidget> createState() => _DialogueFillStepWidgetState();
}

class _DialogueFillStepWidgetState extends State<DialogueFillStepWidget> {
  final List<int?> _selectedIndexes = [];
  bool _completed = false;

  @override
  void initState() {
    super.initState();
    _selectedIndexes.addAll(
      List<int?>.filled(widget.step.answers.length, null),
    );
  }

  void _selectOption(int blankIdx, int optionIdx) {
    if (_completed) return;
    setState(() {
      _selectedIndexes[blankIdx] = optionIdx;
      _completed = _selectedIndexes.every((i) => i != null);
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
            colors: [Colors.indigoAccent, Colors.blueAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: Colors.indigo.withOpacity(0.15),
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
              '¡Completa el diálogo!',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 18),
            ...List.generate(widget.step.conversation.length, (i) {
              final conv = widget.step.conversation[i];
              final isBlank = conv.text.contains('_____');
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Card(
                  color: conv.speaker == 'Profesor'
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
                          conv.speaker == 'Profesor'
                              ? Icons.school
                              : Icons.person,
                          color: Colors.white,
                          size: 28,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: isBlank
                              ? _buildBlank(i)
                              : Text(
                                  '${conv.speaker}: ${conv.text}',
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
              );
            }),
            const SizedBox(height: 18),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: List.generate(widget.step.options.length, (i) {
                final isSelected = _selectedIndexes.contains(i);
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 350),
                  curve: Curves.easeInOut,
                  child: Material(
                    color: isSelected ? Colors.indigo : Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(16),
                      onTap: _completed
                          ? null
                          : () {
                              final blankIdx = _selectedIndexes.indexOf(null);
                              if (blankIdx != -1) {
                                _selectOption(blankIdx, i);
                              }
                            },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 18,
                        ),
                        child: Text(
                          widget.step.options[i],
                          style: TextStyle(
                            fontSize: 16,
                            color: isSelected ? Colors.white : Colors.black87,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
            if (_completed)
              Padding(
                padding: const EdgeInsets.only(top: 18),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      _isAllCorrect()
                          ? Icons.emoji_events
                          : Icons.sentiment_dissatisfied,
                      color: _isAllCorrect() ? Colors.amber : Colors.redAccent,
                      size: 32,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      _isAllCorrect() ? '¡Correcto!' : 'Ups, intenta de nuevo',
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

  Widget _buildBlank(int blankIdx) {
    final selected = _selectedIndexes[blankIdx];
    final correct =
        selected != null && selected == widget.step.answers[blankIdx];
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecoration(
        color: correct
            ? Colors.greenAccent
            : selected != null
            ? Colors.redAccent
            : Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        selected != null ? widget.step.options[selected] : '______',
        style: TextStyle(
          fontSize: 16,
          color: correct || selected != null ? Colors.white : Colors.black87,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  bool _isAllCorrect() {
    for (int i = 0; i < widget.step.answers.length; i++) {
      if (_selectedIndexes[i] != widget.step.answers[i]) return false;
    }
    return true;
  }
}
