import 'package:dio/dio.dart';

class PrintLogInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    print(
        'PrintLogInterceptor ${DateTime.now()} - [${options.method}] ${options.uri}');
    return super.onRequest(options, handler);
  }

  @override
  void onResponse(
      Response<dynamic> response, ResponseInterceptorHandler handler) {
    print(
        'PrintLogInterceptor ${DateTime.now()} - [${response.requestOptions.method} ${response.statusCode}] ${response.requestOptions.uri}');
    if (response.statusCode != 200) print(response.data);
    return super.onResponse(response, handler);
  }

  @override
  void onError(DioException e, ErrorInterceptorHandler handler) {
    if (e.response != null) {
      print(
          'PrintLogInterceptor ${DateTime.now()} - [DIO_ERROR] ${e.response?.statusCode} | ${e.response?.statusMessage}');
    } else {
      print('PrintLogInterceptor ${DateTime.now()} - [DIO_ERROR] ${e.message}');
    }
    // return e?.message == 'refreshing_token'
    //     ? null
    //     : e; //'$e ${e.response?.statusMessage}';

    return super.onError(e, handler);
  }
}
