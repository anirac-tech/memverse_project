import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

// Mock MemversePage for golden testing
class MockMemversePage extends StatelessWidget {
  const MockMemversePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Memverse Page')),
      body: const SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              Card(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    'For God so loved the world that he gave his one and only Son, that whoever believes in him shall not perish but have eternal life.',
                  ),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                decoration: InputDecoration(labelText: 'Reference', border: OutlineInputBorder()),
              ),
              SizedBox(height: 16),
              ElevatedButton(onPressed: null, child: Text('Submit')),
            ],
          ),
        ),
      ),
    );
  }
}

void main() {
  group('MemversePage Golden Test', () {
    setUp(() async {
      // Create the goldens directories if they don't exist
      await Directory('test/src/features/verse/presentation/goldens').create(recursive: true);
    });

    testWidgets('Renders correctly in portrait mode', (WidgetTester tester) async {
      // Set portrait screen size
      tester.view.physicalSize = const Size(1080, 1920);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(const MaterialApp(home: MockMemversePage()));

      // Wait for any async operations to complete
      await tester.pumpAndSettle();

      await expectLater(
        find.byType(MockMemversePage),
        matchesGoldenFile('goldens/memverse_page_portrait.png'),
      );
    }, tags: ['golden']);

    testWidgets('Renders correctly in landscape mode', (WidgetTester tester) async {
      // Set landscape screen size
      tester.view.physicalSize = const Size(1920, 1080);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(const MaterialApp(home: MockMemversePage()));

      // Wait for any async operations to complete
      await tester.pumpAndSettle();

      await expectLater(
        find.byType(MockMemversePage),
        matchesGoldenFile('goldens/memverse_page_landscape.png'),
      );
    }, tags: ['golden']);
  });
}
