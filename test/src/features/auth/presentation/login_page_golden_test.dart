import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Mock the LoginPage for testing
class MockLoginPage extends StatelessWidget {
  const MockLoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Memverse Login')),
      body: const Center(child: Text('Login Page Mock')),
    );
  }
}

void main() {
  group('LoginPage Golden Test', () {
    setUp(() async {
      // Create the goldens directory if it doesn't exist
      await Directory('test/src/features/auth/presentation/goldens').create(recursive: true);
    });

    testWidgets('Renders correctly', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: MockLoginPage()));

      await expectLater(find.byType(MockLoginPage), matchesGoldenFile('goldens/login_page.png'));
    }, tags: ['golden'],);
  });
}
