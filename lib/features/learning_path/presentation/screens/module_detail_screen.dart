import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_app/features/learning_path/presentation/cubit/module_detail_cubit.dart';
import 'package:mobile_app/features/learning_path/repositories/learning_path_repository.dart';
import 'package:mobile_app/features/learning_path/services/learning_path_service.dart';
import 'package:mobile_app/features/learning_path/presentation/widgets/steps/dialogue_story_step_widget.dart';
import 'package:mobile_app/features/learning_path/presentation/widgets/steps/analogy_card_step_widget.dart';
import 'package:mobile_app/features/learning_path/presentation/widgets/steps/flashcard_step_widget.dart';
import 'package:mobile_app/features/learning_path/presentation/widgets/steps/quiz_step_widget.dart';
import 'package:mobile_app/features/learning_path/presentation/widgets/steps/true_false_step_widget.dart';
import 'package:mobile_app/features/learning_path/presentation/widgets/steps/fill_blank_step_widget.dart';
import 'package:mobile_app/features/learning_path/presentation/widgets/steps/dialogue_fill_step_widget.dart';

class ModuleDetailScreen extends StatefulWidget {
  final int moduleId;
  const ModuleDetailScreen({super.key, required this.moduleId});

  @override
  State<ModuleDetailScreen> createState() => _ModuleDetailScreenState();
}

class _ModuleDetailScreenState extends State<ModuleDetailScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Widget _buildProgressBar(int totalPages) {
    final progress = _currentPage / (totalPages - 1);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: LinearProgressIndicator(
          value: progress.clamp(0.0, 1.0),
          backgroundColor: Colors.purple.shade100,
          color: Colors.purpleAccent,
          minHeight: 12,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          ModuleDetailCubit(LearningPathRepository(LearningPathService()))
            ..loadModuleDetail(widget.moduleId),
      child: Scaffold(
        body: Container(
          width: double.infinity,
          color: Colors.purple.shade50,
          child: Column(
            children: [
              PreferredSize(
                preferredSize: const Size.fromHeight(60),
                child: BlocBuilder<ModuleDetailCubit, ModuleDetailState>(
                  builder: (context, state) {
                    if (state.data != null) {
                      final steps = state.data!.content?.steps ?? [];
                      final totalPages = steps.length + 1;
                      return _buildProgressBar(totalPages);
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ),
              Expanded(
                child: BlocBuilder<ModuleDetailCubit, ModuleDetailState>(
                  builder: (context, state) {
                    if (state.loading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state.error != null) {
                      return Center(child: Text(state.error!));
                    } else if (state.data != null) {
                      final module = state.data!;
                      final steps = module.content?.steps ?? [];
                      final totalPages = steps.length + 1;

                      return Column(
                        children: [
                          Expanded(
                            child: PageView.builder(
                              controller: _pageController,
                              itemCount: totalPages,
                              onPageChanged: (index) {
                                setState(() {
                                  _currentPage = index;
                                });
                              },
                              itemBuilder: (context, index) {
                                if (index == 0) {
                                  return Padding(
                                    padding: const EdgeInsets.all(24),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          module.title,
                                          style: const TextStyle(
                                            fontSize: 28,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.purple,
                                          ),
                                        ),
                                        const SizedBox(height: 16),
                                        Text(
                                          module.description,
                                          style: const TextStyle(
                                            fontSize: 18,
                                            color: Colors.black87,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }

                                final step = steps[index - 1];
                                switch (step.type) {
                                  case 'dialogue_story':
                                    return DialogueStoryStepWidget(
                                      step: step.data,
                                    );
                                  case 'analogy_card':
                                    return AnalogyCardStepWidget(
                                      step: step.data,
                                    );
                                  case 'flashcard':
                                    return FlashcardStepWidget(step: step.data);
                                  case 'quiz':
                                    return QuizStepWidget(step: step.data);
                                  case 'true_false':
                                    return TrueFalseStepWidget(step: step.data);
                                  case 'fill_blank':
                                    return FillBlankStepWidget(step: step.data);
                                  case 'dialogue_fill':
                                    return DialogueFillStepWidget(
                                      step: step.data,
                                    );
                                  default:
                                    return const Center(
                                      child: Text(
                                        'Tipo de contenido no soportado',
                                      ),
                                    );
                                }
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.purpleAccent,
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 24,
                                      vertical: 12,
                                    ),
                                  ),
                                  onPressed: _currentPage > 0
                                      ? () => _pageController.previousPage(
                                          duration: const Duration(
                                            milliseconds: 300,
                                          ),
                                          curve: Curves.easeInOut,
                                        )
                                      : null,
                                  child: const Text(
                                    'Anterior',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.purpleAccent,
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 24,
                                      vertical: 12,
                                    ),
                                  ),
                                  onPressed: _currentPage < totalPages - 1
                                      ? () => _pageController.nextPage(
                                          duration: const Duration(
                                            milliseconds: 300,
                                          ),
                                          curve: Curves.easeInOut,
                                        )
                                      : null,
                                  child: const Text(
                                    'Siguiente',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    } else {
                      return const Center(
                        child: Text('No hay detalles del módulo'),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
