import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:forui/forui.dart';
import 'package:mobile_app/app/app_root.dart';
import 'package:mobile_app/features/authentication/presentation/cubit/auth_cubit.dart';
import 'package:mobile_app/features/initial_assesstment/models/initial_assestment_model.dart';
import 'package:mobile_app/features/initial_assesstment/presentation/cubit/initial_assestment_cubit.dart';

class AssessmentLoadingScreen extends StatefulWidget {
  final InitialAssessmentResult result;

  const AssessmentLoadingScreen({Key? key, required this.result})
    : super(key: key);

  @override
  State<AssessmentLoadingScreen> createState() =>
      _AssessmentLoadingScreenState();
}

class _AssessmentLoadingScreenState extends State<AssessmentLoadingScreen> {
  bool _navigated = false;

  @override
  void initState() {
    super.initState();
    context.read<AssessmentCubit>().submitInitialAssessment(widget.result);
  }

  void _navigateToNext() async {
    if (_navigated) return;
    _navigated = true;

    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      context.read<AuthCubit>().checkAuthStatus();
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const AppRoot()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AssessmentCubit, AssessmentState>(
      listener: (context, state) {
        if (state is AssessmentError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        } else if (state is AssessmentSuccess) {
          _navigateToNext();
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: BlocBuilder<AssessmentCubit, AssessmentState>(
            builder: (context, state) {
              final isProgress = state is AssessmentProgress;
              final isSuccess = state is AssessmentSuccess;

              return ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: 400,
                  maxHeight: 260,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: FCard(
                    title: const Text('Progreso de evaluación'),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(height: 16),
                        _buildStep(
                          done: isProgress ? state.assessmentSent : true,
                          label: 'Analizando tu evaluación inicial...',
                        ),
                        const SizedBox(height: 12),
                        _buildStep(
                          done: isProgress ? state.pathCreated : true,
                          label: 'Creando ruta de aprendizaje personalizada...',
                        ),
                        const SizedBox(height: 12),
                        _buildStep(
                          done: isProgress
                              ? state.modulesCreated == state.totalModules
                              : true,
                          label: isProgress
                              ? 'Creando módulos... (${state.modulesCreated}/${state.totalModules})'
                              : 'Creando módulos... (completado)',
                        ),
                        const SizedBox(height: 12),
                        if (isSuccess)
                          _buildStep(done: isSuccess, label: 'Finalizando...'),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildStep({required bool done, required String label}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        done
            ? const Icon(Icons.check_circle, color: Colors.green)
            : const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
        const SizedBox(width: 12),
        Flexible(child: Text(label, style: const TextStyle(fontSize: 16))),
      ],
    );
  }
}
