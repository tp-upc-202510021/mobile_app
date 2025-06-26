import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mobile_app/config/api_config.dart';
import 'package:mobile_app/features/game/data/game_invitation_response_model.dart';
import 'package:mobile_app/features/game/data/investment/apply_exchange_investment_model.dart';

class InvestmentGameService {
  final _storage = const FlutterSecureStorage();

  Future<Map<String, dynamic>> inviteToInvestmentGame(int invitedUserId) async {
    final token = await _storage.read(key: 'access_token');
    final url = Uri.parse(
      '${ApiConfig.baseUrl}/game/invite-user-to-investment-game/',
    );

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

  Future<GameInvitationResponse> respondToInvestmentInvitation({
    required int sessionId,
    required String response,
  }) async {
    final token = await _storage.read(key: 'access_token');
    final url = Uri.parse(
      '${ApiConfig.baseUrl}/game/respond-to-investment-invitation/',
    );

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

  Future<ApplyExchangeEventResponse> applyExchangeEvent(
    Map<String, dynamic> data,
  ) async {
    final token = await _storage.read(key: 'access_token');
    final url = Uri.parse('${ApiConfig.baseUrl}/game/apply-exchange-event/');

    print('🌍 URL: $url');
    print('📡 Enviando POST con: ${jsonEncode(data)}');

    final res = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(data),
    );

    print('📨 Código de estado: ${res.statusCode}');
    print('📨 Body crudo: ${res.body}');

    if (res.statusCode != 200) {
      throw Exception('Error ${res.statusCode}: ${res.body}');
    }

    if (res.body.isEmpty) {
      throw Exception('Respuesta vacía del servidor');
    }

    try {
      final decoded = json.decode(res.body);
      print('📦 Decoded JSON: $decoded (${decoded.runtimeType})');

      if (decoded == null || decoded is! Map<String, dynamic>) {
        throw Exception('❌ JSON inválido o nulo');
      }

      if (decoded['event'] == null || decoded['base_rate'] == null) {
        throw Exception('❌ Campos faltantes en la respuesta');
      }

      return ApplyExchangeEventResponse.fromJson(decoded);
    } catch (e, st) {
      print('❌ Error al parsear la respuesta: $e');
      print('📉 Stacktrace: $st');
      throw Exception('Error al parsear la respuesta: $e');
    }
  }
}
