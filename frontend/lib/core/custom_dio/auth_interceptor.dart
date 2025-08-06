import 'package:dio/dio.dart';
import 'package:medical_consultation_app/core/di/injection.dart';
import 'package:medical_consultation_app/core/services/storage_service.dart';
import 'package:medical_consultation_app/features/auth/data/services/auth_service.dart';
// import 'package:medical_consultation_app/core/cache/cache_store.dart';
// import 'package:medical_consultation_app/core/models/token_model.dart';

class AuthInterceptor extends Interceptor {
  final Dio dio;
  final AuthService authService;

  // final _cacheStore = getIt<CacheStore<TokenModel>>();
  final storageService = getIt<StorageService>();

  AuthInterceptor(this.dio, this.authService);

  @override
  Future<void> onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    final expiration = await storageService.getTokenExpiration();
    var accessToken = await storageService.getToken();

    // Se faltar menos de 5 minutos para expirar, tenta atualizar
    if (expiration != null) {
      var refreshToken = await storageService.getRefreshToken();
      final difference = expiration.difference(DateTime.now());
      if (difference.inMinutes < 5 && refreshToken != null) {
        final result = await authService.refreshToken(refreshToken);
        if (result.success) {
          accessToken = result.data['accessToken'];
          refreshToken = result.data['refreshToken'];
          await storageService.saveToken(accessToken!);
          await storageService.saveRefreshToken(refreshToken!);
        }
      }
    }

    if (accessToken != null) {
      options.headers['Authorization'] = 'Bearer $accessToken';
    }

    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) =>
      handler.next(err);
}
