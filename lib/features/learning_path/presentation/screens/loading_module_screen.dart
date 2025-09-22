import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_app/features/initial_assesstment/presentation/cubit/initial_assestment_cubit.dart';
import 'package:mobile_app/features/learning_path/presentation/screens/module_detail_screen.dart';

class ModuleLoadingScreen extends StatefulWidget {
  final int moduleId;

  const ModuleLoadingScreen({super.key, required this.moduleId});

  @override
  State<ModuleLoadingScreen> createState() => _ModuleLoadingScreenState();
}

class _ModuleLoadingScreenState extends State<ModuleLoadingScreen> {
  @override
  void initState() {
    super.initState();
    _generateModule();
  }

  void _generateModule() {
    context.read<AssessmentCubit>().generateContentForModule(widget.moduleId);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AssessmentCubit, AssessmentState>(
      listener: (context, state) {
        if (state is AssessmentSuccess) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => ModuleDetailScreen(moduleId: widget.moduleId),
            ),
          );
        } else if (state is AssessmentError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('❌ Error: ${state.message}')));
        }
      },
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: BlocBuilder<AssessmentCubit, AssessmentState>(
              builder: (context, state) {
                int current = 0;
                int total = 1;

                if (state is AssessmentCreatingModules) {
                  current = state.current;
                  total = state.total;
                }

                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/rocket_load.png',
                      width: 280,
                      height: 280,
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Estamos creando tu contenido personalizado...',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF3A3A3A),
                      ),
                    ),
                    const SizedBox(height: 15),
                    const Text(
                      'Esto solo tomará unos segundos. 🎯',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Progreso: $current de $total módulos creados',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Color(0xFF666666),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const SizedBox(height: 30),
                    const CircularProgressIndicator(
                      strokeWidth: 3,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Colors.deepPurple,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
