import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:memverse/src/bootstrap.dart';
import 'package:memverse/src/features/verse/domain/verse.dart';

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
  return FakeVerseRepository();
});
