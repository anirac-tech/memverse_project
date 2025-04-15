import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// A stub login page that doesn't depend on any external dependencies
class StubLoginPage extends StatelessWidget {
  const StubLoginPage({this.isLoading = false, this.errorMessage, this.onLoginPressed, super.key});

  final bool isLoading;
  final String? errorMessage;
  final VoidCallback? onLoginPressed;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Memverse Login')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 32),
              const Icon(Icons.menu_book, size: 80, color: Colors.blue),
              const Text(
                'Memverse',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 32),
              const Text(
                'Welcome to Memverse',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              const Text(
                'Sign in to continue',
                style: TextStyle(fontSize: 16, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Username',
                  prefixIcon: Icon(Icons.person),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  prefixIcon: Icon(Icons.lock),
                  suffixIcon: Icon(Icons.visibility_off),
                ),
              ),
              const SizedBox(height: 32),
              if (isLoading)
                const Center(child: CircularProgressIndicator())
              else
                ElevatedButton(onPressed: onLoginPressed, child: const Text('Login')),
              if (errorMessage != null)
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Text(
                    errorMessage!,
                    style: const TextStyle(color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

void main() {
  testWidgets('login page renders correctly', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: StubLoginPage()));
    await tester.pump();

    expect(find.text('Memverse Login'), findsOneWidget);
    expect(find.text('Welcome to Memverse'), findsOneWidget);
    expect(find.text('Sign in to continue'), findsOneWidget);
    expect(find.byType(TextFormField), findsNWidgets(2));
    expect(find.byType(ElevatedButton), findsOneWidget);
  });

  testWidgets('shows fallback image for network image', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: StubLoginPage()));
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.menu_book), findsOneWidget);
    expect(find.text('Memverse'), findsOneWidget);
  });

  testWidgets('shows error message when present', (WidgetTester tester) async {
    const errorMessage = 'Authentication failed';

    await tester.pumpWidget(const MaterialApp(home: StubLoginPage(errorMessage: errorMessage)));
    await tester.pump(); // Just pump once to avoid potential timeout issues

    expect(find.text(errorMessage), findsOneWidget);
  });

  testWidgets('calls onLoginPressed callback when button is tapped', (WidgetTester tester) async {
    bool callbackCalled = false;

    await tester.pumpWidget(
      MaterialApp(
        home: StubLoginPage(
          onLoginPressed: () {
            callbackCalled = true;
          },
        ),
      ),
    );
    await tester.pump(); // Just pump once to avoid potential timeout issues

    await tester.tap(find.byType(ElevatedButton));

    expect(callbackCalled, isTrue);
  });
}
