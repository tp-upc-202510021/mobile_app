import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:forui/forui.dart';
import 'package:mobile_app/features/initial_assesstment/presentation/cubit/initial_assestment_cubit.dart';
import 'package:mobile_app/features/initial_assesstment/repositories/initial_assestment_repository.dart';
import 'package:mobile_app/features/initial_assesstment/services/initial_assestment_service.dart';
import 'package:mobile_app/features/learning_path/presentation/cubit/learning_path_cubit.dart';
import 'package:mobile_app/features/learning_path/presentation/cubit/module_detail_cubit.dart';
import 'package:mobile_app/features/learning_path/presentation/screens/loading_module_screen.dart';
import 'package:mobile_app/features/learning_path/presentation/screens/module_detail_screen.dart';
import 'package:mobile_app/features/learning_path/presentation/widgets/module_card.dart';
import 'package:mobile_app/features/learning_path/repositories/learning_path_repository.dart';
import 'package:mobile_app/features/learning_path/services/learning_path_service.dart';
import 'package:mobile_app/features/quiz/data/quiz_repository.dart';
import 'package:mobile_app/features/quiz/data/quiz_service.dart';

class LearningPathScreen extends StatelessWidget {
  const LearningPathScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return FScaffold(
      header: FHeader(
        title: Row(
          children: [
            IconButton(
              icon: const Icon(FIcons.arrowLeft),
              tooltip: 'Volver',
              onPressed: () => Navigator.of(context).pop(),
            ),
            const SizedBox(width: 10),
            const Text(
              'Ruta de Aprendizaje',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
      child: BlocBuilder<LearningPathCubit, LearningPathState>(
        builder: (context, state) {
          if (state.loading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state.error != null) {
            return Center(child: Text('Error: ${state.error}'));
          } else if (state.data != null) {
            final modules = state.data!.modules;
            if (modules.isEmpty) {
              return Center(
                child: FButton(
                  onPress: () {
                    print('Generar nuevo Learning Path');
                    // Aquí podrías llamar a un método del cubit
                  },
                  child: const Text('Generar Learning Path'),
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
              itemCount: modules.length,
              itemBuilder: (_, index) {
                final module = modules[index];
                return GestureDetector(
                  onTap: () async {
                    final service = LearningPathService();
                    final repository = LearningPathRepository(service);
                    final moduleDetailCubit = ModuleDetailCubit(repository);

                    await moduleDetailCubit.loadModuleDetail(module.id!);
                    final detail = moduleDetailCubit.state.data;
                    if (detail != null &&
                        detail.content != null &&
                        detail.content!.steps.isNotEmpty) {
                      print('Module ID: ${module.id}');
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => BlocProvider.value(
                            value: moduleDetailCubit,
                            child: ModuleDetailScreen(moduleId: module.id!),
                          ),
                        ),
                      );
                      // Refrescar el cubit al volver
                      final learningPathCubit = context
                          .read<LearningPathCubit>();
                      learningPathCubit.loadLearningPath();
                    } else {
                      final quizService = QuizService();
                      final quizRepository = QuizRepository(quizService);
                      final assessmentService = AssessmentService();
                      final assessmentRepo = AssessmentRepository(
                        service: assessmentService,
                      );
                      final assessmentCubit = AssessmentCubit(
                        repository: assessmentRepo,
                        quizRepository: quizRepository,
                      );

                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => MultiBlocProvider(
                            providers: [
                              BlocProvider.value(value: moduleDetailCubit),
                              BlocProvider(create: (_) => assessmentCubit),
                            ],
                            child: ModuleLoadingScreen(moduleId: module.id!),
                          ),
                        ),
                      );
                      // Refrescar el cubit al volver
                      final learningPathCubit = context
                          .read<LearningPathCubit>();
                      learningPathCubit.loadLearningPath();
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 5,
                    ),
                    child: ModuleCard(
                      title: module.title,
                      level: module.level.toString(),
                      isBlocked: module.isBlocked,
                      isApproved: module.isApproved,
                    ),
                  ),
                );
              },
            );
          } else {
            // Caso raro: sin error y sin data
            return Center(
              child: FButton(
                onPress: () {
                  print('Generar nuevo Learning Path');
                },
                child: const Text('Generar Learning Path'),
              ),
            );
          }
        },
      ),
    );
  }
}
