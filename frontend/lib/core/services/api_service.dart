import 'package:dio/dio.dart';
import 'package:medical_consultation_app/core/di/injection.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:medical_consultation_app/core/utils/constants.dart';
import 'package:medical_consultation_app/core/services/storage_service.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  late final Dio _dio;

  void initialize() {
    _dio = Dio(
      BaseOptions(
        baseUrl: AppConstants.baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // Adicionar interceptors
    _dio.interceptors.addAll([
      PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        responseHeader: false,
        error: true,
        compact: true,
        maxWidth: 90,
      ),
      _AuthInterceptor(),
      _ErrorInterceptor(_dio),
    ]);
  }

  Dio get dio => _dio;

  // Métodos HTTP
  Future<Response> get(String path,
      {Map<String, dynamic>? queryParameters}) async {
    return await _dio.get(path, queryParameters: queryParameters);
  }

  Future<Response> post(String path, {dynamic data}) async {
    return await _dio.post(path, data: data);
  }

  Future<Response> put(String path, {dynamic data}) async {
    return await _dio.put(path, data: data);
  }

  Future<Response> delete(String path) async {
    return await _dio.delete(path);
  }

  Future<Response> patch(String path, {dynamic data}) async {
    return await _dio.patch(path, data: data);
  }
}

class _AuthInterceptor extends Interceptor {
  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    try {
      final storageService = getIt<StorageService>();
      final token = await storageService.getToken();
      print(
          '🔍 AuthInterceptor - Token: ${token != null ? "Presente" : "Ausente"}');
      if (token != null && !storageService.isTokenExpired(token)) {
        options.headers['Authorization'] = 'Bearer $token';
        print('🔍 AuthInterceptor - Token adicionado ao header');
      } else {
        print('🔍 AuthInterceptor - Token ausente ou expirado');
      }
    } catch (e) {
      print('❌ AuthInterceptor - Erro ao obter token: $e');
      // Se houver erro ao obter token, continua sem autenticação
    }

    handler.next(options);
  }
}

class _ErrorInterceptor extends Interceptor {
  bool _isRefreshing = false;
  final List<RequestOptions> _pendingRequests = [];
  late final Dio _dio;

  _ErrorInterceptor(this._dio);

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401 && !_isRefreshing) {
      _isRefreshing = true;

      try {
        // Tentar renovar o token
        final success = await _refreshToken();

        if (success) {
          // Repetir a requisição original
          final response = await _retryRequest(err.requestOptions);
          handler.resolve(response);
          return;
        } else {
          // Token não pode ser renovado, fazer logout
          await _logoutUser();
          throw UnauthorizedException('Sessão expirada. Faça login novamente.');
        }
      } catch (e) {
        await _logoutUser();
        throw UnauthorizedException('Sessão expirada. Faça login novamente.');
      } finally {
        _isRefreshing = false;
      }
    }

    // Tratar outros erros
    switch (err.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        throw ApiException('Timeout de conexão');
      case DioExceptionType.badResponse:
        final statusCode = err.response?.statusCode;
        final message = err.response?.data?['message'] ?? 'Erro desconhecido';

        switch (statusCode) {
          case 401:
            throw UnauthorizedException(message);
          case 403:
            throw ForbiddenException(message);
          case 404:
            throw NotFoundException(message);
          case 422:
            throw ValidationException(message);
          case 500:
            throw ServerException(message);
          default:
            throw ApiException(message);
        }
      case DioExceptionType.cancel:
        throw ApiException('Requisição cancelada');
      default:
        throw ApiException('Erro de conexão');
    }
  }

  Future<bool> _refreshToken() async {
    try {
      final storageService = getIt<StorageService>();
      final refreshToken = await storageService.getRefreshToken();

      if (refreshToken == null) return false;

      // Criar uma nova instância do Dio para evitar interceptors
      final dio = Dio(BaseOptions(
        baseUrl: AppConstants.baseUrl,
        headers: {'Content-Type': 'application/json'},
      ));

      final response = await dio.post('/users/refresh', data: {
        'refreshToken': refreshToken,
      });

      if (response.statusCode == 200) {
        final newToken = response.data['data']['token'];
        final newRefreshToken = response.data['data']['refreshToken'];

        await storageService.saveToken(newToken);
        await storageService.saveRefreshToken(newRefreshToken);
        return true;
      }

      return false;
    } catch (e) {
      print('❌ Erro ao renovar token: $e');
      return false;
    }
  }

  Future<Response> _retryRequest(RequestOptions requestOptions) async {
    final storageService = getIt<StorageService>();
    final token = await storageService.getToken();

    final options = Options(
      method: requestOptions.method,
      headers: requestOptions.headers,
    );

    if (token != null) {
      options.headers?['Authorization'] = 'Bearer $token';
    }

    return await _dio.request(
      requestOptions.path,
      data: requestOptions.data,
      queryParameters: requestOptions.queryParameters,
      options: options,
    );
  }

  Future<void> _logoutUser() async {
    try {
      final storageService = getIt<StorageService>();
      await storageService.clearAll();

      // Navegar para a tela de login
      // Isso será tratado pelo AuthStore
      print('🔍 Usuário deslogado devido a token expirado');
    } catch (e) {
      print('❌ Erro ao fazer logout: $e');
    }
  }
}

// Exceções customizadas
class ApiException implements Exception {
  final String message;
  ApiException(this.message);

  @override
  String toString() => message;
}

class UnauthorizedException extends ApiException {
  UnauthorizedException(super.message);
}

class ForbiddenException extends ApiException {
  ForbiddenException(super.message);
}

class NotFoundException extends ApiException {
  NotFoundException(super.message);
}

class ValidationException extends ApiException {
  ValidationException(super.message);
}

class ServerException extends ApiException {
  ServerException(super.message);
}
