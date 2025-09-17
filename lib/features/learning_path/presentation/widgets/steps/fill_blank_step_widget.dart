import 'package:flutter/material.dart';
import 'package:mobile_app/features/learning_path/models/step_types/fill_blank_step.dart';

class FillBlankStepWidget extends StatefulWidget {
  final FillBlankStep step;
  final void Function(bool correct)? onAnswered;
  const FillBlankStepWidget({Key? key, required this.step, this.onAnswered})
    : super(key: key);

  @override
  State<FillBlankStepWidget> createState() => _FillBlankStepWidgetState();
}

class _FillBlankStepWidgetState extends State<FillBlankStepWidget> {
  int? _droppedIndex;
  bool _answered = false;
  bool get _isCorrect =>
      _droppedIndex != null && _droppedIndex == widget.step.answer;

  void _onDrop(int index) {
    if (_answered) return;
    setState(() {
      _droppedIndex = index;
      _answered = true;
    });
    if (widget.onAnswered != null) {
      widget.onAnswered!(index == widget.step.answer);
    }
  }

  void _reset() {
    setState(() {
      _droppedIndex = null;
      _answered = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (_answered && _isCorrect)
          Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: Text(
              '¡Felicidades! ¡Sabes la respuesta!',
              style: TextStyle(
                color: Colors.green.shade700,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        Center(
          child: Container(
            margin: const EdgeInsets.all(24),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.orangeAccent, Colors.deepOrangeAccent],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(28),
              boxShadow: [
                BoxShadow(
                  color: Colors.orange.withOpacity(0.15),
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
                  '¡Completa la frase!',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 18),
                // Frase con DragTarget
                Center(child: _buildSentenceWithBlank(context)),
                const SizedBox(height: 18),
                // Opciones para arrastrar
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: List.generate(widget.step.options.length, (i) {
                    final isDragged = _droppedIndex == i;
                    return isDragged
                        ? SizedBox(width: 90, height: 40)
                        : Draggable<int>(
                            data: i,
                            feedback: Material(
                              color: Colors.transparent,
                              child: _buildOptionChip(i, dragging: true),
                            ),
                            childWhenDragging: Opacity(
                              opacity: 0.3,
                              child: _buildOptionChip(i),
                            ),
                            child: _buildOptionChip(i),
                          );
                  }),
                ),
              ],
            ),
          ),
        ),
        if (_answered && !_isCorrect)
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: ElevatedButton(
              onPressed: _reset,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.deepOrange,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 2,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 12,
                ),
              ),
              child: const Text(
                'Intentar de nuevo',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildSentenceWithBlank(BuildContext context) {
    final parts = widget.step.sentence.split('_____');
    return RichText(
      text: TextSpan(
        style: TextStyle(
          fontSize: 18,
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
        children: [
          TextSpan(text: parts[0]),
          WidgetSpan(
            alignment: PlaceholderAlignment.middle,
            child: DragTarget<int>(
              builder: (context, candidateData, rejectedData) {
                final hasData = _droppedIndex != null;
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: 90,
                  height: 40,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: hasData
                        ? (_droppedIndex == widget.step.answer
                              ? Colors.greenAccent
                              : Colors.redAccent)
                        : Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: candidateData.isNotEmpty
                          ? Colors.deepOrangeAccent
                          : Colors.grey.shade300,
                      width: 2,
                    ),
                  ),
                  child: hasData
                      ? Text(
                          widget.step.options[_droppedIndex!],
                          style: TextStyle(
                            color: Colors.black87,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        )
                      : Text(
                          '______',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                );
              },
              onWillAccept: (data) => !_answered,
              onAccept: _onDrop,
            ),
          ),
          if (parts.length > 1) TextSpan(text: parts[1]),
        ],
      ),
    );
  }

  Widget _buildOptionChip(int i, {bool dragging = false}) {
    final isCorrect =
        _answered && i == widget.step.answer && _droppedIndex == i;
    final isSelected = _droppedIndex == i;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeInOut,
      child: Material(
        color: isCorrect
            ? Colors.greenAccent
            : isSelected
            ? Colors.redAccent
            : Colors.white,
        borderRadius: BorderRadius.circular(16),
        elevation: dragging ? 8 : 0,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 18),
          child: Text(
            widget.step.options[i],
            style: TextStyle(
              fontSize: 16,
              color: isCorrect || isSelected ? Colors.white : Colors.black87,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
