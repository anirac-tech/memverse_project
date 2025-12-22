import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:memverse/main.dart';

// Helper to compute contrast ratio (simplified for test)
double luminance(Color color) {
  final r = color.red / 255.0;
  final g = color.green / 255.0;
  final b = color.blue / 255.0;
  final channels = [
    r,
    g,
    b,
  ].map((v) => v <= 0.03928 ? v / 12.92 : pow((v + 0.055) / 1.055, 2.4) as double).toList();
  return 0.2126 * channels[0] + 0.7152 * channels[1] + 0.0722 * channels[2];
}

double contrastRatio(Color a, Color b) {
  final l1 = luminance(a) + 0.05;
  final l2 = luminance(b) + 0.05;
  return l1 > l2 ? l1 / l2 : l2 / l1;
}

void main() {
  testWidgets('BottomNavigationBar colors meet accessibility contrast', (
    WidgetTester tester,
  ) async {
    final testWidget = MaterialApp(home: TabScaffold(child: Container()));
    await tester.pumpWidget(testWidget);
    await tester.pumpAndSettle();
    final state = tester.state(find.byType(BottomNavigationBar));
    final bnb = state.widget as BottomNavigationBar;

    final contrastSelected = contrastRatio(TabScaffold.navBg, TabScaffold.navSelected);
    final contrastUnselected = contrastRatio(TabScaffold.navBg, TabScaffold.navGray);

    expect(contrastSelected, greaterThanOrEqualTo(4.5), reason: 'Selected tab contrast too low');
    expect(
      contrastUnselected,
      greaterThanOrEqualTo(4.5),
      reason: 'Unselected tab contrast too low',
    );
  });
}
