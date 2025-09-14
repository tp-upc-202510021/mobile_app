import 'package:http_interceptor/http_interceptor.dart';
import 'package:mobile_app/features/authentication/interceptors/auth_interceptor.dart';
import 'package:mobile_app/features/authentication/repositories/auth_repository.dart';

InterceptedClient createInterceptedClient(AuthRepository authRepository) {
  return InterceptedClient.build(
    interceptors: [AuthInterceptor(authRepository)],
  );
}
