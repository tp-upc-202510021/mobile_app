import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mobile_app/config/api_config.dart';
import 'package:mobile_app/features/game/data/game_data_model.dart';
import 'package:mobile_app/features/game/data/rate_event_model.dart';

class GameService {
  final _storage = const FlutterSecureStorage();

  Future<GameData> generateGame() async {
    final token = await _storage.read(key: 'access_token');
    final url = Uri.parse('${ApiConfig.baseUrl}/game/generate-loan-game/ai/');
    final res = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (res.statusCode == 200) {
      return GameData.fromJson(json.decode(res.body));
    } else {
      throw Exception('Error generating game: ${res.statusCode}');
    }
  }

  Future<RateEventResponse> sendRateEvent(RateEventRequest request) async {
    final token = await _storage.read(key: 'access_token');
    final url = Uri.parse('${ApiConfig.baseUrl}/game/rate-event/');

    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(request.toJson()),
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return RateEventResponse.fromJson(json);
    } else {
      throw Exception('Error ${response.statusCode}: ${response.body}');
    }
  }
}
