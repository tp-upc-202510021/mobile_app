import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';

class AuthRepository {
  final AuthService _service;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  AuthRepository(this._service);

  Future<UserModel> login(String email, String password) async {
    final data = await _service.login(email, password);
    final user = UserModel.fromJson(data['user']);

    // Guardar tokens
    await _storage.write(key: 'access_token', value: data['access']);
    await _storage.write(key: 'refresh_token', value: data['refresh']);
    await _storage.write(key: 'user_id', value: user.id.toString());

    return user;
  }

  Future<UserModel> register({
    required String name,
    required String email,
    required String password,
    required int age,
    required String preference,
  }) async {
    final data = await _service.register(
      name: name,
      email: email,
      password: password,
      age: age,
      preference: preference,
    );

    // Guardar tokens
    await _storage.write(key: 'access_token', value: data['access']);
    await _storage.write(key: 'refresh_token', value: data['refresh']);

    // Eliminar tokens antes de construir el modelo
    data.remove('access');
    data.remove('refresh');

    final user = UserModel.fromJson(data);

    return user;
  }

  Future<void> logout() async {
    await _storage.delete(key: 'access_token');
    await _storage.delete(key: 'refresh_token');
  }

  Future<String?> getAccessToken() async {
    return await _storage.read(key: 'access_token');
  }

  Future<String?> getRefreshToken() async {
    return await _storage.read(key: 'refresh_token');
  }

  Future<String?> getUserId() async {
    return await _storage.read(key: 'user_id');
  }

  Future<void> printStoredTokens() async {
    final accessToken = await _storage.read(key: 'access_token');
    final refreshToken = await _storage.read(key: 'refresh_token');

    print('📦 Access Token: $accessToken');
    print('♻️ Refresh Token: $refreshToken');
  }
}
