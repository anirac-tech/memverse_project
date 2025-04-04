import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:memverse/src/app/view/app.dart';

void main() {
  group('App', () {
    testWidgets('renders correctly', (WidgetTester tester) async {
      await tester.pumpWidget(const ProviderScope(child: App()));
      await tester.pumpAndSettle();

      // Verify the App contains the correct components
      expect(find.byType(MaterialApp), findsOneWidget);
    });

    testWidgets('uses correct theme', (WidgetTester tester) async {
      await tester.pumpWidget(const ProviderScope(child: App()));
      await tester.pumpAndSettle();

      final context = tester.element(find.byType(MaterialApp));
      final theme = Theme.of(context);
      expect(theme, isNotNull);
      expect(theme.colorScheme.primary, isNotNull);
    });
  });
}
