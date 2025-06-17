import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:mobile_app/config/api_config.dart';
import 'package:mobile_app/features/initial_assesstment/models/initial_assestment_model.dart';

class AssessmentService {
  final String baseUrl;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  AssessmentService({this.baseUrl = ApiConfig.baseUrl});

  Future<void> submitInitialAssessment(InitialAssessmentResult result) async {
    try {
      print('[AssessmentService] Leyendo token desde SecureStorage...');
      final token = await _storage.read(key: 'access_token');

      if (token == null || token.isEmpty) {
        print('[AssessmentService] ERROR: Token no encontrado o vacío.');
        throw Exception('Token no encontrado. Inicia sesión nuevamente.');
      }

      final url = Uri.parse('$baseUrl/diagnostics/');
      print('[AssessmentService] Enviando POST a $url');
      print('[AssessmentService] Payload: ${jsonEncode(result.toJson())}');

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(result.toJson()),
      );

      print('[AssessmentService] Status code: ${response.statusCode}');
      print('[AssessmentService] Body: ${response.body}');

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception('Error al enviar la evaluación: ${response.body}');
      }
    } catch (e) {
      print('[AssessmentService] Excepción capturada: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> createLearningPath() async {
    final token = await _storage.read(key: 'access_token');
    if (token == null || token.isEmpty) {
      throw Exception('Token no encontrado. Inicia sesión nuevamente.');
    }

    final url = Uri.parse('$baseUrl/learningpaths/create/');
    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    print('[AssessmentService] createLearningPath response: ${response.body}');

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception(
        'Error al crear la ruta de aprendizaje: ${response.body}',
      );
    }

    return jsonDecode(response.body);
  }

  Future<void> createLearningModules(List<int> moduleIds) async {
    final token = await _storage.read(key: 'access_token');
    if (token == null || token.isEmpty) {
      throw Exception('Token no encontrado. Inicia sesión nuevamente.');
    }

    final url = Uri.parse('$baseUrl/learningmodules/generate-content/');

    for (final moduleId in moduleIds) {
      print(
        '[AssessmentService] Generando contenido para módulo ID: $moduleId',
      );

      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'module_id': moduleId}),
      );

      print('[AssessmentService] Respuesta módulo $moduleId: ${response.body}');

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception(
          'Error al generar contenido del módulo $moduleId: ${response.body}',
        );
      }
    }
  }
}
