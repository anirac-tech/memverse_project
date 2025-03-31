import 'package:memverse/src/features/verse/domain/verse.dart';

class VerseRepositoryProvider {
  static final instance = FakeVerseRepository();
}

abstract class VerseRepository {
  /// Get a list of verses
  Future<List<Verse>> getVerses();
}

/// Sample implementation that provides a hardcoded list of verses
/// but simulates a network call with a delay
class FakeVerseRepository implements VerseRepository {
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
        text: 'For God so loved the world that he gave his one and only Son, '
            'that whoever believes in him shall not perish '
            'but have eternal life.',
        reference: 'John 3:16',
      ),
      Verse(
        text: 'Trust in the LORD with all your heart; do not depend on your own '
            'understanding.',
        reference: 'Proverbs 3:5',
      ),
      Verse(
        text: 'I can do everything through Christ, who gives me strength.',
        reference: 'Philippians 4:13',
      ),
      Verse(
        text: 'And we know that God causes everything to work together for the'
            ' good of those who love God and are called according to '
            'his purpose for them.',
        reference: 'Romans 8:28',
      ),
    ];
  }
}