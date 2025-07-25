import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:memverse/src/app/app.dart';
import 'package:memverse/src/bootstrap.dart';
import 'package:memverse/src/features/auth/presentation/providers/auth_providers.dart';
import 'package:memverse/src/features/verse/domain/verse.dart';
import 'package:memverse/src/utils/app_logger.dart';
import 'package:talker_dio_logger/talker_dio_logger_interceptor.dart';
import 'package:talker_dio_logger/talker_dio_logger_settings.dart';

abstract class VerseRepository {
  Future<List<Verse>> getVerses();
}

class FakeVerseRepository implements VerseRepository {
  @override
  Future<List<Verse>> getVerses() async {
    await Future.delayed(const Duration(milliseconds: 100));
    return [
      const Verse(
        reference: 'Gal 5:22',
        text: 'But the fruit of the Spirit is love, joy, peace...',
      ),
      const Verse(
        reference: 'Col 1:17',
        text: 'He is before all things, and in him all things hold together.',
      ),
    ];
  }
}

final verseRepositoryProvider = Provider<VerseRepository>((ref) {
  final clientId = ref.read(bootstrapProvider).clientId;
  if (clientId.isEmpty || clientId == 'debug') {
    return FakeVerseRepository();
  }
  // Add real repository when ready for production, e.g.:
  // return RealVerseRepository(clientId);
  return LiveVerseRepository();
});

/// Implementation that fetches Bible verses from the live API
class LiveVerseRepository implements VerseRepository {
  /// The HTTP client to use for network requests
  final Dio _dio;

  /// Create a new LiveVerseRepository with an optional Dio client
  // ignore: sort_constructors_first
  LiveVerseRepository({Dio? dio}) : _dio = dio ?? Dio() {
    // Configure dio options if not provided externally
    if (dio == null) {
      _dio.options.connectTimeout = const Duration(seconds: 5);
      _dio.options.receiveTimeout = const Duration(seconds: 5);
      _dio.options.contentType = 'application/json';
      _dio.options.validateStatus = (status) {
        return status != null && status >= 200 && status < 400;
      };
    }
    if (appFlavor != 'production' || kDebugMode) {
      _dio.interceptors.add(
        TalkerDioLogger(
          talker: container.read(talkerProvider),
          settings: const TalkerDioLoggerSettings(
            printResponseTime: true,
            printResponseHeaders: true,
            printRequestHeaders: true,
          ),
        ),
      );
    }
  }

  /// The URL to fetch Bible verses from
  static const String _apiUrl = 'https://www.memverse.com/1/memverses';

  /// The private authentication token from environment variables
  //static const String _privateToken = String.fromEnvironment('MEMVERSE_API_TOKEN');

  /// Get a list of verses from the remote API
  @override
  Future<List<Verse>> getVerses() async {
    try {
      final authToken = await container.read(authServiceProvider).getToken();
      if (authToken == null || authToken.accessToken.isEmpty) {
        AppLogger.e('No auth token available');
        return [];
      }
      final privateToken = authToken.accessToken;
      // Fetch data with authentication header
      final response = await _dio.get<dynamic>(
        _apiUrl,
        options: Options(headers: {'Authorization': 'Bearer $privateToken'}),
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
        AppLogger.d('Verses list length: ${versesList.length}');
        final verses = _parseVerses(versesList);
        return verses;
      } else {
        // coverage:ignore-line
        throw Exception('Failed to load verses. Status code: ${response.statusCode}');
      }
    } catch (e) {
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
