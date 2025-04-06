import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:memverse/src/features/verse/domain/verse.dart';

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
      _dio.options.connectTimeout = const Duration(seconds: 5);
      _dio.options.receiveTimeout = const Duration(seconds: 5);
      _dio.options.contentType = 'application/json';
      _dio.options.validateStatus = (status) {
        return status != null && status >= 200 && status < 400;
      };
    }
  }

  /// The URL to fetch Bible verses from
  static const String _apiUrl =
      'https://gist.githubusercontent.com/neiljaywarner/2880b87250163386a41e00fc1535e02c/raw';

  /// Get a list of verses from the remote API
  @override
  Future<List<Verse>> getVerses() async {
    try {
      // Fetch data from the gist
      final response = await _dio.get<dynamic>(_apiUrl);

      if (response.statusCode == 200) {
        // Convert string response to JSON if needed
        List<dynamic> jsonList;
        if (response.data is String) {
          jsonList = jsonDecode(response.data as String) as List<dynamic>;
        } else {
          jsonList = response.data as List<dynamic>;
        }

        final verses = _parseVerses(jsonList);
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

        final text = json['text'] as String? ?? 'No text available';
        final reference = json['ref'] as String? ?? 'Unknown reference';

        result.add(Verse(text: text, reference: reference));
      } catch (e) {
        // Rethrow exceptions instead of skipping them
        rethrow;
      }
    }
    return result;
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
