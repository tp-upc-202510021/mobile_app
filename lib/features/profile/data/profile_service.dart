import 'dart:convert';
import 'package:http_interceptor/http_interceptor.dart';
import 'package:mobile_app/config/api_config.dart';

import 'package:mobile_app/network/http_client.dart';
import 'package:mobile_app/features/authentication/repositories/auth_repository.dart';

class ProfileService {
  final InterceptedClient client;

  ProfileService(AuthRepository authRepository)
    : client = createInterceptedClient(authRepository);

  Future<Map<String, dynamic>> getCurrentUser() async {
    final url = Uri.parse('${ApiConfig.baseUrl}/me/');
    final response = await client.get(url);

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load user');
    }
  }
}
