import 'package:dio/dio.dart';

class RequestResult {
  dynamic data;
  Exception? error;
  bool get success => error == null;
}

class RestResult<T> {
  late T data;
  Exception? error;
  bool get success => error == null;
}

class RestListResult<T> extends RestResult<List<T>> {}

class RestException implements Exception {
  final String message;
  RestException(this.message);
}

abstract class Rest {
  Dio dio = Dio();

  String get restUrl;
  late String defaultContentType;
  final _permaQuery = <String, dynamic>{};
  late int connectTimeout;
  late int receiveTimeout;

  Rest({
    this.connectTimeout = 30000,
    this.receiveTimeout = 30000,
    this.defaultContentType = 'application/json',
  });

  String composeUrl(String path) {
    final uri = Uri.parse(restUrl);
    final host = uri.host;
    final port = uri.hasPort ? uri.port : null;
    final isHttps = uri.scheme == 'https';
    // Remove barra inicial do path, se houver
    final normalizedPath = path.startsWith('/') ? path.substring(1) : path;

    final composedUri = Uri(
      scheme: isHttps ? 'https' : 'http',
      host: host,
      port: port ?? (isHttps ? 443 : 80),
      path: '/api/$normalizedPath',
    );
    return composedUri.toString();
  }

  void addInterceptor(Interceptor interceptor) =>
      dio.interceptors.add(interceptor);
  void removeInterceptor(Interceptor interceptor) =>
      dio.interceptors.remove(interceptor);
  bool hasInterceptor(Interceptor interceptor) =>
      dio.interceptors.contains(interceptor);

  void addPermanentQuery(String name, String value) {
    _permaQuery[name] = value;
  }

  void removePermanentQuery(String name) {
    _permaQuery.remove(name);
  }

  Future<RequestResult> _get(
    String path, {
    Map<String, dynamic>? query,
    Options? options,
    bool monitorPerformance = false,
  }) async {
    final res = RequestResult();

    try {
      var resRest = await dio.get<dynamic>(
        composeUrl(path),
        queryParameters: (query ?? <String, dynamic>{})..addAll(_permaQuery),
        options: _buildOptions(options),
      );
      res.data = resRest.data;
    } catch (e) {
      res.error = e as Exception;
    }
    return res;
  }

  Future<RequestResult> _post(
    String path,
    dynamic data, {
    String? contenttype,
    Map<String, dynamic>? query,
    Options? options,
  }) async {
    final res = RequestResult();
    try {
      options ??= Options();
      options.contentType = contenttype ?? defaultContentType;

      var resRest = await dio.post<dynamic>(
        composeUrl(path),
        data: data,
        queryParameters: (query ?? <String, dynamic>{})..addAll(_permaQuery),
        options: _buildOptions(options),
      );
      res.data = resRest.data;
    } catch (e) {
      res.error = e as Exception;
    }
    return res;
  }

  Future<RequestResult> _patch(
    String path,
    dynamic data, {
    String? contenttype,
    Map<String, dynamic>? query,
    Options? options,
  }) async {
    final res = RequestResult();
    try {
      options ??= Options();
      options.contentType = contenttype ?? defaultContentType;

      var resRest = await dio.patch<dynamic>(
        composeUrl(path),
        data: data,
        queryParameters: (query ?? <String, dynamic>{})..addAll(_permaQuery),
        options: _buildOptions(options),
      );
      res.data = resRest.data;
    } catch (e) {
      res.error = e as Exception;
    }
    return res;
  }

  Future<RequestResult> _put(
    String path,
    dynamic data, {
    String? contenttype,
    Map<String, dynamic>? query,
    Options? options,
  }) async {
    final res = RequestResult();
    try {
      options ??= Options();
      options.contentType = contenttype ?? defaultContentType;

      var resRest = await dio.put<dynamic>(
        composeUrl(path),
        data: data,
        queryParameters: (query ?? <String, dynamic>{})..addAll(_permaQuery),
        options: _buildOptions(options),
      );
      res.data = resRest.data;
    } catch (e) {
      res.error = e as Exception;
    }
    return res;
  }

  Future<RequestResult> _delete(
    String path,
    dynamic data, {
    String? contenttype,
    Map<String, dynamic>? query,
    Options? options,
  }) async {
    var res = RequestResult();
    try {
      options ??= Options();
      options.contentType = contenttype ?? defaultContentType;

      var resRest = await dio.delete<dynamic>(
        composeUrl(path),
        data: data,
        queryParameters: (query ?? <String, dynamic>{})..addAll(_permaQuery),
        options: _buildOptions(options),
      );
      res.data = resRest.data;
    } catch (e) {
      res.error = e as Exception;
    }
    return res;
  }

  Future<RestResult<T>> getModel<T>(
    String path,
    T Function(dynamic) parse, {
    Map<String, dynamic>? query,
    Options? options,
    bool monitorPerformance = false,
  }) async =>
      _parseRequest(
          await _get(path,
              query: query,
              options: options,
              monitorPerformance: monitorPerformance),
          parse);

  Future<RestResult<List<T>>> getList<T>(
    String path,
    T Function(Map<String, dynamic>? mp) parse, {
    Map<String, dynamic>? query,
    Options? options,
    bool monitorPerformance = false,
  }) async =>
      _parseRequest(
          await _get(
            path,
            query: query,
            options: options,
            monitorPerformance: monitorPerformance,
          ),
          (d) => _parseList(d, parse));

  Future<RestResult<T>> postModel<T>(
    String path,
    dynamic body, {
    T Function(dynamic)? parse,
    Map<String, dynamic>? query,
    Options? options,
  }) async =>
      _parseRequest(await _post(path, body, query: query, options: options),
          parse ?? (_) => _);

  Future<RestResult<T>> patchModel<T>(
    String path,
    dynamic body, {
    T Function(dynamic)? parse,
    Map<String, dynamic>? query,
    Options? options,
  }) async =>
      _parseRequest(await _patch(path, body, query: query, options: options),
          parse ?? (_) => _);

  Future<RestResult<List<T>>> postList<T>(
    String path,
    dynamic body,
    T Function(dynamic) parse, {
    Map<String, dynamic>? query,
    Options? options,
  }) async =>
      _parseRequest(await _post(path, body, query: query, options: options),
          (d) => _parseList(d, parse));

  Future<RestResult<T>> deleteModel<T>(
    String path,
    dynamic body, {
    T Function(dynamic)? parse,
    Map<String, dynamic>? query,
    Options? options,
  }) async =>
      _parseRequest(await _delete(path, body, query: query, options: options),
          parse ?? (_) => _);

  Future<RestResult<List<T>>> deleteList<T>(
    String path,
    dynamic body,
    T Function(dynamic) parse, {
    Map<String, dynamic>? query,
    Options? options,
  }) async =>
      _parseRequest(await _delete(path, body, query: query, options: options),
          (d) => _parseList(d, parse));

  Future<RestResult<T>> putModel<T>(
    String path, {
    dynamic body,
    T Function(dynamic)? parse,
    Map<String, dynamic>? query,
    Options? options,
  }) async =>
      _parseRequest(await _put(path, body, query: query, options: options),
          parse ?? (_) => _);

  Future<RestResult<List<T>>> putList<T>(
    String path,
    dynamic body,
    T Function(dynamic) parse, {
    Map<String, dynamic>? query,
    Options? options,
  }) async =>
      _parseRequest(await _put(path, body, query: query, options: options),
          (d) => _parseList(d, parse));

  List<T> _parseList<T>(
          dynamic itens, T Function(Map<String, dynamic>? item) parse) =>
      (itens as List<dynamic>).map((e) => parse(e)).toList();

  RestResult<T> _parseRequest<T>(
      RequestResult response, T Function(dynamic) parse) {
    final res = RestResult<T>();
    if (response.success) {
      res.data = parse(response.data);
    } else {
      res.error = response.error;
    }
    return res;
  }

  Options? _buildOptions(Options? options) {
    if (options == null) return null;
    return options.copyWith(
      sendTimeout: Duration(milliseconds: connectTimeout),
      receiveTimeout: Duration(milliseconds: receiveTimeout),
    );
  }
}
