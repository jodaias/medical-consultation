import 'package:dio/dio.dart';

///https://github.com/flutterchina/dio/issues/1445
class EncodingOdataQueryInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (options.queryParameters.isEmpty) {
      super.onRequest(options, handler);
      return;
    }

    final queryParams = _getQueryParams(options.queryParameters);
    handler.next(
      options.copyWith(
        path: _getNormalizedUrl(options.path, queryParams),
        queryParameters: Map.from({}),
      ),
    );
  }

  @override
  void onError(DioException e, ErrorInterceptorHandler handler) {
    return super.onError(e, handler);
  }

  String _getNormalizedUrl(String baseUrl, String queryParams) {
    if (baseUrl.contains('?')) {
      return baseUrl + '&$queryParams';
    } else {
      return baseUrl + '?$queryParams';
    }
  }

  String _getQueryParams(Map<String, dynamic> map) {
    var result = '';
    map.forEach((key, value) {
      // result += '$key=${Uri.encodeComponent(value)}&';
      // Query no Odata o valor será sempre uma string do jeito que tem q ir. nn precisa fazer encode de ",", nn vai ter espaço, lista etc.
      result += '$key=$value&';
    });
    return result;
  }
}
