import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_app/features/learning_path/presentation/cubit/module_detail_cubit.dart';
import 'package:mobile_app/features/learning_path/repositories/learning_path_repository.dart';
import 'package:mobile_app/features/learning_path/services/learning_path_service.dart';
import 'package:markdown_widget/markdown_widget.dart'; // IMPORTANTE

class ModuleDetailScreen extends StatelessWidget {
  final int moduleId;

  const ModuleDetailScreen({super.key, required this.moduleId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          ModuleDetailCubit(LearningPathRepository(LearningPathService()))
            ..loadModuleDetail(moduleId),
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
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: ListView(
                  children: [
                    Text(
                      module.title,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      module.description,
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 20),
                    module.content.isNotEmpty
                        ? MarkdownWidget(data: module.content, shrinkWrap: true)
                        : const Text(
                            'No hay contenido disponible',
                            style: TextStyle(
                              fontSize: 14,
                              fontStyle: FontStyle.italic,
                              color: Colors.grey,
                            ),
                          ),
                  ],
                ),
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
