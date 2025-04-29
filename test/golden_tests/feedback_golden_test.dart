import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:memverse/src/app/view/app.dart';
import 'package:memverse/src/features/auth/data/auth_service.dart';
import 'package:memverse/src/features/auth/presentation/providers/auth_providers.dart';
import 'package:memverse/src/features/verse/data/verse_repository.dart';
import 'package:memverse/src/features/verse/presentation/memverse_page.dart';
import 'package:mocktail/mocktail.dart';

// Mocks
class MockAuthService extends Mock implements AuthService {}

class MockVerseRepository extends Mock implements VerseRepository {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockAuthService mockAuthService;
  late MockVerseRepository mockVerseRepository;

  setUp(() {
    mockAuthService = MockAuthService();
    mockVerseRepository = MockVerseRepository();

    when(() => mockAuthService.isLoggedIn()).thenAnswer((_) async => true);
    when(() => mockAuthService.getToken()).thenAnswer((_) async => null);
    when(() => mockAuthService.logout()).thenAnswer((_) async {});

    // Mock verse repository to return empty list immediately
    when(() => mockVerseRepository.getVerses()).thenAnswer((_) async => []);
    // Removed mock for currentVerse as it's not part of the interface
  });

  testWidgets('Golden test for Feedback UI overlay via MemversePage', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authServiceProvider.overrideWithValue(mockAuthService),
          verseRepositoryProvider.overrideWithValue(mockVerseRepository),
        ],
        child: const App(),
      ),
    );

    await tester.pumpAndSettle(const Duration(seconds: 1));
    expect(find.byType(MemversePage), findsOneWidget, reason: 'MemversePage should be visible');

    final feedbackButtonFinder = find.widgetWithIcon(FloatingActionButton, Icons.feedback_outlined);
    expect(feedbackButtonFinder, findsOneWidget, reason: 'Feedback FAB should be visible');

    await tester.tap(feedbackButtonFinder);
    await tester.pumpAndSettle(const Duration(seconds: 1));

    final textFieldFinder = find.byType(TextField);
    expect(
      textFieldFinder,
      findsOneWidget,
      reason: 'TextField in feedback overlay should be visible',
    );

    await tester.enterText(textFieldFinder, 'test');
    await tester.pumpAndSettle();

    // Added delay before matching golden
    await Future<void>.delayed(const Duration(milliseconds: 500));

    await expectLater(find.byType(App), matchesGoldenFile('goldens/feedback_ui_overlay_app.png'));
  }, tags: 'golden');
}
