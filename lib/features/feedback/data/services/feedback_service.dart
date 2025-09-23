import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/feedback_models.dart';

class FeedbackService {
  final _storage = const FlutterSecureStorage();

  Future<List<FeedbackQuestionModel>> fetchQuestions() async {
    final token = await _storage.read(key: 'access_token');
    final response = await http.get(
      Uri.parse(
        'https://backend-production-1f432.up.railway.app/feedback/questions',
      ),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['success'] == true) {
        return (data['data'] as List)
            .map((e) => FeedbackQuestionModel.fromJson(e))
            .toList();
      }
      throw Exception(data['message'] ?? 'Error fetching questions');
    } else {
      throw Exception('Failed to load feedback questions');
    }
  }

  Future<void> saveResponses(
    int moduleId,
    List<FeedbackResponseModel> responses,
  ) async {
    final token = await _storage.read(key: 'access_token');
    final response = await http.post(
      Uri.parse(
        'https://backend-production-1f432.up.railway.app/feedback/save-response/',
      ),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode({
        'module_id': moduleId,
        'responses': responses.map((r) => r.toJson()).toList(),
      }),
    );
    if (response.statusCode != 200 && response.statusCode != 201) {
      print('FeedbackService error: statusCode=${response.statusCode}');
      print('FeedbackService error: body=${response.body}');
      throw Exception('Failed to save feedback responses');
    }
    // Si statusCode == 200, no lanzar excepción aunque el body tenga error
  }
}
