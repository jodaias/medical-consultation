import 'package:dio/dio.dart';
import 'package:medical_consultation_app/core/custom_dio/auth_interceptor.dart';
import 'package:medical_consultation_app/core/custom_dio/print_log_interceptor.dart';

class GenericDio {
  late final Dio dio;

  GenericDio({String? baseUrl, bool isAuthenticated = true}) {
    dio = Dio(BaseOptions(
      baseUrl: baseUrl ?? '',
    ));

    dio.interceptors.add(PrintLogInterceptor());

    if (isAuthenticated) dio.interceptors.add(AuthInterceptor(dio));
  }
}