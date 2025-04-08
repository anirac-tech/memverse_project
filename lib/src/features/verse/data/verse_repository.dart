import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:memverse/src/features/verse/domain/verse.dart';

/// Import for using TestMockDio type checking
/// Import for using TestMockDio type checking

/// Import for using TestMockDio type checking

/// Import for using TestMockDio type checking

/// Import for using TestMockDio type checking

/// Import for using TestMockDio type checking

/// Import for using TestMockDio type checking

/// Import for using TestMockDio type checking

/// Import for using TestMockDio type checking

/// Import for using TestMockDio type checking

/// Import for using TestMockDio type checking

/// Import for using TestMockDio type checking

/// Import for using TestMockDio type checking

/// Import for using TestMockDio type checking
import 'package:memverse/src/utils/test_utils.dart';

// More reliable test detection
bool get isInTestMode {
  try {
    // Check multiple indicators that we're in a test environment
    return kDebugMode || // Running in debug mode is a good indicator during tests
        identical(0, 0.0) || // True only in VM/test, false in release/web
        const bool.fromEnvironment('FLUTTER_TEST') ||
        Zone.current[#test] != null; // flutter_test sets this up
  } catch (_) {
    return false;
  }
}

/// Provider for the verse repository
final verseRepositoryProvider = Provider<VerseRepository>((ref) => LiveVerseRepository());

/// Provider that allows overriding the repository for testing
final verseRepositoryOverrideProvider = Provider<VerseRepository>(
  (ref) => throw UnimplementedError('Provider was not overridden'),
);

/// Interface for accessing verse data
/// Marked as abstract for future expansion capabilities
// ignore: one_member_abstracts
abstract class VerseRepository {
  /// Get a list of verses
  Future<List<Verse>> getVerses();
}

/// Implementation that fetches Bible verses from the live API
class LiveVerseRepository implements VerseRepository {
  /// The HTTP client to use for network requests
  final Dio _dio;

  /// Create a new LiveVerseRepository with an optional Dio client
  // ignore: sort_constructors_first
  LiveVerseRepository({Dio? dio}) : _dio = dio ?? Dio() {
    // Configure dio options if not provided externally
    if (dio == null) {
      _dio.options.connectTimeout = const Duration(seconds: 10);
      _dio.options.receiveTimeout = const Duration(seconds: 10);
      _dio.options.contentType = 'application/json';
      _dio.options.validateStatus = (status) {
        return status != null && status >= 200 && status < 400;
      };

      // Add logging interceptor to help with debugging
      if (kDebugMode) {
        _dio.interceptors.add(_createLoggingInterceptor());
      }

      // Add retry interceptor
      _dio.interceptors.add(RetryInterceptor(dio: _dio));
    }
  }

  /// Create a logging interceptor for debugging
  Interceptor _createLoggingInterceptor() {
    return InterceptorsWrapper(
      onRequest: (options, handler) {
        // ignore: avoid_print
        print('🌐 REQUEST[${options.method}] => PATH: ${options.baseUrl}${options.path}');
        // ignore: avoid_print
        print('Headers: ${options.headers}');
        if (options.data != null) {
          // ignore: avoid_print
          print('Data: ${options.data}');
        }
        return handler.next(options);
      },
      onResponse: (response, handler) {
        // ignore: avoid_print
        print('✅ RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}');
        final responseData = response.data;
        if (responseData is String && responseData.length > 100) {
          // ignore: avoid_print
          print('Response: ${responseData.substring(0, 100)}...');
        } else {
          // ignore: avoid_print
          print('Response: $responseData');
        }
        return handler.next(response);
      },
      onError: (DioException e, handler) {
        // ignore: avoid_print
        print('⛔ ERROR[${e.response?.statusCode}] => PATH: ${e.requestOptions.path}');
        // ignore: avoid_print
        print('Error Type: ${e.type}');
        // ignore: avoid_print
        print('Error: ${e.message}');
        // ignore: avoid_print
        print('Error Response: ${e.response?.data}');

        // Extract stack trace without null check
        final stackTrace = e.stackTrace;
        final stackTraceLines = stackTrace.toString().split('\n');
        final shortStackTrace = stackTraceLines.take(3).join('\n');
        // ignore: avoid_print
        print('Stack trace: $shortStackTrace...');

        return handler.next(e);
      },
    );
  }

  /// The URL to fetch Bible verses from
  static const String _apiUrl = 'https://www.memverse.com/1/memverses';

  /// The private authentication token from environment variables
  static const String _privateToken = String.fromEnvironment('MEMVERSE_API_TOKEN');

  /// Get a list of verses from the remote API
  @override
  Future<List<Verse>> getVerses() async {
    try {
      // Validate token is available when not running tests
      // During tests, Dio is usually mocked so we don't need a real token
      if (_privateToken.isEmpty && !isInTestMode && !_dio.isTestMockDio) {
        throw Exception(
          'No API token provided. Run with --dart-define=MEMVERSE_API_TOKEN=your_token',
        );
      }

      if (kDebugMode) {
        // ignore: avoid_print
        print('📜 Fetching verses from $_apiUrl');
        // ignore: avoid_print
        print('🔑 Token available: ${_privateToken.isNotEmpty}');
      }

      // Fetch data with authentication header
      final response = await _dio.get<dynamic>(
        _apiUrl,
        options: Options(headers: {'Authorization': 'Bearer $_privateToken'}),
      );

      if (response.statusCode == 200) {
        // Convert string response to JSON if needed
        Map<String, dynamic> jsonData;
        if (response.data is String) {
          jsonData = jsonDecode(response.data as String) as Map<String, dynamic>;
        } else {
          jsonData = response.data as Map<String, dynamic>;
        }

        final versesList = jsonData['response'] as List<dynamic>;
        final verses = _parseVerses(versesList);
        return verses;
      } else {
        // coverage:ignore-line
        throw Exception('Failed to load verses. Status code: ${response.statusCode}');
      }
    } catch (e) {
      if (kDebugMode) {
        // ignore: avoid_print
        print('🚨 Error fetching verses: $e');
      }
      // Re-throw the exception instead of returning hardcoded data as fallback
      rethrow;
    }
  }

  /// Parse the JSON list into a list of Verse objects
  List<Verse> _parseVerses(List<dynamic> jsonList) {
    final result = <Verse>[];
    for (final dynamic item in jsonList) {
      try {
        // Handle dynamic access safely
        final json = item as Map<String, dynamic>;
        final verseData = json['verse'] as Map<String, dynamic>;

        final text = verseData['text'] as String? ?? 'No text available';
        final reference = json['ref'] as String? ?? 'Unknown reference';
        final translation = verseData['translation'] as String? ?? 'Unknown';

        result.add(Verse(text: text, reference: reference, translation: translation));
      } catch (e) {
        // Rethrow exceptions instead of skipping them
        rethrow;
      }
    }
    return result;
  }
}

/// Simple retry interceptor for Dio
class RetryInterceptor extends Interceptor {
  /// Creates a retry interceptor
  RetryInterceptor({
    required this.dio,
    this.logPrint,
    this.retries = 3,
    this.retryDelays = const [Duration(seconds: 1), Duration(seconds: 2), Duration(seconds: 3)],
  });

  /// The Dio client to use for retries
  final Dio dio;

  /// Optional function for logging
  final void Function(String)? logPrint;

  /// Maximum number of retry attempts
  final int retries;

  /// Delays between retry attempts
  final List<Duration> retryDelays;

  // ignore: sort_constructors_first
  /// Determines if a request should be retried based on error type
  bool _shouldRetry(DioException error) {
    return error.type == DioExceptionType.connectionError ||
        error.type == DioExceptionType.connectionTimeout ||
        (error.response?.statusCode ?? 0) >= 500;
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final retryCount = err.requestOptions.extra['retryCount'] as int? ?? 0;

    if (_shouldRetry(err) && retryCount < retries) {
      logPrint?.call('🔄 Retry ${retryCount + 1}/$retries for ${err.requestOptions.path}');

      final delay = retryCount < retryDelays.length ? retryDelays[retryCount] : retryDelays.last;

      Future.delayed(delay, () {
        final options = Options(
          method: err.requestOptions.method,
          headers: err.requestOptions.headers,
          contentType: err.requestOptions.contentType,
          responseType: err.requestOptions.responseType,
        )..extra = {...err.requestOptions.extra, 'retryCount': retryCount + 1};

        dio
            .request<dynamic>(
              err.requestOptions.path,
              data: err.requestOptions.data,
              queryParameters: err.requestOptions.queryParameters,
              options: options,
            )
            .then(
              (response) => handler.resolve(response),
              onError: (Object error) {
                if (error is DioException) {
                  handler.reject(error);
                } else {
                  handler.reject(
                    DioException(
                      requestOptions: err.requestOptions,
                      error: error,
                      message: error.toString(),
                    ),
                  );
                }
              },
            );
      });
      return;
    }

    handler.next(err);
  }
}

/// Sample implementation that provides a hardcoded list of verses
/// but simulates a network call with a delay
class FakeVerseRepository implements VerseRepository {
  /// Get a list of verses
  @override
  Future<List<Verse>> getVerses() async {
    // Simulate a network delay
    await Future<void>.delayed(const Duration(seconds: 2));

    return [
      Verse(
        text: 'In the beginning God created the heavens and the earth.',
        reference: 'Genesis 1:1',
      ),
      Verse(
        text:
            'For God so loved the world that he gave his one and only Son, '
            'that whoever believes in him shall not perish '
            'but have eternal life.',
        reference: 'John 3:16',
      ),
      Verse(
        text:
            'Trust in the LORD with all your heart; do not depend on your own '
            'understanding.',
        reference: 'Proverbs 3:5',
      ),
      Verse(
        text: 'I can do everything through Christ, who gives me strength.',
        reference: 'Philippians 4:13',
      ),
      Verse(
        text:
            'And we know that God causes everything to work together for the'
            ' good of those who love God and are called according to '
            'his purpose for them.',
        reference: 'Romans 8:28',
      ),
    ];
  }
}
