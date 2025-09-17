import 'package:flutter/material.dart';
import 'package:mobile_app/features/learning_path/models/step_types/dialogue_fill_step.dart';

class DialogueFillStepWidget extends StatefulWidget {
  final DialogueFillStep step;
  final void Function(bool correct)? onAnswered;
  const DialogueFillStepWidget({Key? key, required this.step, this.onAnswered})
    : super(key: key);

  @override
  State<DialogueFillStepWidget> createState() => _DialogueFillStepWidgetState();
}

class _DialogueFillStepWidgetState extends State<DialogueFillStepWidget> {
  void _notifyAnswered() {
    if (widget.onAnswered != null) {
      widget.onAnswered!(_isAllCorrect());
    }
  }

  final List<int?> _selectedIndexes = [];
  bool _completed = false;
  // Para drag & drop: saber qué opción se está arrastrando
  int? _draggingOptionIdx;

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
    if (_completed) {
      _notifyAnswered();
    }
  }

  void _resetStep() {
    setState(() {
      for (int i = 0; i < _selectedIndexes.length; i++) {
        _selectedIndexes[i] = null;
      }
      _completed = false;
    });
    if (widget.onAnswered != null) widget.onAnswered!(false);
  }

  @override
  Widget build(BuildContext context) {
    // Para saber qué blanks hay y su orden
    final blankIndices = <int>[];
    for (int i = 0; i < widget.step.conversation.length; i++) {
      if (widget.step.conversation[i].text.contains('_____')) {
        blankIndices.add(i);
      }
    }

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.07),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Completa el diálogo',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.indigo.shade700,
                  ),
                ),
                const SizedBox(height: 18),
                // Diálogo tipo chat, mostrando el texto completo y blanks inline
                ...List.generate(widget.step.conversation.length, (i) {
                  final conv = widget.step.conversation[i];
                  final isProfesor = conv.speaker == 'Profesor';
                  Widget chatContent;
                  if (conv.text.contains('_____')) {
                    // Reemplazar cada '_____' por el DragTarget correspondiente
                    final blankIdx = blankIndices.indexOf(i);
                    final parts = conv.text.split('_____');
                    chatContent = RichText(
                      text: TextSpan(
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                        children: [
                          // TextSpan(text: '${conv.speaker}: '),
                          for (int j = 0; j < parts.length; j++) ...[
                            TextSpan(text: parts[j]),
                            if (j < parts.length - 1 && blankIdx != -1)
                              WidgetSpan(
                                alignment: PlaceholderAlignment.middle,
                                child: _buildDragTargetBlank(blankIdx),
                              ),
                          ],
                        ],
                      ),
                    );
                  } else {
                    chatContent = Text(
                      '${conv.speaker}: ${conv.text}',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                    );
                  }
                  return Row(
                    mainAxisAlignment: isProfesor
                        ? MainAxisAlignment.start
                        : MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      if (isProfesor)
                        Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: CircleAvatar(
                            radius: 18,
                            backgroundColor: Colors.orangeAccent,
                            child: Icon(
                              Icons.school,
                              color: Colors.white,
                              size: 22,
                            ),
                          ),
                        ),
                      Flexible(
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          padding: const EdgeInsets.symmetric(
                            vertical: 12,
                            horizontal: 16,
                          ),
                          constraints: const BoxConstraints(maxWidth: 320),
                          decoration: BoxDecoration(
                            color: isProfesor
                                ? Colors.orangeAccent
                                : Colors.blueAccent,
                            borderRadius: BorderRadius.only(
                              topLeft: const Radius.circular(18),
                              topRight: const Radius.circular(18),
                              bottomLeft: isProfesor
                                  ? const Radius.circular(4)
                                  : const Radius.circular(18),
                              bottomRight: isProfesor
                                  ? const Radius.circular(18)
                                  : const Radius.circular(4),
                            ),
                          ),
                          child: chatContent,
                        ),
                      ),
                      if (!isProfesor)
                        Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: CircleAvatar(
                            radius: 18,
                            backgroundColor: Colors.blueAccent,
                            child: Icon(
                              Icons.person,
                              color: Colors.white,
                              size: 22,
                            ),
                          ),
                        ),
                    ],
                  );
                }),
                const SizedBox(height: 18),
                // Opciones arrastrables
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: List.generate(widget.step.options.length, (i) {
                    final isSelected = _selectedIndexes.contains(i);
                    return Draggable<int>(
                      data: i,
                      feedback: Material(
                        color: Colors.transparent,
                        child: _buildOptionChip(i, dragging: true),
                      ),
                      childWhenDragging: Opacity(
                        opacity: 0.4,
                        child: _buildOptionChip(i),
                      ),
                      onDragStarted: () {
                        setState(() {
                          _draggingOptionIdx = i;
                        });
                      },
                      onDraggableCanceled: (_, __) {
                        setState(() {
                          _draggingOptionIdx = null;
                        });
                      },
                      onDragEnd: (_) {
                        setState(() {
                          _draggingOptionIdx = null;
                        });
                      },
                      maxSimultaneousDrags: _completed || isSelected ? 0 : 1,
                      child: _buildOptionChip(i),
                    );
                  }),
                ),
                if (_completed)
                  Padding(
                    padding: const EdgeInsets.only(top: 18),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              _isAllCorrect()
                                  ? Icons.emoji_events
                                  : Icons.sentiment_dissatisfied,
                              color: _isAllCorrect()
                                  ? Colors.amber
                                  : Colors.redAccent,
                              size: 32,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              _isAllCorrect()
                                  ? '¡Correcto!'
                                  : 'Ups, intenta de nuevo',
                              style: const TextStyle(
                                fontSize: 18,
                                color: Colors.black87,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        if (!_isAllCorrect())
                          Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: ElevatedButton(
                              onPressed: _resetStep,
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
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // DragTarget para blanks
  Widget _buildDragTargetBlank(int blankIdx) {
    final selected = _selectedIndexes[blankIdx];
    final correct =
        selected != null && selected == widget.step.answers[blankIdx];
    return DragTarget<int>(
      builder: (context, candidateData, rejectedData) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 14),
          decoration: BoxDecoration(
            color: correct
                ? Colors.greenAccent
                : selected != null
                ? Colors.redAccent
                : Colors.grey.shade200,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: candidateData.isNotEmpty
                  ? Colors.indigo
                  : Colors.transparent,
              width: 2,
            ),
          ),
          child: Text(
            selected != null
                ? widget.step.options[selected]
                : (candidateData.isNotEmpty ? 'Suelta aquí' : '______'),
            style: TextStyle(
              fontSize: 16,
              color: correct || selected != null
                  ? Colors.white
                  : Colors.black87,
              fontWeight: FontWeight.w500,
            ),
          ),
        );
      },
      onWillAccept: (data) {
        // Solo aceptar si el blank está vacío y la opción no está ya usada
        return !_completed &&
            selected == null &&
            !_selectedIndexes.contains(data);
      },
      onAccept: (optionIdx) {
        _selectOption(blankIdx, optionIdx);
      },
    );
  }

  // Chip visual para opciones
  Widget _buildOptionChip(int i, {bool dragging = false}) {
    final isSelected = _selectedIndexes.contains(i);
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
      decoration: BoxDecoration(
        color: isSelected
            ? Colors.indigo
            : dragging
            ? Colors.indigo.shade100
            : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isSelected ? Colors.indigo : Colors.grey.shade300,
          width: 2,
        ),
        boxShadow: dragging
            ? [
                BoxShadow(
                  color: Colors.indigo.withOpacity(0.15),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ]
            : [],
      ),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 18),
      child: Text(
        widget.step.options[i],
        style: TextStyle(
          fontSize: 16,
          color: isSelected || dragging ? Colors.white : Colors.black87,
          fontWeight: FontWeight.w500,
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
