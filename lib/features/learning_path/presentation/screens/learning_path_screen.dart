import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:forui/forui.dart';
import 'package:mobile_app/features/learning_path/presentation/cubit/learning_path_cubit.dart';
import 'package:mobile_app/features/learning_path/presentation/screens/module_detail_screen.dart';
import 'package:mobile_app/features/learning_path/presentation/widgets/module_card.dart';

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
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: modules.length,
              itemBuilder: (_, index) {
                final module = modules[index];
                return GestureDetector(
                  onTap: () {
                    print('Module ID: ${module.id}');
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            ModuleDetailScreen(moduleId: module.id!),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 5,
                    ),
                    child: ModuleCard(
                      title: module.title,
                      level: module.level.toString(),
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
