import 'package:http_interceptor/http_interceptor.dart';
import 'package:mobile_app/features/authentication/repositories/auth_repository.dart';

class AuthInterceptor implements InterceptorContract {
  final AuthRepository authRepository;

  AuthInterceptor(this.authRepository);

  @override
  Future<BaseRequest> interceptRequest({required BaseRequest request}) async {
    final accessToken = await authRepository.getAccessToken();
    if (accessToken != null) {
      request.headers['Authorization'] = 'Bearer $accessToken';
    }
    return request;
  }

  @override
  Future<BaseResponse> interceptResponse({
    required BaseResponse response,
  }) async {
    if (response.statusCode == 401) {
      try {
        await authRepository.refreshAccessToken();
      } catch (e) {
        // El refresh falló, probablemente el usuario debe volver a iniciar sesión
        throw Exception('Sesión expirada');
      }
    }
    return response;
  }

  @override
  bool shouldInterceptRequest() => true;

  @override
  bool shouldInterceptResponse() => true;
}
