import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
  @override
  void initState() {
    super.initState();
    context.read<AssessmentCubit>().submitInitialAssessment(widget.result);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AssessmentCubit, AssessmentState>(
      listener: (context, state) {
        if (state is AssessmentSuccess) {
          context.read<AuthCubit>().checkAuthStatus();
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const AppRoot()),
          );
        } else if (state is AssessmentError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: BlocBuilder<AssessmentCubit, AssessmentState>(
            builder: (context, state) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(height: 20),
                  Text(
                    _getLoadingText(state),
                    style: const TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  String _getLoadingText(AssessmentState state) {
    if (state is AssessmentLoading) {
      return 'Enviando tu evaluación inicial...\nEsto puede tomar unos segundos.';
    } else if (state is AssessmentCreatingPath) {
      return 'Creando tu ruta de aprendizaje personalizada... 🚀';
    } else if (state is AssessmentCreatingModules) {
      return 'Creando módulos de aprendizaje... 📚';
    } else if (state is AssessmentError) {
      return 'Ocurrió un error al enviar la evaluación.';
    } else {
      return 'Preparando tu evaluación...';
    }
  }
}
