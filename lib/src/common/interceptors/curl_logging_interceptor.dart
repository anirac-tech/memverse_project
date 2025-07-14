import 'package:dio/dio.dart';
import 'package:memverse/src/utils/app_logger.dart';

class CurlLoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    _printCurlCommand(options);
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    AppLogger.d('RESPONSE: ${response.statusCode}');
    AppLogger.d('Response Headers: ${response.headers}');
    AppLogger.d('Response Body: ${response.data}');
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    AppLogger.e('ERROR: ${err.message}');
    AppLogger.d('Request URL: ${err.requestOptions.uri}');
    AppLogger.d('Request Headers: ${err.requestOptions.headers}');
    AppLogger.d('Request Data: ${err.requestOptions.data}');
    if (err.response != null) {
      AppLogger.e('Error Response: ${err.response?.data}');
      AppLogger.e('Status Code: ${err.response?.statusCode}');
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
        curl += " \\\n  -d '${options.data}'";
      } else {
        curl += " \\\n  -d '${options.data}'";
      }
    }

    curl += ' \\\n  -v';

    AppLogger.d('cURL Command:');
    AppLogger.d(curl);
    AppLogger.d('---');
  }
}
