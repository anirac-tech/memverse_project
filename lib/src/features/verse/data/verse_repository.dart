import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../verse/domain/verse.dart';

abstract class VerseRepository {
  Future<List<Verse>> getVerses();
}

class FakeVerseRepository implements VerseRepository {
  @override
  Future<List<Verse>> getVerses() async {
    await Future.delayed(const Duration(milliseconds: 100));
    return [
      Verse(reference: 'Gal 5:22', text: 'But the fruit of the Spirit is love, joy, peace...'),
      Verse(
        reference: 'Col 1:17',
        text: 'He is before all things, and in him all things hold together.',
      ),
    ];
  }
}

final verseRepositoryProvider = Provider<VerseRepository>((ref) => FakeVerseRepository());
