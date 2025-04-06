import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:memverse/src/app/app.dart';
import 'package:memverse/src/features/verse/data/verse_repository.dart';

Future<void> theAppIsRunning(WidgetTester tester) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [verseRepositoryProvider.overrideWith((ref) => FakeVerseRepository())],
      child: const App(),
    ),
  );
}
