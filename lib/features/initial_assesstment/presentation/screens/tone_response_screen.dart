import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_app/features/initial_assesstment/models/initial_assestment_model.dart';
import 'motivation_input_screen.dart';

class ToneSelectionScreen extends StatefulWidget {
  final String preference;

  const ToneSelectionScreen({super.key, required this.preference});

  @override
  State<ToneSelectionScreen> createState() => _ToneSelectionScreenState();
}

class _ToneSelectionScreenState extends State<ToneSelectionScreen> {
  List<dynamic> toneOptions = [];
  String? selectedToneToGemini;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadToneOptions();
  }

  Future<void> loadToneOptions() async {
    try {
      final String jsonString = await rootBundle.loadString(
        'assets/data/tone_response_questions.json',
      );
      final List<dynamic> loadedData = json.decode(jsonString);

      setState(() {
        toneOptions = loadedData;
        isLoading = false;
      });
    } catch (e) {
      debugPrint('Error loading tone response data: $e');
      setState(() {
        toneOptions = [];
        isLoading = false;
      });
    }
  }

  void _goToNextScreen() {
    if (selectedToneToGemini != null) {
      final result = InitialAssessmentResult(
        responseTone: selectedToneToGemini!,
        motivation: '',
      );

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MotivationInputScreen(
            result: result,
            preference: widget.preference,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const Text(
                '¿Qué estilo de guía prefieres?',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),

              // Opciones visuales tipo tarjetas
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: toneOptions.map((option) {
                  final isSelected =
                      selectedToneToGemini == option['to_gemini'];
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedToneToGemini = option['to_gemini'];
                      });
                    },
                    child: Container(
                      width: 100,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.blue.shade100 : Colors.white,
                        border: Border.all(
                          color: isSelected ? Colors.blue : Colors.grey,
                          width: isSelected ? 2 : 1,
                        ),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 6,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          const Icon(Icons.person, size: 40),
                          const SizedBox(height: 8),
                          Text(
                            option['title'] ?? '',
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),

              const SizedBox(height: 24),

              // Mostrar descripción si hay opción seleccionada
              if (selectedToneToGemini != null)
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.blue.shade200),
                  ),
                  child: Text(
                    toneOptions.firstWhere(
                          (o) => o['to_gemini'] == selectedToneToGemini,
                        )['description'] ??
                        '',
                    style: const TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                ),

              const SizedBox(height: 24),

              ElevatedButton(
                onPressed: selectedToneToGemini != null
                    ? _goToNextScreen
                    : null,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                ),
                child: const Text('Siguiente'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
