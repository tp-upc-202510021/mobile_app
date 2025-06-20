import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:mobile_app/config/api_config.dart';

class BadgeService {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Future<String?> _getToken() async {
    return await _storage.read(key: 'access_token');
  }

  Future<List<dynamic>> fetchUserBadges() async {
    final token = await _getToken();
    final url = Uri.parse('${ApiConfig.baseUrl}/user-badges/');

    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Error al obtener badges');
    }
  }

  Future<void> unlockBadge(int badgeId, String description) async {
    final token = await _getToken();
    final url = Uri.parse('${ApiConfig.baseUrl}/user-badges/create/');

    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode({'badge_id': badgeId, 'description': description}),
    );

    if (response.statusCode != 201) {
      throw Exception('Error al desbloquear badge');
    }
  }
}
