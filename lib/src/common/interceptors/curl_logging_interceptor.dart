import 'package:dio/dio.dart';

class CurlLoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    _printCurlCommand(options);
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    print('✅ RESPONSE: ${response.statusCode}');
    print('📝 Response Headers: ${response.headers}');
    print('📦 Response Body: ${response.data}');
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    print('❌ ERROR: ${err.message}');
    print('🔍 Request URL: ${err.requestOptions.uri}');
    print('📝 Request Headers: ${err.requestOptions.headers}');
    print('📦 Request Data: ${err.requestOptions.data}');
    if (err.response != null) {
      print('📥 Error Response: ${err.response?.data}');
      print('🔢 Status Code: ${err.response?.statusCode}');
    }
    super.onError(err, handler);
  }

  void _printCurlCommand(RequestOptions options) {
    final uri = options.uri;
    var curl = 'curl -X ${options.method.toUpperCase()} "$uri"';

    // Add headers
    options.headers.forEach((key, value) {
      curl += ' \\\n  -H "$key: $value"';
    });

    // Add data if present
    if (options.data != null) {
      if (options.data is String) {
        curl += ' \\\n  -d \'${options.data}\'';
      } else {
        curl += ' \\\n  -d \'${options.data.toString()}\'';
      }
    }

    curl += ' \\\n  -v';

    print('🚀 cURL Command:');
    print(curl);
    print('---');
  }
}
