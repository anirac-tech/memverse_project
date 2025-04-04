import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:memverse/src/app/app.dart';
import 'package:memverse/src/features/verse/presentation/memverse_page.dart';

/// Usage: the app is running with verses error
Future<void> theAppIsRunningWithVersesError(WidgetTester tester) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [verseListProvider.overrideWith((ref) => throw Exception('Verses error'))],
      child: const App(),
    ),
  );
}
