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
import 'package:mobile_app/features/feedback/presentation/widgets/feedback_dialog.dart';
import 'package:mobile_app/features/feedback/presentation/cubit/feedback_cubit.dart';
import 'package:mobile_app/features/feedback/data/services/feedback_service.dart';
import 'package:mobile_app/features/feedback/data/repositories/feedback_repository_adapter.dart';
import 'package:mobile_app/features/feedback/domain/usecases/feedback_usecases.dart';

class ModuleDetailScreen extends StatefulWidget {
  final int moduleId;
  const ModuleDetailScreen({super.key, required this.moduleId});

  @override
  State<ModuleDetailScreen> createState() => _ModuleDetailScreenState();
}

class _ModuleDetailScreenState extends State<ModuleDetailScreen> {
  // Controla si el step actual está correctamente respondido
  final ValueNotifier<bool> _canGoNext = ValueNotifier<bool>(false);

  // Permite resetear el step actual desde el padre
  void _resetCurrentStep() {
    // Este método se puede usar para llamar a un método de reset en el widget del step si se implementa
    // Por ahora, solo un placeholder
  }
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
          color: Colors.white,
          child: Column(
            children: [
              // Barra de progreso con botón de salir
              Padding(
                padding: const EdgeInsets.only(
                  right: 30,
                  top: 12,
                  bottom: 12,
                  left: 8,
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.black),
                      tooltip: 'Salir',
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    Expanded(
                      child: BlocBuilder<ModuleDetailCubit, ModuleDetailState>(
                        builder: (context, state) {
                          if (state.data != null) {
                            final steps = state.data!.content?.steps ?? [];
                            final totalPages = steps.length;
                            final progress =
                                _currentPage /
                                (totalPages - 1).clamp(1, double.infinity);
                            return ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: LinearProgressIndicator(
                                value: progress.clamp(0.0, 1.0),
                                backgroundColor: Colors.grey.shade200,
                                color: Colors.blueAccent,
                                minHeight: 12,
                              ),
                            );
                          }
                          return const SizedBox.shrink();
                        },
                      ),
                    ),
                  ],
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
                      final totalPages = steps.length;

                      // Inicializar _canGoNext según el primer step
                      if (_currentPage == 0 && steps.isNotEmpty) {
                        final firstStep = steps[0];
                        final shouldEnable =
                            firstStep.type == 'dialogue_story' ||
                            firstStep.type == 'analogy_card' ||
                            firstStep.type == 'flashcard';
                        if (_canGoNext.value != shouldEnable) {
                          // Solo actualizar si es necesario para evitar loops
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            _canGoNext.value = shouldEnable;
                          });
                        }
                      }

                      return Column(
                        children: [
                          Expanded(
                            child: NotificationListener<ScrollNotification>(
                              onNotification: (notification) {
                                // Bloquear swipe si no puede avanzar
                                if (notification is ScrollStartNotification &&
                                    !_canGoNext.value) {
                                  return true; // Bloquea el swipe
                                }
                                return false;
                              },
                              child: PageView.builder(
                                controller: _pageController,
                                itemCount: totalPages,
                                onPageChanged: (index) {
                                  setState(() {
                                    _currentPage = index;
                                    final step = steps[index];
                                    if (step.type == 'dialogue_story' ||
                                        step.type == 'analogy_card' ||
                                        step.type == 'flashcard') {
                                      _canGoNext.value = true;
                                    } else {
                                      _canGoNext.value = false;
                                    }
                                  });
                                },
                                physics: _canGoNext.value
                                    ? const PageScrollPhysics()
                                    : const NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  final step = steps[index];
                                  // ...existing code...
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
                                      return FlashcardStepWidget(
                                        step: step.data,
                                      );
                                    case 'quiz':
                                      return QuizStepWidget(
                                        step: step.data,
                                        onAnswered: (correct) =>
                                            _canGoNext.value = correct,
                                      );
                                    case 'true_false':
                                      return TrueFalseStepWidget(
                                        step: step.data,
                                        onAnswered: (correct) =>
                                            _canGoNext.value = correct,
                                      );
                                    case 'fill_blank':
                                      return Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          FillBlankStepWidget(
                                            step: step.data,
                                            onAnswered: (correct) =>
                                                _canGoNext.value = correct,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                              top: 12,
                                              bottom: 8,
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  Icons.touch_app,
                                                  color: Colors.deepOrange,
                                                  size: 20,
                                                ),
                                                const SizedBox(width: 8),
                                                Text(
                                                  'Arrastra la opción al espacio en blanco',
                                                  style: TextStyle(
                                                    color: Colors.deepOrange,
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      );
                                    case 'dialogue_fill':
                                      return Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          DialogueFillStepWidget(
                                            step: step.data,
                                            onAnswered: (correct) =>
                                                _canGoNext.value = correct,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                              top: 12,
                                              bottom: 8,
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  Icons.touch_app,
                                                  color: Colors.deepOrange,
                                                  size: 20,
                                                ),
                                                const SizedBox(width: 8),
                                                Text(
                                                  'Arrastra la opción al espacio en blanco',
                                                  style: TextStyle(
                                                    color: Colors.deepOrange,
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
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
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 12,
                              horizontal: 24,
                            ),
                            child: Center(
                              child: SizedBox(
                                width: double.infinity,
                                child: ValueListenableBuilder<bool>(
                                  valueListenable: _canGoNext,
                                  builder: (context, canGo, _) {
                                    final isLastPage =
                                        _currentPage == totalPages - 1;
                                    return ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.blueAccent,
                                        foregroundColor: Colors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            16,
                                          ),
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 16,
                                        ),
                                      ),
                                      onPressed: (canGo)
                                          ? () async {
                                              if (!isLastPage) {
                                                _pageController.nextPage(
                                                  duration: const Duration(
                                                    milliseconds: 300,
                                                  ),
                                                  curve: Curves.easeInOut,
                                                );
                                              } else {
                                                // Mostrar feedback dialog al finalizar
                                                await showDialog(
                                                  context: context,
                                                  barrierDismissible: false,
                                                  builder: (ctx) {
                                                    return BlocProvider(
                                                      create: (_) => FeedbackCubit(
                                                        getQuestionsUseCase:
                                                            GetFeedbackQuestionsUseCase(
                                                              FeedbackRepositoryAdapter(
                                                                FeedbackService(),
                                                              ),
                                                            ),
                                                        saveResponsesUseCase:
                                                            SaveFeedbackResponsesUseCase(
                                                              FeedbackRepositoryAdapter(
                                                                FeedbackService(),
                                                              ),
                                                            ),
                                                      ),
                                                      child: FeedbackDialog(
                                                        moduleId:
                                                            widget.moduleId,
                                                        onSubmitted: () {
                                                          Navigator.of(
                                                            context,
                                                          ).pop();
                                                        },
                                                      ),
                                                    );
                                                  },
                                                );
                                              }
                                            }
                                          : null,
                                      child: Text(
                                        isLastPage ? 'Finalizar' : 'Siguiente',
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
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
