import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mobile_app/config/api_config.dart';
import 'package:mobile_app/features/game/data/loan/game_data_loan_model.dart';
import 'package:mobile_app/features/game/data/game_invitation_response_model.dart';
import 'package:mobile_app/features/game/data/loan/rate_event_loan_model.dart';

class LoanGameService {
  final _storage = const FlutterSecureStorage();

  Future<GameLoanData> generateGame() async {
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
      return GameLoanData.fromJson(json.decode(res.body));
    } else {
      throw Exception('Error generating game: ${res.statusCode}');
    }
  }

  Future<RateEventResponse> sendRateEvent(RateEventLoanRequest request) async {
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

  Future<Map<String, dynamic>> inviteToGame(int invitedUserId) async {
    final token = await _storage.read(key: 'access_token');
    final url = Uri.parse('${ApiConfig.baseUrl}/game/invite-to-game/');

    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({"invited_user_id": invitedUserId}),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Error ${response.statusCode}: ${response.body}');
    }
  }

  Future<GameInvitationResponse> respondToInvitation({
    required int sessionId,
    required String response, // "accept" or "reject"
  }) async {
    final token = await _storage.read(key: 'access_token');
    final url = Uri.parse('${ApiConfig.baseUrl}/game/respond-to-invitation/');

    final res = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({"session_id": sessionId, "response": response}),
    );

    if (res.statusCode == 200 || res.statusCode == 201) {
      return GameInvitationResponse.fromJson(jsonDecode(res.body));
    } else {
      throw Exception('Error ${res.statusCode}: ${res.body}');
    }
  }
}
