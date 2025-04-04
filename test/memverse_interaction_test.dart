import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:memverse/l10n/arb/app_localizations.dart';
import 'package:memverse/src/features/verse/data/verse_repository.dart';
import 'package:memverse/src/features/verse/presentation/memverse_page.dart';
import 'package:mocktail/mocktail.dart';

class MockAppLocalizations extends Mock implements AppLocalizations {}

void main() {
  group('MemversePage interaction tests', () {
    late ProviderContainer container;
    late FakeVerseRepository mockRepository;

    setUp(() {
      mockRepository = FakeVerseRepository();

      // Override the provider for testing
      container = ProviderContainer(
        overrides: [verseListProvider.overrideWith((_) => mockRepository.getVerses())],
      );
    });

    tearDown(() {
      container.dispose();
    });

    testWidgets('submitting a valid reference processes answer correctly', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(
            home: MemversePage(),
            locale: Locale('en'),
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
          ),
        ),
      );

      // Wait for initial data to load
      await tester.pumpAndSettle();

      // Enter correct answer
      await tester.enterText(find.byType(TextField), 'Genesis 1:1');
      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();

      // Should show a snackbar with success message
      expect(find.byType(SnackBar), findsOneWidget);

      // Wait for the automatic transition to next verse (1.5 seconds)
      await tester.pump(const Duration(milliseconds: 1500));
      await tester.pump(); // pump again to process the future

      // Check that the TextField is cleared
      expect(tester.widget<TextField>(find.byType(TextField)).controller?.text, isEmpty);
    });

    testWidgets('submitting an invalid format shows validation error', (WidgetTester tester) async {
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(
            home: MemversePage(),
            locale: Locale('en'),
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
          ),
        ),
      );

      // Wait for initial data to load
      await tester.pumpAndSettle();

      // Enter invalid format
      await tester.enterText(find.byType(TextField), 'Genesis:1:1');
      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();

      // Should show a snackbar with error message
      expect(find.byType(SnackBar), findsOneWidget);
    });
  });
}
