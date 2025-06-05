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
    } else {
      throw Exception('Failed to load learning path');
    }
  }
}
