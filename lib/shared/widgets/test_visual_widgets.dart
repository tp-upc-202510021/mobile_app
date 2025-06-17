import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:forui/forui.dart';

// ----------------------------
// Estados fake
// ----------------------------
abstract class AssessmentState {}

class AssessmentProgress extends AssessmentState {
  final bool assessmentSent;
  final bool pathCreated;
  final int modulesCreated;
  final int totalModules;

  AssessmentProgress({
    required this.assessmentSent,
    required this.pathCreated,
    required this.modulesCreated,
    required this.totalModules,
  });
}

// ----------------------------
// Cubit Fake
// ----------------------------
class DummyAssessmentCubit extends Cubit<AssessmentState> {
  DummyAssessmentCubit()
    : super(
        AssessmentProgress(
          assessmentSent: false,
          pathCreated: false,
          modulesCreated: 0,
          totalModules: 3,
        ),
      ) {
    _simulateProgress();
  }

  Future<void> _simulateProgress() async {
    await Future.delayed(const Duration(seconds: 1));
    emit(
      AssessmentProgress(
        assessmentSent: true,
        pathCreated: false,
        modulesCreated: 0,
        totalModules: 3,
      ),
    );
    await Future.delayed(const Duration(seconds: 1));
    emit(
      AssessmentProgress(
        assessmentSent: true,
        pathCreated: true,
        modulesCreated: 0,
        totalModules: 3,
      ),
    );
    await Future.delayed(const Duration(seconds: 1));
    emit(
      AssessmentProgress(
        assessmentSent: true,
        pathCreated: true,
        modulesCreated: 1,
        totalModules: 3,
      ),
    );
    await Future.delayed(const Duration(seconds: 1));
    emit(
      AssessmentProgress(
        assessmentSent: true,
        pathCreated: true,
        modulesCreated: 3,
        totalModules: 3,
      ),
    );
  }
}

// ----------------------------
// Visual Widget
// ----------------------------
class AssessmentVisualScreen extends StatelessWidget {
  const AssessmentVisualScreen({super.key});

  Widget _buildStep({required bool done, required String text, String? extra}) {
    return Row(
      children: [
        done
            ? const Icon(Icons.check_circle, color: Colors.green)
            : const SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            extra != null ? '$text $extra' : text,
            style: const TextStyle(fontSize: 16),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DummyAssessmentCubit(),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400, maxHeight: 220),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: BlocBuilder<DummyAssessmentCubit, AssessmentState>(
                builder: (context, state) {
                  if (state is AssessmentProgress) {
                    return Center(
                      child: FCard(
                        title: const Text('Progreso de evaluación'),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize
                              .min, // 👈 importante para que se ajuste al contenido
                          children: [
                            const SizedBox(height: 16),
                            _buildStep(
                              done: state.assessmentSent,
                              text: 'Enviando evaluación inicial...',
                            ),
                            const SizedBox(height: 12),
                            _buildStep(
                              done: state.pathCreated,
                              text: 'Creando ruta personalizada... 🛠️',
                            ),
                            const SizedBox(height: 12),
                            _buildStep(
                              done: state.modulesCreated == state.totalModules,
                              text: 'Creando módulos... 📚',
                              extra:
                                  '${state.modulesCreated}/${state.totalModules}',
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  return const CircularProgressIndicator();
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
