import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_app/features/learning_path/presentation/cubit/module_detail_cubit.dart';
import 'package:mobile_app/features/learning_path/repositories/learning_path_repository.dart';
import 'package:mobile_app/features/learning_path/services/learning_path_service.dart';
import 'package:markdown_widget/markdown_widget.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class ModuleDetailScreen extends StatefulWidget {
  final int moduleId;

  const ModuleDetailScreen({super.key, required this.moduleId});

  @override
  State<ModuleDetailScreen> createState() => _ModuleDetailScreenState();
}

class _ModuleDetailScreenState extends State<ModuleDetailScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  List<YoutubePlayerController?> _videoControllers = [];

  void _nextPage(int totalPages) {
    if (_currentPage < totalPages - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _prevPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  YoutubePlayerController? _createYoutubeController(String url) {
    final videoId = YoutubePlayer.convertUrlToId(url);
    if (videoId == null) return null;
    return YoutubePlayerController(
      initialVideoId: videoId,
      flags: const YoutubePlayerFlags(autoPlay: false, mute: false),
    );
  }

  @override
  void dispose() {
    for (var controller in _videoControllers) {
      controller?.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          ModuleDetailCubit(LearningPathRepository(LearningPathService()))
            ..loadModuleDetail(widget.moduleId),
      child: Scaffold(
        appBar: AppBar(title: const Text('Detalle del Módulo')),
        body: BlocBuilder<ModuleDetailCubit, ModuleDetailState>(
          builder: (context, state) {
            if (state.loading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state.error != null) {
              return Center(child: Text(state.error!));
            } else if (state.data != null) {
              final module = state.data!;
              final pages = module.pages;
              final totalPages = pages.length + 1;

              // Inicializar videoControllers solo si está vacío
              if (_videoControllers.isEmpty) {
                _videoControllers = pages.map((page) {
                  if (page.type == 'video') {
                    return _createYoutubeController(page.content);
                  }
                  return null;
                }).toList();
              }

              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Center(
                      child: _currentPage > 0
                          ? Text(
                              'Página $_currentPage de ${totalPages - 1}',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            )
                          : const SizedBox.shrink(),
                    ),
                  ),
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
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  module.title,
                                  style: const TextStyle(
                                    fontSize: 26,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  module.description,
                                  style: const TextStyle(fontSize: 16),
                                ),
                                const Spacer(),
                                Center(
                                  child: ElevatedButton(
                                    onPressed: () =>
                                        _pageController.jumpToPage(1),
                                    child: const Text('Comenzar'),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }

                        final page = pages[index - 1];

                        switch (page.type) {
                          case 'informative':
                          case 'practical':
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              child: MarkdownWidget(data: page.content),
                            );

                          case 'video':
                            final controller = _videoControllers[index - 1];
                            if (controller == null) {
                              return const Center(
                                child: Text('Video no disponible'),
                              );
                            }
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              child: YoutubePlayerBuilder(
                                player: YoutubePlayer(
                                  controller: controller,
                                  showVideoProgressIndicator: true,
                                  progressIndicatorColor: Colors.redAccent,
                                ),
                                builder: (context, player) => player,
                              ),
                            );

                          default:
                            return const Center(
                              child: Text('Tipo de contenido no soportado'),
                            );
                        }
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    child: Visibility(
                      visible: _currentPage > 0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ElevatedButton(
                            onPressed: _prevPage,
                            child: const Text('Anterior'),
                          ),
                          ElevatedButton(
                            onPressed: _currentPage < totalPages - 1
                                ? () => _nextPage(totalPages)
                                : null,
                            child: Text(
                              _currentPage == totalPages - 1
                                  ? 'Finalizado'
                                  : 'Siguiente',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            } else {
              return const Center(child: Text('No hay detalles del módulo'));
            }
          },
        ),
      ),
    );
  }
}
