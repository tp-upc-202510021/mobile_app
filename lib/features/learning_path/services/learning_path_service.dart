import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:mobile_app/config/api_config.dart';

class LearningPathService {
  final _storage = const FlutterSecureStorage();

  Future<Map<String, dynamic>> fetchLearningPath() async {
    final token = await _storage.read(key: 'access_token');

    final response = await http.get(
      Uri.parse('${ApiConfig.baseUrl}/learningpaths/latest/'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else if (response.statusCode == 404) {
      return {
        "learning_path_id": null,
        "user_id": null,
        "created_at": null,
        "modules": [],
      };
    } else {
      throw Exception('Failed to load learning path');
    }
  }

  Future<Map<String, dynamic>> fetchModuleDetail(int moduleId) async {
    final token = await _storage.read(key: 'access_token');

    final response = await http.get(
      Uri.parse('${ApiConfig.baseUrl}/learningmodules/modules/$moduleId/'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      // Expects new JSON structure with steps
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load module detail');
    }
  }
}
