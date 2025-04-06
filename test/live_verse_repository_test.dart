import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:memverse/src/features/verse/data/verse_repository.dart';

void main() {
  group('LiveVerseRepository', () {
    test('Fetches and parses real data from the API', () async {
      // Make a real API request to verify the content
      final client = http.Client();
      final response = await client.get(
        Uri.parse(
          'https://gist.githubusercontent.com/neiljaywarner/2880b87250163386a41e00fc1535e02c/raw',
        ),
      );
      expect(response.statusCode, 200);
      expect(response.body.contains('Col 1:17'), isTrue);
      expect(response.body.contains('Phil 4:13'), isTrue);

      // Test that the VerseRepositoryProvider returns a LiveVerseRepository
      final repositoryInstance = VerseRepositoryProvider.instance;
      expect(repositoryInstance, isA<LiveVerseRepository>());

      // Test that fetching verses returns data from the API
      final verses = await repositoryInstance.getVerses();
      expect(verses.length, 2);

      // Check first verse content
      expect(verses[0].reference, 'Col 1:17');
      expect(verses[0].text, contains('He existed before anything else'));

      // Check second verse content
      expect(verses[1].reference, 'Phil 4:13');
      expect(verses[1].text, contains('For I can do everything through Christ'));
    });
  });
}
