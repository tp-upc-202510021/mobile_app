import 'package:flutter/material.dart';
import '../widgets/feedback_dialog.dart';

class FeedbackScreen extends StatelessWidget {
  final int moduleId;
  const FeedbackScreen({Key? key, required this.moduleId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Feedback')),
      body: Center(
        child: ElevatedButton(
          child: const Text('Abrir feedback'),
          onPressed: () {
            showDialog(
              context: context,
              builder: (_) => FeedbackDialog(moduleId: moduleId),
            );
          },
        ),
      ),
    );
  }
}
