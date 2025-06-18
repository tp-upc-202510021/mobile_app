import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mobile_app/config/api_config.dart';
import 'package:mobile_app/features/quiz/data/quiz_model.dart';

class QuizService {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Future<Map<String, dynamic>> generateQuiz(int moduleId) async {
    final token = await _storage.read(key: 'access_token');
    if (token == null || token.isEmpty) {
      throw Exception('Token no encontrado. Inicia sesión nuevamente.');
    }

    final url = Uri.parse('${ApiConfig.baseUrl}/quizzes/generate/$moduleId/');

    print('[QuizService] Generando quiz para módulo ID: $moduleId');

    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    print('[QuizService] Respuesta quiz $moduleId: ${response.body}');

    if (response.statusCode == 200 || response.statusCode == 201) {
      return json.decode(response.body);
    } else {
      throw Exception(
        'Error al generar el quiz del módulo $moduleId: ${response.body}',
      );
    }
  }

  Future<Quiz> fetchQuiz(int moduleId) async {
    final token = await _storage.read(key: 'access_token');
    if (token == null || token.isEmpty) {
      throw Exception('Token no encontrado. Inicia sesión nuevamente.');
    }

    final url = Uri.parse('${ApiConfig.baseUrl}/quizzes/latest/$moduleId');
    final resp = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
    if (resp.statusCode != 200) {
      throw Exception('Error al obtener quiz: ${resp.body}');
    }
    return Quiz.fromJson(json.decode(resp.body));
  }

  Future<void> submitQuizResult({
    required int quizId,
    required int score,
  }) async {
    final token = await _storage.read(key: 'access_token');
    if (token == null) {
      throw Exception('Token no encontrado.');
    }

    final url = Uri.parse('${ApiConfig.baseUrl}/quizzes/create-result/');
    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'quiz_id': quizId, 'score': score}),
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Error al enviar resultado: ${response.body}');
    }
  }
}
